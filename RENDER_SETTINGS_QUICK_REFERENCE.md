# Render Settings - Quick Reference

## ⚙️ Settings to Configure in Render Dashboard

### 1. Root Directory
**Location:** Settings → Root Directory
**Value:** `myshop2/myshop`

---

### 2. Build Command
**Location:** Settings → Build Command
**Value:**
```bash
pip install -r requirements.txt && python manage.py makemigrations image_editor && python manage.py migrate --no-input && python manage.py collectstatic --no-input
```

---

### 3. Start Command
**Location:** Settings → Start Command
**Value:**
```bash
gunicorn myshop.wsgi:application
```

---

### 4. Environment Variables
**Location:** Environment tab

Add these variables:

| Variable | Value | Notes |
|----------|-------|-------|
| `SECRET_KEY` | Generate | Click "Generate" button |
| `DATABASE_URL` | Your DB URL | See below |
| `PYTHON_VERSION` | `3.10` | Python version |
| `WEB_CONCURRENCY` | `4` | Worker processes |

---

## 🔧 How to Change Settings

1. **Go to your Web Service** in Render dashboard
2. **Click "Settings"** tab (left sidebar)
3. **Scroll down** to find:
   - Root Directory
   - Build Command
   - Start Command
4. **Edit and Save** each setting
5. **Go to "Environment"** tab for environment variables
6. **Add/Edit** environment variables
7. **Click "Save Changes"**
8. **Go to "Manual Deploy"** → **"Deploy latest commit"**

---

## 📋 Copy-Paste Values

### Build Command:
```bash
pip install -r requirements.txt && python manage.py makemigrations image_editor && python manage.py migrate --no-input && python manage.py collectstatic --no-input
```

### Start Command:
```bash
gunicorn myshop.wsgi:application
```

### Root Directory:
```
myshop2/myshop
```

---

## ✅ Checklist

Before deploying, make sure:
- [ ] Root Directory = `myshop2/myshop`
- [ ] Build Command is correct (copied above)
- [ ] Start Command is correct (copied above)
- [ ] `SECRET_KEY` is set
- [ ] `DATABASE_URL` is set (either Render DB or Supabase)
- [ ] `PYTHON_VERSION` = `3.10`
- [ ] `WEB_CONCURRENCY` = `4`
- [ ] All changes saved
- [ ] Manual deploy triggered

---

## 🚨 If Stuck at Deploy

1. **Check Logs** tab for errors
2. **Verify** all settings match above
3. **Clear Build Cache:**
   - Settings → Scroll to bottom
   - Click "Clear Build Cache"
   - Deploy again
4. **Check** if database is running (if using Render DB)
5. **Verify** `DATABASE_URL` format is correct

---

## 📝 Database URL Format

### Render PostgreSQL:
```
postgresql://user:password@host:port/dbname
```
(Get from Database → Info → Internal Database URL)

### Supabase:
```
postgresql://postgres.xxxxx:password@aws-0-us-west-1.pooler.supabase.com:6543/postgres
```
(Get from Supabase Dashboard → Settings → Database → Connection String)

---

## 🎯 Quick Fix Steps

1. **Settings** → **Root Directory** → `myshop2/myshop` → Save
2. **Settings** → **Build Command** → Paste above → Save
3. **Settings** → **Start Command** → Paste above → Save
4. **Environment** → Add variables → Save
5. **Manual Deploy** → Deploy latest commit
6. **Watch Logs** → Wait 5-10 minutes

---

**That's it!** Your deployment should work now! 🚀

