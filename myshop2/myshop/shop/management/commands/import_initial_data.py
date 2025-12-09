from django.core.management.base import BaseCommand
from django.core.management import call_command
from shop.models import Product

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
        try:
            call_command('loaddata', 'initial_data.json', verbosity=1)
            self.stdout.write(
                self.style.SUCCESS('Successfully imported initial data!')
            )
        except Exception as e:
            self.stdout.write(
                self.style.ERROR(f'Error importing data: {str(e)}')
            )
            raise
