# Quick Start Guide - Cram For Rounds iOS App

This guide will help you get the app running on your iPhone in about 15 minutes.

## Prerequisites Checklist

- [ ] Mac with Xcode 15+ installed
- [ ] iPhone running iOS 17+
- [ ] USB cable to connect iPhone to Mac
- [ ] Apple ID (free - no paid developer account needed for testing!)

## 5-Step Setup

### Step 1: Create Xcode Project (3 minutes)

1. **Open Xcode**
2. Click **"Create New Project"**
3. Select **iOS → App**
4. Fill in:
   - Product Name: `CramForRounds`
   - Team: Select your Apple ID
   - Organization Identifier: `com.yourname` (use your actual name)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**
   - Include Tests: **Uncheck**
5. Click **Next**
6. Save location: Navigate to this `CramForRounds` folder and save **inside it**
7. When prompted about merging, click **Merge**

### Step 2: Delete Default Files (30 seconds)

Xcode created some default files we don't need:

1. In the left sidebar (Project Navigator), find and **delete** these files:
   - `ContentView.swift` (the one Xcode created - ours is in Views/)
   - `CramForRoundsApp.swift` (if duplicated)
2. When prompted, choose **"Move to Trash"**

### Step 3: Add Our Files to Project (2 minutes)

1. **Right-click** on the `CramForRounds` folder (blue icon) in the left sidebar
2. Select **"Add Files to CramForRounds..."**
3. Navigate to the actual `CramForRounds/CramForRounds/` directory
4. Select **all** folders:
   - Models/
   - ViewModels/
   - Views/
5. **Important**: Check these options:
   - ✅ **"Copy items if needed"**
   - ✅ **"Create groups"**
   - ✅ Select your **CramForRounds** target
6. Click **Add**

7. Also add the main app file:
   - Right-click `CramForRounds` folder again
   - Add Files...
   - Select `CramForRoundsApp.swift`
   - Same options as above

### Step 4: Add MLX Swift Package (3 minutes)

1. Click on your **project** (blue icon at the top of the sidebar)
2. Select the **CramForRounds** target (under TARGETS)
3. Click **"Package Dependencies"** tab at the top
4. Click the **+** button (bottom left)
5. In the search box, paste:
   ```
   https://github.com/ml-explore/mlx-swift
   ```
6. Click **"Add Package"**
7. Wait for it to load (may take 1-2 minutes)
8. When the package appears, check these products:
   - ✅ MLX
   - ✅ MLXNN
   - ✅ MLXRandom
   - ✅ MLXLLM
9. Click **"Add Package"**

### Step 5: Configure & Run (5 minutes)

1. **Connect your iPhone** via USB
2. **Unlock your iPhone**
3. In Xcode, at the top:
   - Select your **iPhone** from the device dropdown (next to the Run button)
4. Click the **▶️ Run** button (or press ⌘R)
5. **First time only**: On your iPhone, go to:
   - Settings → General → VPN & Device Management
   - Tap your Apple ID under "Developer App"
   - Tap **"Trust [Your Name]"**
   - Tap **"Trust"** again to confirm
6. Return to Xcode and click **Run** again
7. App will build and launch on your iPhone! 🎉

## First Time App Usage

1. **Initialize AI Model**
   - Tap "Initialize AI Model"
   - Download takes 5-15 min (one-time only!)
   - Make sure you have WiFi and ~2GB free space

2. **Enter a Case**
   - Paste or type a clinical case
   - Example: "5yo male, fever 102.5 x 2 days, sore throat, + strep test"

3. **Generate Study Guide**
   - Tap "Generate Study Guide"
   - Wait ~30 seconds

4. **Start Practice Rounds**
   - Review your study guide
   - Tap "Start Practice Rounds"
   - Chat with Doc Pixel!

## Troubleshooting Quick Fixes

### "No signing certificate found"
**Solution**:
1. Project settings → Signing & Capabilities
2. Check ✅ "Automatically manage signing"
3. Select your Apple ID under Team

### "Unsupported iOS version"
**Solution**:
1. Project settings → General
2. Set "Minimum Deployments" to **iOS 17.0**

### "Cannot find 'MLX' in scope"
**Solution**:
1. Make sure you completed Step 4 (MLX package)
2. Try: Product → Clean Build Folder (⌘⇧K)
3. Then rebuild (⌘B)

### Build succeeds but app crashes immediately
**Solution**:
1. Check that ALL Swift files are in the project (should see them in the sidebar)
2. Click each folder (Models, ViewModels, Views) and verify all files have a target membership checkmark

### "Command CodeSign failed"
**Solution**:
1. Open Keychain Access on your Mac
2. If you see duplicate "Apple Development" certificates, delete the older ones
3. Restart Xcode

## What's Next?

- Read the full [README.md](README.md) for detailed documentation
- Customize the UI colors and prompts
- Try different AI models
- Share with your study group!

## Need Help?

- Double-check each step above
- Review the full README.md for more details
- Make sure your iPhone is iOS 17+
- Ensure Xcode is version 15 or newer

---

**You're all set! Happy studying! 📚🩺**
