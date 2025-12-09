from django.core.management.base import BaseCommand
from django.core.management import call_command
from django.db.models.signals import post_save
from django.db import IntegrityError, transaction, connection
from shop import models as shop_models
from shop.signals import inherit_parent_attributes_for_new_category
import shop.signals

class Command(BaseCommand):
    help = 'Import initial data if database is empty'

    def handle(self, *args, **options):
        # Check if database already has products
        product_count = shop_models.Product.objects.count()
        
        if product_count > 0:
            self.stdout.write(
                self.style.WARNING(
                    f'Database already has {product_count} products. Skipping data import.'
                )
            )
            return
        
        # Database is empty, import data
        self.stdout.write('Database is empty. Importing initial data...')
        
        # Clear ALL shop-related data to avoid ID conflicts
        self.stdout.write('Clearing existing shop data to avoid ID conflicts...')
        try:
            vendor = connection.vendor
            if vendor == "postgresql":
                # Fast truncate with cascade and identity reset
                with connection.cursor() as cursor:
                    cursor.execute(
                        """
                        TRUNCATE TABLE
                            shop_productimage,
                            shop_productvariant,
                            shop_product,
                            shop_categoryattribute,
                            shop_attributevalue,
                            shop_tag,
                            shop_category
                        RESTART IDENTITY CASCADE;
                        """
                    )
                self.stdout.write('Cleared existing shop data (TRUNCATE).')
            else:
                # Fallback for sqlite/other: delete in reverse dependency order
                shop_models.ProductImage.objects.all().delete()
                shop_models.ProductVariant.objects.all().delete()
                shop_models.Product.objects.all().delete()
                shop_models.CategoryAttribute.objects.all().delete()
                shop_models.AttributeValue.objects.all().delete()
                shop_models.Tag.objects.all().delete()
                shop_models.Category.objects.all().delete()
                self.stdout.write('Cleared existing shop data (DELETE).')
        except Exception as e:
            self.stdout.write(f'Note when clearing: {str(e)[:100]}')
        
        # Disable signals during fixture loading to avoid dependency issues
        signal_disconnected = False
        try:
            # Disconnect the signal that causes issues during loaddata
            post_save.disconnect(inherit_parent_attributes_for_new_category, sender=shop_models.Category)
            signal_disconnected = True
            
            # Import with transaction handling to handle duplicates gracefully
            import json
            from django.core.serializers import deserialize
            from django.db import transaction
            
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
            
            # Import in order: categories first, then attributes (to avoid signal issues)
            import_order = [
                'shop.category',
                'shop.tag',
                'shop.categoryattribute',
                'shop.attributevalue',
                'shop.product',
                'shop.productimage',
                'shop.productvariant',
            ]
            
            # Add any other models
            for model_name in by_model.keys():
                if model_name not in import_order:
                    import_order.append(model_name)
            
            # Import in order
            for model_name in import_order:
                if model_name not in by_model:
                    continue
                    
                objects = by_model[model_name]
                self.stdout.write(f'Importing {len(objects)} {model_name} records...')
                
                for obj_data in objects:
                    try:
                        # Upsert logic per model
                        if model_name == 'shop.category':
                            fields = obj_data.get('fields', {})
                            shop_models.Category.objects.update_or_create(
                                pk=obj_data.get('pk'),
                                defaults=fields
                            )
                            imported += 1
                        elif model_name == 'shop.tag':
                            fields = obj_data.get('fields', {})
                            shop_models.Tag.objects.update_or_create(
                                pk=obj_data.get('pk'),
                                defaults=fields
                            )
                            imported += 1
                        elif model_name == 'shop.categoryattribute':
                            fields = obj_data.get('fields', {})
                            shop_models.CategoryAttribute.objects.update_or_create(
                                pk=obj_data.get('pk'),
                                defaults=fields
                            )
                            imported += 1
                        elif model_name == 'shop.attributevalue':
                            fields = obj_data.get('fields', {})
                            shop_models.AttributeValue.objects.update_or_create(
                                pk=obj_data.get('pk'),
                                defaults=fields
                            )
                            imported += 1
                        elif model_name == 'shop.product':
                            fields = obj_data.get('fields', {})
                            shop_models.Product.objects.update_or_create(
                                pk=obj_data.get('pk'),
                                defaults=fields
                            )
                            imported += 1
                        elif model_name == 'shop.productimage':
                            fields = obj_data.get('fields', {})
                            shop_models.ProductImage.objects.update_or_create(
                                pk=obj_data.get('pk'),
                                defaults=fields
                            )
                            imported += 1
                        elif model_name == 'shop.productvariant':
                            fields = obj_data.get('fields', {})
                            shop_models.ProductVariant.objects.update_or_create(
                                pk=obj_data.get('pk'),
                                defaults=fields
                            )
                            imported += 1
                        else:
                            # For any other models, fall back to deserialize
                            for obj in deserialize('json', json.dumps([obj_data])):
                                obj.save()
                            imported += 1
                    except Exception as e:
                        skipped += 1
                        if skipped <= 5:
                            self.stdout.write(
                                f"  ⚠️  Error/skip: {model_name} pk={obj_data.get('pk')}: {str(e)[:120]}"
                            )
            
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
                    post_save.connect(inherit_parent_attributes_for_new_category, sender=shop_models.Category)
                except:
                    pass  # Signal might already be connected

