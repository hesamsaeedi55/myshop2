# Complete Guide: GitHub to Render Automatic Deployment

## Step 1: Connect Your Project to GitHub

### Option A: Create a New GitHub Repository (Recommended)

1. **Go to GitHub:**
   - Visit [github.com](https://github.com) and sign in
   - Click the **"+"** icon in the top right → **"New repository"**

2. **Create Repository:**
   - **Repository name:** `myshop2` (or your preferred name)
   - **Description:** "E-commerce Django backend with interactive image mapper"
   - **Visibility:** Choose Private (recommended) or Public
   - **DO NOT** check "Initialize with README" (you already have files)
   - Click **"Create repository"**

3. **Copy the repository URL:**
   - GitHub will show you commands - copy the HTTPS URL
   - It looks like: `https://github.com/YOUR_USERNAME/myshop2.git`

### Option B: Use Existing GitHub Repository

If you already have a GitHub repository, just copy its URL.

---

## Step 2: Connect Your Local Project to GitHub

Run these commands in your terminal:

```bash
# Navigate to your project
cd "/Users/hesamoddinsaeedi/Desktop/best/backup copy 64"

# Check current remote (if any)
git remote -v

# If you see a remote, remove it first (optional):
# git remote remove origin

# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# Verify it was added
git remote -v
```

**Replace:**
- `YOUR_USERNAME` with your GitHub username
- `YOUR_REPO_NAME` with your repository name

---

## Step 3: Commit Your Changes

Before pushing, commit all your new files:

```bash
# Add all new files (including the interactive mapper)
git add .

# Commit with a message
git commit -m "Add interactive image coordinate mapper with automatic deployment setup"

# If you get an error about submodules, you can skip them:
# git add . --ignore-submodules
```

---

## Step 4: Push to GitHub

```bash
# Push to GitHub (first time)
git push -u origin main

# If you get an error about authentication:
# GitHub now requires a Personal Access Token instead of password
# See "Authentication Setup" below
```

---

## Step 5: Set Up Automatic Deployment on Render

### 5.1: Go to Render Dashboard

1. Visit [dashboard.render.com](https://dashboard.render.com)
2. Sign in or create an account

### 5.2: Connect GitHub Account

1. Click your **profile icon** (top right)
2. Go to **"Account Settings"**
3. Click **"Connect GitHub"** or **"GitHub"** tab
4. Authorize Render to access your GitHub repositories
5. Select the repositories you want to connect (or "All repositories")

### 5.3: Create/Update Web Service

#### If you DON'T have a service yet:

1. Click **"New +"** → **"Web Service"**
2. Click **"Connect account"** next to GitHub
3. Select your repository: `YOUR_USERNAME/myshop2`
4. Click **"Connect"**

#### If you ALREADY have a service:

1. Go to your existing Web Service
2. Click **"Settings"** tab
3. Scroll to **"Build & Deploy"**
4. Click **"Connect GitHub"** if not connected
5. Select your repository

### 5.4: Configure Auto-Deploy

1. In your service settings, find **"Auto-Deploy"**
2. Make sure it's set to **"Yes"**
3. Select branch: **"main"** (or your main branch name)
4. Render will automatically detect `render.yaml` in your repo

### 5.5: Verify render.yaml

Make sure `render.yaml` is in your project root:

```yaml
services:
  - type: web
    name: myshop2
    env: python
    buildCommand: |
      pip install -r requirements.txt &&
      cd myshop2/myshop &&
      python manage.py makemigrations image_editor &&
      python manage.py migrate --no-input &&
      python manage.py collectstatic --no-input
    startCommand: cd myshop2/myshop && gunicorn myshop.wsgi:application
    envVars:
      - key: PYTHON_VERSION
        value: 3.10.0
      - key: SECRET_KEY
        generateValue: true
      - key: WEB_CONCURRENCY
        value: 4
      - key: DATABASE_URL
        fromDatabase:
          name: myshop2-db
          property: connectionString

databases:
  - name: myshop2-db
    databaseName: myshop2
    user: myshop2
```

---

## Step 6: Test Automatic Deployment

1. **Make a small change:**
   ```bash
   # Edit any file (or just add a comment)
   echo "# Test deployment" >> README.md
   ```

2. **Commit and push:**
   ```bash
   git add .
   git commit -m "Test automatic deployment"
   git push
   ```

3. **Watch Render:**
   - Go to Render Dashboard → Your Service
   - You should see a new deployment starting automatically!
   - Wait 2-5 minutes for it to complete

---

## Authentication Setup (If Needed)

### GitHub Personal Access Token

If `git push` asks for authentication:

1. **Create Token:**
   - Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click **"Generate new token (classic)"**
   - Name: `Render Deployment`
   - Expiration: Choose duration (90 days recommended)
   - Scopes: Check **"repo"** (full control of private repositories)
   - Click **"Generate token"**
   - **COPY THE TOKEN** (you won't see it again!)

2. **Use Token:**
   ```bash
   # When git asks for password, use the token instead
   git push -u origin main
   # Username: YOUR_GITHUB_USERNAME
   # Password: PASTE_YOUR_TOKEN_HERE
   ```

3. **Save Credentials (Optional):**
   ```bash
   # Configure git to use token
   git config --global credential.helper store
   ```

---

## Troubleshooting

### "Repository not found" Error

- Check repository name is correct
- Verify you have access to the repository
- Make sure repository exists on GitHub

### "Authentication failed"

- Use Personal Access Token instead of password
- Check token has "repo" scope
- Token might have expired - create a new one

### "Remote origin already exists"

```bash
# Remove existing remote
git remote remove origin

# Add new remote
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
```

### Render Not Detecting Changes

- Make sure Auto-Deploy is enabled
- Check you're pushing to the correct branch (main)
- Verify `render.yaml` is in the root directory
- Check Render logs for errors

### Deployment Fails

1. **Check Build Logs:**
   - Render Dashboard → Your Service → "Logs"
   - Look for error messages

2. **Common Issues:**
   - Missing dependencies in `requirements.txt`
   - Database connection errors
   - Migration errors
   - Static files collection errors

---

## Quick Reference Commands

```bash
# Check git status
git status

# Check remote
git remote -v

# Add all changes
git add .

# Commit
git commit -m "Your message here"

# Push to GitHub
git push

# View deployment logs on Render
# (Go to Dashboard → Service → Logs)
```

---

## What Happens After Setup

✅ **Every time you push to GitHub:**
1. Render detects the push
2. Starts a new deployment
3. Runs build commands (install deps, migrations, collectstatic)
4. Deploys your app
5. Your app is live with latest changes!

✅ **No manual steps needed:**
- No need to SSH into server
- No need to run migrations manually
- No need to restart services
- Everything happens automatically!

---

## Next Steps

After setup is complete:

1. ✅ Push your interactive mapper code
2. ✅ Migrations will run automatically
3. ✅ Access: `https://your-app.onrender.com/image-editor/interactive-mapper/`
4. ✅ Start using the coordinate mapper!

---

**Need Help?** Check Render documentation: [render.com/docs](https://render.com/docs)


