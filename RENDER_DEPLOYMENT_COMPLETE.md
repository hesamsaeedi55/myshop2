# Complete Render Deployment Guide

Your project is ready to deploy to Render! Follow these steps:

## ✅ What's Already Done

- ✅ Code is on GitHub: `hesamsaeedi55/myshop2`
- ✅ `render.yaml` is configured
- ✅ Settings are production-ready
- ✅ Database configuration supports PostgreSQL
- ✅ Static files configured
- ✅ Security settings enabled for production

---

## Step 1: Sign Up / Login to Render

1. Go to [dashboard.render.com](https://dashboard.render.com)
2. Sign up for a free account (or login if you already have one)
3. Verify your email if needed

---

## Step 2: Connect Your GitHub Account

1. In Render dashboard, click your **profile icon** (top right)
2. Go to **"Account Settings"**
3. Click **"Connect GitHub"** or the **"GitHub"** tab
4. Click **"Connect GitHub"** button
5. Authorize Render to access your repositories
6. Select **"All repositories"** or just `myshop2`
7. Click **"Install"** or **"Authorize"**

---

## Step 3: Create Database (PostgreSQL)

1. In Render dashboard, click **"New +"** → **"PostgreSQL"**
2. Configure:
   - **Name:** `myshop2-db` (must match render.yaml)
   - **Database:** `myshop2`
   - **User:** `myshop2`
   - **Region:** Choose closest to your users (or `Oregon (US West)` for free tier)
   - **PostgreSQL Version:** `16` (latest stable)
   - **Plan:** Start with **Free** tier
3. Click **"Create Database"**
4. Wait 2-3 minutes for database to be created
5. **Copy the Internal Database URL** - you'll need it later

---

## Step 4: Create Web Service

### Option A: Using render.yaml (Recommended - Automatic Setup)

1. In Render dashboard, click **"New +"** → **"Blueprint"**
2. Click **"Connect account"** next to GitHub (if not connected)
3. Select repository: **`hesamsaeedi55/myshop2`**
4. Render will automatically detect `render.yaml`
5. Click **"Apply"**
6. Render will create both the database and web service automatically
7. Skip to **Step 5**

### Option B: Manual Setup (If Blueprint doesn't work)

1. Click **"New +"** → **"Web Service"**
2. Connect to GitHub repository: **`hesamsaeedi55/myshop2`**
3. Configure:
   - **Name:** `myshop2`
   - **Region:** Same as database
   - **Branch:** `main`
   - **Root Directory:** (leave empty - root is correct)
   - **Environment:** `Python 3`
   - **Build Command:**
     ```bash
     pip install -r requirements.txt && cd myshop2/myshop && python manage.py makemigrations image_editor && python manage.py migrate --no-input && python manage.py collectstatic --no-input
     ```
   - **Start Command:**
     ```bash
     cd myshop2/myshop && gunicorn myshop.wsgi:application
     ```
4. Click **"Advanced"** → **"Add Environment Variable"**:
   - `PYTHON_VERSION` = `3.10.0`
   - `SECRET_KEY` = (click "Generate" to auto-generate)
   - `DATABASE_URL` = (use the database connection string from Step 3)
   - `WEB_CONCURRENCY` = `4`
5. Click **"Create Web Service"**

---

## Step 5: Configure Environment Variables

Go to your Web Service → **"Environment"** tab and add:

### Required Variables:

1. **`SECRET_KEY`**
   - Click **"Generate"** or use a random string
   - Keep this secret!

2. **`DATABASE_URL`**
   - Go to your Database → **"Info"** tab
   - Copy **"Internal Database URL"**
   - Paste it here
   - Format: `postgresql://user:password@host:port/dbname`

3. **`PYTHON_VERSION`** = `3.10.0`

4. **`WEB_CONCURRENCY`** = `4`

### Optional (If you need email):

5. **`EMAIL_HOST_USER`** = Your email (e.g., `hamiltonwatchbrands@gmail.com`)
6. **`EMAIL_HOST_PASSWORD`** = Your email app password
7. **`DEFAULT_FROM_EMAIL`** = Your email

### Optional (If using S3 for media files):

8. **`AWS_ACCESS_KEY_ID`** = Your AWS key
9. **`AWS_SECRET_ACCESS_KEY`** = Your AWS secret
10. **`AWS_STORAGE_BUCKET_NAME`** = Your bucket name
11. **`AWS_S3_REGION_NAME`** = `us-east-1` (or your region)

---

## Step 6: Wait for Deployment

1. After creating the service, Render will:
   - Install dependencies
   - Run migrations
   - Collect static files
   - Start your app

2. **First deployment takes 5-10 minutes**

3. Watch the **"Logs"** tab for progress

4. When you see: `"Your service is live at https://myshop2.onrender.com"` → Success! ✅

---

## Step 7: Create Superuser (Admin Account)

After deployment succeeds:

1. Go to your Web Service → **"Shell"** tab (or use **"Logs"** → **"Shell"**)
2. Run:
   ```bash
   cd myshop2/myshop
   python manage.py createsuperuser
   ```
3. Enter:
   - Username
   - Email
   - Password (twice)
4. Save the credentials!

5. Access admin panel: `https://myshop2.onrender.com/admin/`

---

## Step 8: Test Your Deployment

1. **Homepage:** `https://myshop2.onrender.com/`
2. **Admin:** `https://myshop2.onrender.com/admin/`
3. **API:** `https://myshop2.onrender.com/api/`
4. **API Docs:** Check your API endpoints

---

## Step 9: Enable Auto-Deploy (Already Configured!)

✅ Auto-deploy is enabled by default when using `render.yaml`

**Every time you push to GitHub:**
- Render detects the change
- Starts a new deployment
- Runs migrations automatically
- Deploys latest code
- Your app updates in 3-5 minutes!

---

## Troubleshooting

### Build Fails

1. **Check Logs:**
   - Go to Service → **"Logs"** tab
   - Look for error messages

2. **Common Issues:**
   - Missing dependency → Add to `requirements.txt`
   - Migration error → Check migration files
   - Database connection → Verify `DATABASE_URL`
   - Import error → Check Python paths

### Database Connection Error

1. Verify `DATABASE_URL` is set correctly
2. Check database is running (Status should be "Available")
3. Use **Internal Database URL** (not External)
4. Format: `postgresql://user:pass@host:port/dbname`

### Static Files Not Loading

1. Check `STATIC_ROOT` in settings.py
2. Verify `collectstatic` runs in build command
3. Check `STATIC_URL` starts with `/`

### 500 Error After Deployment

1. Check **"Logs"** for Python errors
2. Verify all environment variables are set
3. Check `SECRET_KEY` is set
4. Verify database migrations completed

### App Takes Too Long to Load

- Free tier spins down after 15 minutes of inactivity
- First request after spin-down takes 30-60 seconds
- This is normal for free tier
- Upgrade to paid plan to avoid spin-down

---

## Environment Variables Reference

```bash
# Required
SECRET_KEY=<auto-generated or random string>
DATABASE_URL=<from database connection string>
PYTHON_VERSION=3.10.0
WEB_CONCURRENCY=4

# Optional - Email
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
DEFAULT_FROM_EMAIL=your-email@gmail.com

# Optional - S3 Storage
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
AWS_STORAGE_BUCKET_NAME=your-bucket
AWS_S3_REGION_NAME=us-east-1

# Optional - Google OAuth (if using)
GOOGLE_CLIENT_ID=your-client-id
GOOGLE_CLIENT_SECRET=your-client-secret
```

---

## Free Tier Limitations

- ⚠️ Service spins down after 15 min inactivity
- ⚠️ 750 hours/month free (enough for always-on)
- ⚠️ 512 MB RAM
- ⚠️ Limited CPU

**Recommendation:** Start with free tier, upgrade when needed.

---

## Next Steps After Deployment

1. ✅ Test all API endpoints
2. ✅ Create admin user
3. ✅ Import initial data (categories, products)
4. ✅ Test user registration/login
5. ✅ Configure custom domain (optional)
6. ✅ Set up SSL certificate (automatic on Render)
7. ✅ Configure monitoring/alerts

---

## Custom Domain Setup (Optional)

1. Go to your Web Service → **"Settings"** → **"Custom Domains"**
2. Add your domain: `yourdomain.com`
3. Follow DNS configuration instructions
4. Render provides free SSL certificate
5. Wait 5-10 minutes for DNS propagation

---

## Quick Commands Reference

```bash
# View logs
# (In Render Dashboard → Service → Logs)

# Run migrations manually
cd myshop2/myshop
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Collect static files
python manage.py collectstatic --no-input

# Shell access
# (In Render Dashboard → Service → Shell)
```

---

## Support

- **Render Docs:** [render.com/docs](https://render.com/docs)
- **Render Status:** [status.render.com](https://status.render.com)
- **Community:** [community.render.com](https://community.render.com)

---

## Summary Checklist

- [ ] Signed up for Render
- [ ] Connected GitHub account
- [ ] Created PostgreSQL database
- [ ] Created Web Service
- [ ] Set environment variables
- [ ] Deployment completed successfully
- [ ] Created superuser
- [ ] Tested homepage and admin
- [ ] Auto-deploy is working

**Your app URL:** `https://myshop2.onrender.com` (or your custom domain)

🎉 **Congratulations! Your Django app is now live!**

