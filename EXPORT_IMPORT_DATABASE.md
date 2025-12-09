# Export Data from Local Database and Import to Render

## Step 1: Export Data from Your Local Database

### If using SQLite (local):
```bash
cd "/Users/hesamoddinsaeedi/Desktop/best/backup copy 64/myshop2/myshop"

# Export specific apps
python manage.py dumpdata shop accounts suppliers > local_data.json

# OR export everything
python manage.py dumpdata --exclude auth.permission --exclude contenttypes > local_data.json
```

### If using PostgreSQL (local):
```bash
# Export from local PostgreSQL
python manage.py dumpdata shop accounts suppliers > local_data.json
```

## Step 2: Import to Render Database

### Option A: Using Render Shell (Recommended)

1. Go to Render Dashboard → Your Web Service → **Shell** tab
2. Click "Open Shell"
3. Run:

```bash
# Make sure you're in the right directory
cd /opt/render/project/src/myshop2/myshop

# Create a file with your exported data
# (You'll need to copy/paste the JSON content or upload it)
# For now, let's use sample data generation instead
```

### Option B: Create Sample Data on Render

In Render Shell, run:

```bash
cd /opt/render/project/src/myshop2/myshop

# Create sample products
python manage.py create_sample_products

# OR create demo product
python manage.py create_demo_product

# OR create product with variants
python manage.py create_product_with_variants --sample
```

## Step 3: Create Admin User (Important!)

```bash
python manage.py createsuperuser
# Enter: username, email, password
```

## Option C: Upload Data File to Render

1. Upload your `local_data.json` file to a public URL (GitHub Gist, Dropbox, etc.)
2. In Render Shell:
```bash
# Download the file
curl -o local_data.json https://your-file-url.com/local_data.json

# Import it
python manage.py loaddata local_data.json
```

