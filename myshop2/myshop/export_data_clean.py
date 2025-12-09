#!/usr/bin/env python
"""Export database data with error handling"""
import os
import django
import sys

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myshop.settings')
django.setup()

from django.core.management import call_command
from io import StringIO

def export_data():
    """Export data with error handling"""
    print("Starting data export...")
    
    # Export each app separately to avoid issues
    apps = ['shop', 'accounts', 'suppliers']
    
    all_data = []
    for app in apps:
        print(f"Exporting {app}...")
        try:
            output = StringIO()
            call_command('dumpdata', app, 
                       '--natural-foreign', 
                       '--natural-primary',
                       '--indent', '2',
                       stdout=output,
                       stderr=sys.stderr)
            output.seek(0)
            data_str = output.read()
            
            if data_str.strip():
                import json
                app_data = json.loads(data_str)
                if isinstance(app_data, list):
                    all_data.extend(app_data)
                    print(f"  ✅ {app}: {len(app_data)} records")
                else:
                    all_data.append(app_data)
                    print(f"  ✅ {app}: 1 record")
        except Exception as e:
            print(f"  ⚠️  {app}: Error - {str(e)}")
            continue
    
    # Save to file
    import json
    output_file = 'shop/fixtures/initial_data.json'
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(all_data, f, indent=2, ensure_ascii=False)
    
    print(f"\n✅ Exported {len(all_data)} total records to {output_file}")
    return len(all_data)

if __name__ == '__main__':
    count = export_data()
    sys.exit(0 if count > 0 else 1)
