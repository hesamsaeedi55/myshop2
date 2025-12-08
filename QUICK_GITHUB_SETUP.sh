#!/bin/bash
# Quick script to connect your project to GitHub

echo "=================================="
echo "GitHub Setup for Automatic Deployment"
echo "=================================="
echo ""

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "❌ Git not initialized. Run: git init"
    exit 1
fi

echo "✅ Git is initialized"
echo ""

# Check current remote
echo "Current remote configuration:"
git remote -v
echo ""

# Get GitHub repository URL
echo "Enter your GitHub repository URL:"
echo "Example: https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git"
read -p "Repository URL: " REPO_URL

if [ -z "$REPO_URL" ]; then
    echo "❌ Repository URL is required"
    exit 1
fi

# Check if remote already exists
if git remote get-url origin &>/dev/null; then
    echo "⚠️  Remote 'origin' already exists"
    read -p "Do you want to update it? (y/n): " UPDATE
    if [ "$UPDATE" = "y" ] || [ "$UPDATE" = "Y" ]; then
        git remote set-url origin "$REPO_URL"
        echo "✅ Remote updated"
    else
        echo "Keeping existing remote"
    fi
else
    git remote add origin "$REPO_URL"
    echo "✅ Remote added"
fi

echo ""
echo "=================================="
echo "Next Steps:"
echo "=================================="
echo ""
echo "1. Make sure your repository exists on GitHub"
echo "2. Commit your changes:"
echo "   git add ."
echo "   git commit -m 'Add interactive mapper'"
echo ""
echo "3. Push to GitHub:"
echo "   git push -u origin main"
echo ""
echo "4. Connect to Render:"
echo "   - Go to dashboard.render.com"
echo "   - Connect your GitHub account"
echo "   - Create/update web service"
echo "   - Enable Auto-Deploy"
echo ""
echo "=================================="


