from django.core.management.base import BaseCommand
from django.core.management import call_command
from django.db.models.signals import post_save
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
        try:
            # Disconnect the signal that causes issues during loaddata
            post_save.disconnect(inherit_parent_attributes_for_new_category, sender=Category)
            
            call_command('loaddata', 'initial_data.json', verbosity=1)
            
            self.stdout.write(
                self.style.SUCCESS('Successfully imported initial data!')
            )
        except Exception as e:
            self.stdout.write(
                self.style.ERROR(f'Error importing data: {str(e)}')
            )
            raise
        finally:
            # Reconnect the signal after loading
            post_save.connect(inherit_parent_attributes_for_new_category, sender=Category)

