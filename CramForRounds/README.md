# Cram For Rounds - iOS App

An iOS application that helps medical students prepare for rounds by generating AI-powered study guides and simulating practice rounds. **Runs 100% on-device** for complete privacy.

## Features

- **Study Guide Generation**: Transform clinical cases into structured study guides with learning objectives, discussion questions, and key teaching points
- **Practice Rounds Simulation**: Interactive AI-powered quizzing in the style of attending rounds
- **On-Device AI**: All processing happens locally on your iPhone using MLX Swift - no data sent to servers
- **Export Functionality**: Save your study sessions as Markdown files
- **Privacy First**: No internet required after initial model download, complete data privacy

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- iPhone with Apple A12 Bionic or newer (for optimal performance)
- ~2GB of free storage for the AI model
- Apple Developer account (for device deployment)

## Installation & Setup

### Step 1: Open the Project in Xcode

1. Navigate to the `CramForRounds` directory
2. Open the project in Xcode by double-clicking `CramForRounds.xcodeproj` (you'll need to create this - see below)

### Step 2: Create Xcode Project File

Since we're building from scratch, you need to create the Xcode project:

1. **Open Xcode**
2. **File → New → Project**
3. Choose **iOS → App**
4. Configure:
   - **Product Name**: CramForRounds
   - **Organization Identifier**: com.yourname (or your org identifier)
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Storage**: None
5. **Save** in the `CramForRounds` directory (merge with existing files)

### Step 3: Add MLX Swift Dependency

1. In Xcode, select your project in the navigator
2. Select the **CramForRounds** target
3. Go to **Package Dependencies** tab
4. Click **+** to add a package
5. Enter the MLX Swift repository URL:
   ```
   https://github.com/ml-explore/mlx-swift
   ```
6. Choose the **main** branch
7. Add the following products to your target:
   - MLX
   - MLXNN
   - MLXRandom
   - MLXLLM

### Step 4: Configure Build Settings

1. Select your target → **Build Settings**
2. Search for "Dead Code Stripping" and set to **No**
3. Ensure **iOS Deployment Target** is set to **iOS 17.0**

### Step 5: Configure Signing

1. Select your target → **Signing & Capabilities**
2. Check **Automatically manage signing**
3. Select your **Team** (requires Apple Developer account)
4. Xcode will automatically create a provisioning profile

### Step 6: Add Files to Project

Make sure all the Swift files are added to your project:

- **Models/**
  - Message.swift
  - StudyGuide.swift
  - AppState.swift

- **ViewModels/**
  - MLXManager.swift
  - ChatViewModel.swift

- **Views/**
  - ContentView.swift
  - InitializationView.swift
  - StudyGuideInputView.swift
  - ChatView.swift

- **App**
  - CramForRoundsApp.swift
  - Info.plist

### Step 7: Build and Run

1. Select your iPhone as the destination device
2. Click **Run** (⌘R) or the play button
3. Xcode will build and deploy to your device
4. On first launch, trust the developer certificate on your iPhone:
   - Settings → General → VPN & Device Management
   - Trust your developer certificate

## First Time Usage

1. **Launch the app** - you'll see the initialization screen
2. **Tap "Initialize AI Model"** - this downloads the ~2GB model (one-time only, 5-15 minutes depending on your connection)
3. **Wait for completion** - you'll see a progress bar
4. Once initialized, tap **"Get Started"**

## How to Use

### Generate a Study Guide

1. On the input screen, paste or type a clinical case
2. Can be brief notes or detailed presentations
3. Tap **"Generate Study Guide"**
4. Wait 10-30 seconds for the AI to generate your structured guide

### Practice Rounds

1. After generating a study guide, tap **"Start Practice Rounds"**
2. Doc Pixel (the AI) will greet you and ask questions
3. Type your answers
4. Receive feedback and follow-up questions
5. Continue the interactive learning session

### Export Your Session

1. Tap the **share icon** in the chat header or on the study guide screen
2. Choose **"Share Markdown File"**
3. Save to Files, share via Messages/Email, or open in Notes

## Technical Architecture

### Tech Stack
- **SwiftUI**: Modern declarative UI framework
- **MLX Swift**: Apple's machine learning framework for running LLMs on Apple Silicon
- **Phi-3.5-mini-instruct-4bit**: Compact, high-quality language model optimized for mobile

### App Structure
```
CramForRounds/
├── Models/              # Data models
├── ViewModels/          # Business logic & AI management
├── Views/               # SwiftUI views
└── Resources/           # Assets & prompts
```

### Privacy & Security
- ✅ **100% on-device processing** - no data leaves your phone
- ✅ **No network required** after initial model download
- ✅ **No analytics or tracking**
- ✅ **Session-only storage** - nothing persists unless you export

## Troubleshooting

### Build Errors

**"Cannot find module 'MLX'"**
- Solution: Make sure you added the MLX Swift package dependencies

**"Unsupported iOS version"**
- Solution: Update deployment target to iOS 17.0 in Build Settings

### Runtime Issues

**App crashes on launch**
- Check that all files are added to the target
- Verify iOS version is 17.0+
- Ensure device has sufficient storage (~3GB free)

**Model download fails**
- Check internet connection
- Ensure sufficient storage space
- Try restarting the app

**Slow generation**
- Normal on first use as model loads into memory
- Older devices (pre-A14) may be slower
- Close other apps to free up RAM

## Customization

### Change the AI Model

In `MLXManager.swift`, line 20:
```swift
private let modelConfiguration = ModelConfiguration(
    id: "mlx-community/Phi-3.5-mini-instruct-4bit"
)
```

You can replace with any MLX-compatible model from Hugging Face.

### Modify the Prompt

Edit the `buildStudyGuidePrompt` function in `MLXManager.swift` to customize how study guides are generated.

### Adjust Colors

Colors are defined using hex codes in the views:
- Primary blue: `#2a7ae2`
- Success green: `#059669`
- Warning yellow: `#fef3c7`, `#fde68a`

## Limitations & Disclaimers

⚠️ **Important Medical Disclaimer:**
- This app is for **educational purposes only**
- **NOT** for clinical decision making
- AI may produce inaccurate information (hallucinations)
- Always verify information with authoritative sources
- Never input real patient data or PHI

⚠️ **Technical Limitations:**
- Requires modern iPhone (A12+) for acceptable performance
- Large initial download (~2GB)
- May be slower on older devices
- AI responses are not always perfect

## Future Enhancements

Potential features to add:
- [ ] Siri integration for voice input
- [ ] Widgets for quick access to saved study guides
- [ ] iCloud sync for study sessions
- [ ] Apple Watch companion app
- [ ] Spaced repetition reminders
- [ ] More specialized models per specialty
- [ ] Offline model switching

## Credits

- **Original Web Version**: Based on the Cram For Rounds feature from PhysicianPromptEngineering
- **MLX Swift**: Apple's Machine Learning framework
- **Phi-3.5**: Microsoft's efficient language model

## License

[Add your license here]

## Support

For issues or questions:
- Check the Troubleshooting section above
- Review the original web version documentation
- File an issue on the GitHub repository

---

**Built with ❤️ for medical students everywhere**
