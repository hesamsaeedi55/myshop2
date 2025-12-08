# Simple Guide: Connect GitHub & Auto-Deploy to Render

## 🎯 Goal
Connect your code to GitHub, then set up Render to automatically deploy when you push code.

---

## Part 1: Connect to GitHub (5 minutes)

### Step 1: Create GitHub Repository

1. Go to [github.com](https://github.com) and sign in
2. Click the **"+"** button (top right) → **"New repository"**
3. Fill in:
   - **Name:** `myshop2` (or any name you like)
   - **Visibility:** Private (recommended)
   - **DO NOT** check "Add README" (you already have files)
4. Click **"Create repository"**
5. **Copy the URL** - it looks like: `https://github.com/YOUR_USERNAME/myshop2.git`

### Step 2: Connect Your Local Project

Open terminal and run:

```bash
cd "/Users/hesamoddinsaeedi/Desktop/best/backup copy 64"

# Add GitHub as remote (replace with YOUR repository URL)
git remote add origin https://github.com/YOUR_USERNAME/myshop2.git

# Verify it worked
git remote -v
```

**Replace `YOUR_USERNAME` and `myshop2` with your actual values!**

### Step 3: Push Your Code

```bash
# Add all files
git add .

# Commit
git commit -m "Add interactive image mapper and setup auto-deploy"

# Push to GitHub (first time)
git push -u origin main
```

**If it asks for password:**
- Username: Your GitHub username
- Password: Use a **Personal Access Token** (see below)

### Step 4: Create GitHub Personal Access Token

If `git push` asks for authentication:

1. GitHub → Your Profile → **Settings**
2. Scroll down → **Developer settings**
3. **Personal access tokens** → **Tokens (classic)**
4. **Generate new token (classic)**
5. Name: `Render Deployment`
6. Check **"repo"** checkbox
7. Click **"Generate token"**
8. **COPY THE TOKEN** (you won't see it again!)
9. Use this token as your password when pushing

---

## Part 2: Set Up Auto-Deploy on Render (5 minutes)

### Step 1: Connect GitHub to Render

1. Go to [dashboard.render.com](https://dashboard.render.com)
2. Click your **profile icon** (top right)
3. **Account Settings** → **GitHub**
4. Click **"Connect GitHub"**
5. Authorize Render to access your repositories
6. Select repositories (or "All repositories")

### Step 2: Create/Update Web Service

#### If you DON'T have a service yet:

1. Click **"New +"** → **"Web Service"**
2. Click **"Connect account"** next to GitHub
3. Find and select your repository: `YOUR_USERNAME/myshop2`
4. Click **"Connect"**
5. Render will auto-detect `render.yaml` - click **"Apply"**

#### If you ALREADY have a service:

1. Go to your Web Service
2. **Settings** tab
3. Scroll to **"Build & Deploy"**
4. Under **"Repository"**, click **"Connect GitHub"**
5. Select your repository: `YOUR_USERNAME/myshop2`

### Step 3: Enable Auto-Deploy

1. In your service settings, find **"Auto-Deploy"**
2. Set to **"Yes"**
3. Branch: **"main"** (or your main branch)
4. **Save changes**

---

## ✅ Test It!

1. Make a small change:
   ```bash
   echo "# Test" >> README.md
   git add .
   git commit -m "Test auto-deploy"
   git push
   ```

2. Go to Render Dashboard → Your Service
3. You should see a **new deployment starting automatically!** 🎉

---

## 🎉 Done!

Now every time you run:
```bash
git add .
git commit -m "Your changes"
git push
```

Render will **automatically**:
- ✅ Detect the push
- ✅ Build your app
- ✅ Run migrations
- ✅ Deploy to production
- ✅ Your app is live!

---

## 📋 Quick Command Reference

```bash
# Check status
git status

# Add changes
git add .

# Commit
git commit -m "Your message"

# Push to GitHub (triggers auto-deploy)
git push

# Check remote
git remote -v
```

---

## ❓ Troubleshooting

### "Repository not found"
- Check the repository URL is correct
- Make sure repository exists on GitHub
- Verify you have access to it

### "Authentication failed"
- Use Personal Access Token (not password)
- Make sure token has "repo" scope
- Token might be expired - create new one

### "Remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
```

### Render not deploying
- Check Auto-Deploy is enabled
- Verify you're pushing to correct branch (main)
- Check Render logs for errors

---

## 🚀 Next Steps

After setup:
1. Push your interactive mapper code
2. Migrations run automatically
3. Access: `https://your-app.onrender.com/image-editor/interactive-mapper/`
4. Start using it!

**That's it! You're all set for automatic deployments!** 🎊


