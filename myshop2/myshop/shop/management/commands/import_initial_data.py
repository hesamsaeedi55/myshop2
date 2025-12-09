from django.core.management.base import BaseCommand
from django.core.management import call_command
from django.db.models.signals import post_save
from django.db import IntegrityError, transaction
from shop.models import Product, Category, CategoryAttribute
from shop.signals import inherit_parent_attributes_for_new_category
import shop.signals

class Command(BaseCommand):
    help = 'Import initial data if database is empty'

    def handle(self, *args, **options):
        # Check if database already has products
        product_count = Product.objects.count()
        
        if product_count > 0:
            self.stdout.write(
                self.style.WARNING(
                    f'Database already has {product_count} products. Skipping data import.'
                )
            )
            return
        
        # Database is empty, import data
        self.stdout.write('Database is empty. Importing initial data...')
        
        # Disable signals during fixture loading to avoid dependency issues
        signal_disconnected = False
        try:
            # Disconnect the signal that causes issues during loaddata
            post_save.disconnect(inherit_parent_attributes_for_new_category, sender=Category)
            signal_disconnected = True
            
            # Import with transaction handling to handle duplicates gracefully
            import json
            from django.core.serializers import deserialize
            
            fixture_file = 'shop/fixtures/initial_data.json'
            with open(fixture_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            imported = 0
            skipped = 0
            
            # Group by model type for better error handling
            by_model = {}
            for obj_data in data:
                model_name = obj_data.get('model', 'unknown')
                if model_name not in by_model:
                    by_model[model_name] = []
                by_model[model_name].append(obj_data)
            
            # Import each model type
            for model_name, objects in by_model.items():
                self.stdout.write(f'Importing {len(objects)} {model_name} records...')
                for obj_data in objects:
                    try:
                        for obj in deserialize('json', json.dumps([obj_data])):
                            obj.save()
                        imported += 1
                    except IntegrityError as e:
                        # Duplicate or constraint violation - skip it
                        skipped += 1
                        if skipped <= 5:  # Only show first few
                            self.stdout.write(f'  ⚠️  Skipped duplicate: {model_name} pk={obj_data.get("pk")}')
                    except Exception as e:
                        # Other error - log but continue
                        skipped += 1
                        if 'duplicate' in str(e).lower() or 'unique' in str(e).lower():
                            pass  # Expected duplicate
                        else:
                            self.stdout.write(f'  ⚠️  Error: {model_name} pk={obj_data.get("pk")}: {str(e)[:100]}')
            
            self.stdout.write(
                self.style.SUCCESS(
                    f'✅ Import completed: {imported} imported, {skipped} skipped (duplicates/existing)'
                )
            )
                
        except Exception as e:
            self.stdout.write(
                self.style.ERROR(f'Error importing data: {str(e)[:300]}')
            )
            # Continue deployment even if import has issues
            self.stdout.write(
                self.style.WARNING('Continuing deployment despite import errors...')
            )
        finally:
            # Reconnect the signal after loading
            if signal_disconnected:
                try:
                    post_save.connect(inherit_parent_attributes_for_new_category, sender=Category)
                except:
                    pass  # Signal might already be connected

