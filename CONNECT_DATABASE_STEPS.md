# How to Connect Database to Your Web Service

## Step 1: Get Your Database Connection String

1. **Go to Render Dashboard** → Click on your **PostgreSQL database** (the one you created)
2. Look for **"Internal Database URL"** (it's usually under "Info" or "Connections" tab)
3. **Copy the entire URL** - it looks like this:
   ```
   postgresql://myshop2:YOUR_PASSWORD@dpg-xxxxx-a.oregon-postgres.render.com/myshop2
   ```
   - It should start with `postgresql://`
   - It contains username, password, host, and database name

---

## Step 2: Add Database URL to Web Service

1. **Go to your Web Service** (the one that's deploying)
2. Click **"Environment"** tab (at the top)
3. Click **"Add Environment Variable"** button
4. Add this variable:
   - **Key:** `DATABASE_URL`
   - **Value:** Paste the entire Internal Database URL you copied
5. Click **"Save Changes"**

---

## Step 3: Alternative - Link Database in Render Dashboard

**Easier Method:**

1. Go to your **Web Service**
2. Scroll down to find **"Linked Resources"** or **"Databases"** section
3. Click **"Link Database"** or **"Link Resource"**
4. Select your PostgreSQL database
5. Render will automatically create `DATABASE_URL` environment variable for you!

---

## Step 4: Verify It's Connected

1. After adding `DATABASE_URL`, check it appears in the Environment Variables list
2. The variable name should be exactly: `DATABASE_URL` (all caps, with underscore)
3. The value should start with `postgresql://`

---

## Step 5: Redeploy

After adding the database connection:

1. Go to **"Manual Deploy"** dropdown
2. Select **"Deploy latest commit"**
3. Wait for deployment to complete
4. The migrations should run automatically and connect to your database!

---

## Quick Checklist

- [ ] Found PostgreSQL database in Render dashboard
- [ ] Copied Internal Database URL
- [ ] Added `DATABASE_URL` environment variable to Web Service
- [ ] Saved changes
- [ ] Triggered new deployment

---

## Still Can't Find Database URL?

**Alternative: Manual Connection String Format**

If you can't find the Internal Database URL, you can build it manually:

Format: `postgresql://USERNAME:PASSWORD@HOST:PORT/DATABASENAME`

From your PostgreSQL database page, look for:
- **Host** (e.g., `dpg-xxxxx-a.oregon-postgres.render.com`)
- **Port** (usually `5432`)
- **Database Name** (probably `myshop2`)
- **User** (probably `myshop2`)
- **Password** (the one you created)

Put them together like:
```
postgresql://myshop2:YOUR_PASSWORD@dpg-xxxxx-a.oregon-postgres.render.com:5432/myshop2
```

---

## Need Help?

Tell me:
1. Can you see your PostgreSQL database in the Render dashboard?
2. Do you see an "Internal Database URL" field?
3. Or do you see Host, Port, User, Database fields separately?

