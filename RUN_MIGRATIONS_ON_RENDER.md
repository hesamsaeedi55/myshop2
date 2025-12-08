# Running Image Editor Migrations on Render

## Option 1: Automatic (Recommended) - Next Deployment

The migrations will **automatically run** on your next deployment because:

1. The `build.sh` script now creates migrations for `image_editor` if needed
2. The `render.yaml` buildCommand runs `python manage.py migrate --no-input`
3. Just push your code and deploy - migrations will run automatically!

**Steps:**
```bash
# Commit the new models and build script
git add .
git commit -m "Add InteractiveImage models and migration setup"
git push

# Render will automatically:
# 1. Create migrations (makemigrations)
# 2. Run migrations (migrate)
# 3. Deploy your app
```

## Option 2: Manual - Run Now via Render Shell

If you want to run migrations **right now** without waiting for deployment:

### Step 1: Access Render Shell

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click on your **Web Service** (myshop2)
3. Click on **"Shell"** tab (or use the terminal icon)
4. This opens a shell connected to your Render instance

### Step 2: Navigate to Project Directory

```bash
cd myshop2/myshop
```

### Step 3: Create Migrations

```bash
python manage.py makemigrations image_editor
```

### Step 4: Run Migrations

```bash
python manage.py migrate image_editor
```

### Step 5: Verify

```bash
python manage.py showmigrations image_editor
```

You should see:
```
image_editor
 [X] 0001_initial
 [X] 0002_interactiveimage_interactiveregion  (or similar)
```

## Option 3: Use the Migration Script

I've created a script that does everything:

```bash
# On Render Shell
cd myshop2/myshop
chmod +x run_image_editor_migrations.sh
./run_image_editor_migrations.sh
```

## What Gets Created

The migrations will create two new tables:

1. **`image_editor_interactiveimage`**
   - Stores uploaded images
   - Fields: id, name, image, created_at, updated_at

2. **`image_editor_interactiveregion`**
   - Stores coordinate regions
   - Fields: id, interactive_image_id, region_id, label, x_percent, y_percent, etc.

## Troubleshooting

### If migrations fail:

1. **Check database connection:**
   ```bash
   python manage.py dbshell
   ```

2. **Check migration status:**
   ```bash
   python manage.py showmigrations
   ```

3. **Reset if needed (⚠️ DANGEROUS - only if no data):**
   ```bash
   python manage.py migrate image_editor zero
   python manage.py migrate image_editor
   ```

### If you see "No changes detected":

The models might not be registered. Check:
- `image_editor/models.py` has the new models
- `image_editor/apps.py` is properly configured
- Django can import the models

## Verification After Migration

Once migrations are complete, you can:

1. **Access the mapper:**
   ```
   https://your-app.onrender.com/image-editor/interactive-mapper/
   ```

2. **Test the API:**
   ```bash
   curl https://your-app.onrender.com/image-editor/api/interactive/
   ```

3. **Check admin (if registered):**
   ```
   https://your-app.onrender.com/admin/image_editor/
   ```

## Next Steps

After migrations are complete:

1. ✅ Access the coordinate mapper web interface
2. ✅ Upload your first fashion brand image
3. ✅ Mark coordinates for watch, suit, boots, hat
4. ✅ Use the API in your iOS app

---

**Note:** The automatic migration (Option 1) is recommended as it's the safest and ensures migrations run on every deployment.


