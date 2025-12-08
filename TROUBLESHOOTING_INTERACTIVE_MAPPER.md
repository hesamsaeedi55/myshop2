# Troubleshooting: Interactive Mapper Not Showing

If you see a blank page or "nothing appeared" at:
```
https://your-app.onrender.com/image-editor/interactive-mapper/
```

## Common Issues & Solutions

### Issue 1: Migrations Not Run ⚠️ (Most Likely)

**Symptom:** Blank page, 500 error, or page loads but shows nothing

**Solution:** Run migrations first!

#### Option A: Via Render Shell (Fastest)
1. Go to Render Dashboard → Your Web Service → **Shell**
2. Run:
```bash
cd myshop2/myshop
python manage.py makemigrations image_editor
python manage.py migrate image_editor
```

#### Option B: Automatic on Next Deployment
Just push your code - migrations will run automatically:
```bash
git add .
git commit -m "Add interactive mapper"
git push
```

### Issue 2: Template Not Found

**Symptom:** 404 or TemplateDoesNotExist error

**Check:**
- Template should be at: `myshop2/myshop/templates/image_editor/interactive_mapper.html`
- Verify it exists in your repository

**Fix:**
```bash
# Make sure template is in the right place
ls myshop2/myshop/templates/image_editor/interactive_mapper.html
```

### Issue 3: Database Connection Error

**Symptom:** Error connecting to database

**Check:**
```bash
# In Render Shell
cd myshop2/myshop
python manage.py dbshell
```

**Fix:** Verify `DATABASE_URL` is set in Render environment variables

### Issue 4: Static Files Not Collected

**Symptom:** Page loads but CSS/JS missing

**Fix:**
```bash
# In Render Shell or build command
python manage.py collectstatic --no-input
```

### Issue 5: CSRF Token Issues

**Symptom:** 403 Forbidden errors when uploading

**Check:** Make sure CSRF middleware is enabled in settings.py

### Issue 6: Model Import Error

**Symptom:** ImportError or NameError in logs

**Check logs:**
1. Go to Render Dashboard → Your Web Service → **Logs**
2. Look for error messages

**Fix:** Make sure `image_editor` is in `INSTALLED_APPS` in settings.py

## Quick Diagnostic Steps

### Step 1: Check if migrations exist
```bash
cd myshop2/myshop
python manage.py showmigrations image_editor
```

Should show:
```
image_editor
 [X] 0001_initial
 [X] 0002_interactiveimage_interactiveregion  (or similar)
```

### Step 2: Check if tables exist
```bash
python manage.py dbshell
```

Then in PostgreSQL:
```sql
\dt image_editor_*
```

Should show:
- `image_editor_interactiveimage`
- `image_editor_interactiveregion`

### Step 3: Test the view directly
```bash
python manage.py shell
```

Then:
```python
from image_editor.models import InteractiveImage
InteractiveImage.objects.all()
# Should return <QuerySet []> (empty is OK, means model works)
```

### Step 4: Check URL routing
Visit:
```
https://your-app.onrender.com/image-editor/api/interactive/
```

Should return JSON (even if empty):
```json
{"images": [], "count": 0}
```

## Expected Behavior

After migrations run successfully:

1. **Page loads:** You see the upload interface
2. **No errors:** Browser console shows no errors
3. **API works:** `/image-editor/api/interactive/` returns JSON

## Still Not Working?

1. **Check Render Logs:**
   - Dashboard → Your Service → **Logs**
   - Look for error messages

2. **Check Browser Console:**
   - Open Developer Tools (F12)
   - Check Console tab for JavaScript errors
   - Check Network tab for failed requests

3. **Test API directly:**
   ```bash
   curl https://your-app.onrender.com/image-editor/api/interactive/
   ```

4. **Verify URL pattern:**
   - Make sure `image-editor/` is included in main `urls.py`
   - Check `image_editor/urls.py` has the route

## Quick Fix Checklist

- [ ] Migrations created: `makemigrations image_editor`
- [ ] Migrations applied: `migrate image_editor`
- [ ] Template exists: `templates/image_editor/interactive_mapper.html`
- [ ] `image_editor` in `INSTALLED_APPS`
- [ ] URL routing correct in `urls.py`
- [ ] Static files collected
- [ ] No errors in Render logs

## Need Help?

If still not working, check:
1. Render deployment logs for errors
2. Browser console for JavaScript errors
3. Network tab for failed API calls
4. Verify the exact error message


