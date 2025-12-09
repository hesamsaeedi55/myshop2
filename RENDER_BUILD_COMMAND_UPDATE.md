# UPDATE BUILD COMMAND IN RENDER DASHBOARD

## ⚠️ CRITICAL: Render is using OLD build command from dashboard settings!

The render.yaml has the correct command, but Render is using the dashboard settings instead.

## Fix: Update Build Command in Render Dashboard

1. Go to **Render Dashboard** → Your Web Service (`myshop2`)
2. Click **"Settings"** tab (left sidebar)
3. Scroll down to **"Build Command"**
4. **REPLACE** the entire build command with this:

```bash
pip install -r requirements.txt && python manage.py makemigrations image_editor && python manage.py migrate --no-input && python manage.py import_initial_data || echo "Data import completed or skipped" && python manage.py collectstatic --no-input
```

5. Click **"Save Changes"**
6. Go to **"Manual Deploy"** tab → Click **"Deploy latest commit"**

## What This Command Does:

1. ✅ Installs dependencies
2. ✅ Creates migrations for image_editor
3. ✅ Runs all migrations
4. ✅ **IMPORTS YOUR DATA** (141 products, categories, customers, etc.)
5. ✅ Collects static files

## After Deployment:

Check the logs - you should see:
- "Database is empty. Importing initial data..."
- "Successfully imported initial data!"

Then your products will appear on the site!
