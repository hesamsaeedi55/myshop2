# Complete Guide: Setting Up Render with GitHub

This guide walks you through creating a Render web service connected to your GitHub repository `hesamsaeedi55/myshop2`.

---

## 📋 Prerequisites

Before starting, make sure:
- ✅ Your code is pushed to GitHub repository `hesamsaeedi55/myshop2`
- ✅ Your repository is public OR you'll grant Render access to private repos
- ✅ You have a GitHub account

---

## Step 1: Create Render Account & Connect GitHub

### 1.1 Sign Up for Render

1. Go to [https://dashboard.render.com](https://dashboard.render.com)
2. Click the **"Get Started for Free"** or **"Sign Up"** button
3. **Choose "Continue with GitHub"** (recommended - easiest method)
   - This automatically connects your GitHub account to Render
   - One-click authentication, no need to remember another password

### 1.2 Authorize Render Access

1. GitHub will ask you to authorize Render
2. Click **"Authorize render"** button
3. You may see options to select which repositories to grant access to:
   - **Option A (Recommended):** Select **"Only select repositories"** and choose `myshop2`
   - **Option B:** Select **"All repositories"** if you plan to deploy multiple projects
4. Click **"Install & Authorize"**

✅ **Success:** You'll be redirected to Render dashboard

---

## Step 2: Verify Repository Access

1. In Render dashboard, you should see a welcome screen
2. Click **"New +"** button (top right) or **"New"** → **"Web Service"**
3. You should see your GitHub repositories listed
4. **Look for `hesamsaeedi55/myshop2`** in the list
5. If you don't see it:
   - Click **"Configure Render's GitHub App"** or **"Grant access"**
   - Follow prompts to authorize the repository

---

## Step 3: Create PostgreSQL Database ⚠️ CRITICAL - DO NOT SKIP!

**🔴 YES, YOU ABSOLUTELY NEED POSTGRESQL!**

**Why PostgreSQL is REQUIRED:**
- ❌ SQLite (your local DB) **cannot be used in production** - it's too slow and unreliable
- ✅ PostgreSQL is the **production-grade database** you need
- ✅ Your Django settings are **already configured** to use PostgreSQL when `DATABASE_URL` is set
- ✅ Without PostgreSQL, your app **will not work** on Render

**Why create it FIRST?** You need the database URL before creating the web service (you'll paste it as an environment variable).

---

### ⚡ Quick Check: Your Code is Ready!

Your `settings.py` is already configured correctly:
```python
# This code in your settings.py will automatically:
# 1. Check for DATABASE_URL environment variable
# 2. Connect to PostgreSQL if DATABASE_URL exists
# 3. Fall back to SQLite only for local development
DATABASE_URL = os.environ.get('DATABASE_URL')
if DATABASE_URL:
    DATABASES = {'default': dj_database_url.config(default=DATABASE_URL)}
```

✅ You have `psycopg2-binary` in requirements.txt (PostgreSQL adapter)
✅ You have `dj-database-url` in requirements.txt (parses DATABASE_URL)
✅ Your settings.py automatically detects and uses PostgreSQL

**So YES, this will work!** ✅

### 3.1 Create Database

1. In Render dashboard, click **"New +"** → **"PostgreSQL"**
2. Fill in the form:

   | Field | Value |
   |-------|-------|
   | **Name** | `myshop2-db` (or any name you prefer) |
   | **Database** | `myshop2` (or leave default) |
   | **User** | `myshop2_user` (or leave default) |
   | **Region** | `Oregon (US West)` or closest to your users |
   | **PostgreSQL Version** | `16` (or latest available) |
   | **Plan** | **Free** (for testing) |

3. Click **"Create Database"**

### 3.2 Wait for Database Creation

- ⏳ This takes **2-3 minutes**
- You'll see "Creating..." status
- When ready, status changes to **"Available"** ✅

### 3.3 Get Database URL

1. Click on your database name (`myshop2-db`)
2. Go to **"Info"** tab (in the left sidebar)
3. Scroll down to **"Connections"** section
4. Find **"Internal Database URL"**
5. **Click the copy icon** 📋 to copy the URL
   - It looks like: `postgresql://user:password@hostname:5432/dbname`
   - **IMPORTANT:** Use the **Internal** URL (not External)
   - Internal URL only works within Render's network (more secure)

6. **Save this URL** - you'll need it in Step 4!

---

## Step 4: Create Web Service

### 4.1 Start Web Service Creation

1. Click **"New +"** → **"Web Service"**
2. You'll see a list of GitHub repositories
3. **Click on `hesamsaeedi55/myshop2`**
4. You'll be taken to the configuration page

### 4.2 Configure Basic Settings

Fill in the following:

| Field | Value | Notes |
|-------|-------|-------|
| **Name** | `myshop2` | Your service name (will be `myshop2.onrender.com`) |
| **Region** | Same as database | Choose same region as PostgreSQL for better performance |
| **Branch** | `main` | Your default branch (or `master` if different) |
| **Root Directory** | `myshop2/myshop` | ⚠️ **CRITICAL** - Where your Django project lives |
| **Environment** | `Python 3` | Auto-detected, but verify |
| **Instance Type** | **Free** | For testing (upgrade later if needed) |

### 4.3 Configure Build & Start Commands

#### Build Command:
```bash
pip install -r requirements.txt && python manage.py makemigrations image_editor && python manage.py migrate --no-input && python manage.py collectstatic --no-input
```

**Copy and paste this exactly** into the "Build Command" field.

#### Start Command:
```bash
gunicorn myshop.wsgi:application
```

**Copy and paste this exactly** into the "Start Command" field.

⚠️ **Note:** These commands assume Root Directory is set correctly!

### 4.4 Add Environment Variables

Click **"Add Environment Variable"** button for each variable:

| Key | Value | How to Get |
|-----|-------|------------|
| **SECRET_KEY** | (Generate or create) | Click "Generate" button OR create a random 50-character string |
| **DATABASE_URL** | (Your DB URL) | Paste the Internal Database URL from Step 3.3 |
| **PYTHON_VERSION** | `3.10` | Python version (or `3.11` if preferred) |
| **WEB_CONCURRENCY** | `4` | Number of worker processes |

**To add each variable:**
1. Click **"Add Environment Variable"**
2. Enter the **Key** (e.g., `SECRET_KEY`)
3. Enter the **Value**
4. For `SECRET_KEY`, click the **"Generate"** button if available
5. Click **"Add"** or press Enter

**Repeat for all 4 variables.**

### 4.5 Review & Create

1. **Scroll down** and review all settings:
   - ✅ Name, Region, Branch correct?
   - ✅ Root Directory = `myshop2/myshop`?
   - ✅ Build Command pasted correctly?
   - ✅ Start Command pasted correctly?
   - ✅ All 4 environment variables added?

2. Click **"Create Web Service"** button

---

## Step 5: Wait for Deployment

### 5.1 Monitor Deployment

1. You'll be redirected to the service dashboard
2. Click the **"Logs"** tab to watch progress
3. You'll see output like:
   ```
   ==> Cloning from https://github.com/hesamsaeedi55/myshop2.git
   ==> Checking out commit abc123...
   ==> Building...
   ==> Installing dependencies...
   ==> Running migrations...
   ==> Collecting static files...
   ==> Starting service...
   ```

### 5.2 Deployment Timeline

- **Cloning:** ~30 seconds
- **Installing dependencies:** 2-5 minutes
- **Running migrations:** 30 seconds - 2 minutes
- **Collecting static files:** 1-2 minutes
- **Starting service:** ~30 seconds

**Total:** Usually **5-10 minutes** for first deployment

### 5.3 Success Indicators

✅ **Deployment Successful:**
- Status shows **"Live"** (green indicator)
- Logs show: `"Your service is live at https://myshop2.onrender.com"`
- No red error messages

❌ **If Deployment Fails:**
- Status shows **"Build Failed"** or **"Deploy Failed"**
- Check the **"Logs"** tab for error messages
- Common issues:
  - Wrong Root Directory
  - Missing requirements.txt
  - Database connection error
  - Invalid environment variables

---

## Step 6: Create Admin User

After successful deployment:

### 6.1 Open Service Shell

1. In your web service dashboard, click **"Shell"** tab (left sidebar)
2. Click **"Connect"** or **"Open Shell"**
3. A terminal window will open

### 6.2 Create Superuser

Run this command in the shell:
```bash
python manage.py createsuperuser
```

You'll be prompted to enter:
- **Username:** (choose one, e.g., `admin`)
- **Email address:** (your email)
- **Password:** (enter twice - must be strong)

✅ **Success:** You'll see `Superuser created successfully.`

### 6.3 Access Admin Panel

1. Go to: `https://myshop2.onrender.com/admin/`
2. Login with your superuser credentials
3. You should see the Django admin interface!

---

## Step 7: Test Your Deployment

### 7.1 Test URLs

Visit these URLs in your browser:

- **Homepage:** `https://myshop2.onrender.com/`
- **Admin Panel:** `https://myshop2.onrender.com/admin/`
- **API Endpoints:** `https://myshop2.onrender.com/api/...` (your API routes)

### 7.2 Verify Everything Works

- ✅ Homepage loads
- ✅ Admin panel accessible
- ✅ Database connection works
- ✅ Static files loading (CSS, images)
- ✅ API endpoints responding

---

## Step 8: Enable Auto-Deploy (Already On!)

Auto-deploy is **enabled by default**. Every time you:

1. Push code to GitHub (to the `main` branch)
2. Render detects the change automatically
3. Starts a new deployment
4. Your site updates in 3-5 minutes

**To verify:**
1. Go to your service → **"Settings"** tab
2. Check **"Auto-Deploy"** section
3. Should show: **"Yes"** for auto-deploy

---

## 🔧 Troubleshooting Common Issues

### Issue 1: "Repository Not Found"

**Solution:**
- Make sure you authorized Render to access `myshop2` repository
- Go to GitHub → Settings → Applications → Authorized OAuth Apps
- Find Render and ensure repository access is granted

### Issue 2: "Build Failed - No such file or directory"

**Solution:**
- Verify **Root Directory** is `myshop2/myshop`
- Check that `requirements.txt` exists in that directory
- Verify the path structure matches your GitHub repository

### Issue 3: "Database Connection Error"

**Solution:**
- Check `DATABASE_URL` environment variable is set
- Verify you used the **Internal Database URL** (not External)
- Make sure database status is "Available"
- Check the URL format is correct

### Issue 4: "Static Files Not Loading"

**Solution:**
- Verify `collectstatic` is in the build command
- Check `STATIC_ROOT` in settings.py
- Ensure static files are committed to GitHub

### Issue 5: "Module Not Found"

**Solution:**
- Check `requirements.txt` includes all dependencies
- Verify build command runs `pip install -r requirements.txt`
- Check logs for missing package names

### Issue 6: "502 Bad Gateway"

**Solution:**
- Check service is "Live" (not crashed)
- View logs for Python errors
- Verify start command is correct
- Check if gunicorn is in requirements.txt

---

## 📝 Quick Reference Checklist

Use this checklist when setting up:

- [ ] Created Render account
- [ ] Connected GitHub account
- [ ] Authorized repository access
- [ ] Created PostgreSQL database
- [ ] Copied Internal Database URL
- [ ] Created Web Service
- [ ] Set Root Directory to `myshop2/myshop`
- [ ] Configured Build Command
- [ ] Configured Start Command
- [ ] Added `SECRET_KEY` environment variable
- [ ] Added `DATABASE_URL` environment variable
- [ ] Added `PYTHON_VERSION` environment variable
- [ ] Added `WEB_CONCURRENCY` environment variable
- [ ] Deployment completed successfully
- [ ] Created superuser
- [ ] Tested homepage
- [ ] Tested admin panel

---

## 🎯 Next Steps After Deployment

1. **Set up custom domain** (optional):
   - Settings → Custom Domain
   - Add your domain (e.g., `shopterest.ir`)

2. **Set up email** (if needed):
   - Add email environment variables
   - Configure SMTP settings

3. **Monitor performance**:
   - Check Logs regularly
   - Monitor service uptime
   - Set up alerts (if on paid plan)

4. **Backup database**:
   - Render free tier doesn't include automatic backups
   - Consider manual backups or upgrade to paid plan

---

## 🆘 Getting Help

- **Render Docs:** [https://render.com/docs](https://render.com/docs)
- **Render Community:** [https://community.render.com](https://community.render.com)
- **Check Logs:** Always check the Logs tab first for errors

---

## ✅ Success!

Your Django application is now live on Render at:
**`https://myshop2.onrender.com`**

🎉 **Congratulations!** You've successfully deployed your application!

---

**Last Updated:** 2024
**Repository:** `hesamsaeedi55/myshop2`
**Project Path:** `myshop2/myshop/`

