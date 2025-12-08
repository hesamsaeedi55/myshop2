# Quick Fix for Render Deployment

## The Problem
Build can't find `manage.py` after changing directories.

## Solution Options

### Option 1: Update Build Command in Render Dashboard

1. Go to your Web Service on Render
2. Click **"Settings"** tab
3. Scroll to **"Build Command"**
4. Replace it with:

```bash
pip install -r myshop2/myshop/requirements.txt && cd myshop2/myshop && python manage.py makemigrations image_editor && python manage.py migrate --no-input && python manage.py collectstatic --no-input
```

5. Scroll to **"Start Command"**
6. Make sure it's:

```bash
cd myshop2/myshop && gunicorn myshop.wsgi:application
```

7. Click **"Save Changes"**
8. Go to **"Manual Deploy"** → **"Deploy latest commit"**

---

### Option 2: Check Root Directory Setting

1. Go to your Web Service → **"Settings"**
2. Look for **"Root Directory"** field
3. Try setting it to: `myshop2/myshop`
4. Then update Build Command to (no cd needed):

```bash
pip install -r requirements.txt && python manage.py makemigrations image_editor && python manage.py migrate --no-input && python manage.py collectstatic --no-input
```

5. And Start Command to:

```bash
gunicorn myshop.wsgi:application
```

---

### Option 3: Use Absolute Paths

Update Build Command to:

```bash
pip install -r myshop2/myshop/requirements.txt && python myshop2/myshop/manage.py makemigrations image_editor && python myshop2/myshop/manage.py migrate --no-input && python myshop2/myshop/manage.py collectstatic --no-input
```

And Start Command to:

```bash
cd myshop2/myshop && gunicorn myshop.wsgi:application
```

---

## Which Option to Try First?

**Try Option 2 first** (Root Directory) - it's the cleanest solution!

If that doesn't work, try Option 1.

