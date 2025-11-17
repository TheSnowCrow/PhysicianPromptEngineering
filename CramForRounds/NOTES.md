# Developer Notes - Cram For Rounds iOS

## Important Implementation Notes

### MLX Swift Integration - CRITICAL

⚠️ **The current MLXManager.swift contains mock implementations!**

The `ModelContainer` class at the bottom of `MLXManager.swift` is a **placeholder** that simulates the MLX Swift API. For a production app, you need to:

1. **Update MLXManager.swift** to use the real MLX Swift APIs
2. **Reference the MLX Swift examples**: https://github.com/ml-explore/mlx-swift-examples
3. **Model loading**: Use MLX's `LLM` class to load quantized models
4. **Generation**: Replace mock `generate()` with actual MLX generation

### Real MLX Implementation Example

```swift
import MLX
import MLXLLM

class MLXManager {
    private var llm: LLM?

    func initialize() async {
        // Real MLX initialization
        let modelPath = "path/to/mlx-community/Phi-3.5-mini-instruct-4bit"
        self.llm = try await LLM.load(modelPath: modelPath)
    }

    func generate(prompt: String) async -> String {
        guard let llm = llm else { return "" }
        let output = try await llm.generate(prompt: prompt, maxTokens: 2000)
        return output
    }
}
```

### Alternative: Use llama.cpp Instead

If MLX Swift integration is challenging, consider using **llama.cpp** with Swift bindings:

- **llama.cpp iOS**: https://github.com/ggerganov/llama.cpp
- Supports GGUF model format
- Well-tested on iOS
- Easier to integrate than MLX

You would need to:
1. Download a GGUF version of Phi-3.5
2. Add llama.cpp as a dependency
3. Update MLXManager to use llama.cpp APIs

### Models to Use

**Recommended on-device models** (in order of preference):

1. **Phi-3.5-mini-instruct-4bit** (~2GB)
   - Best balance of size and quality
   - Optimized for mobile
   - Good medical knowledge

2. **Llama-3.2-3B-Instruct-q4** (~1.8GB)
   - Smaller, faster
   - Slightly less capable
   - Better for older iPhones

3. **Gemma-2-2B-it-q4** (~1.2GB)
   - Smallest option
   - Fastest inference
   - May have reduced medical accuracy

### Performance Considerations

**Device Requirements:**
- **Minimum**: iPhone 12 (A14 Bionic) - 4GB RAM
- **Recommended**: iPhone 14+ (A16) - 6GB+ RAM
- **Optimal**: iPhone 15 Pro (A17 Pro) - 8GB RAM

**Memory Management:**
- Keep model in memory after first load
- Implement background task handling
- Handle memory warnings gracefully

**Generation Speed:**
- A14: ~3-5 tokens/sec
- A16: ~8-12 tokens/sec
- A17 Pro: ~15-20 tokens/sec

### UI/UX Improvements

**Enhancements to consider:**

1. **Add haptic feedback** on button taps and message sends
2. **Implement voice input** using SpeechRecognizer
3. **Add dark mode** support
4. **Persist study guides** to CoreData or SwiftData
5. **Add search** through past study guides
6. **Implement notifications** for spaced repetition

### Testing Strategy

**Before release, test:**

1. **Model initialization** on different network speeds
2. **Memory usage** during long chat sessions
3. **Background/foreground** transitions
4. **Low battery mode** impact
5. **Different iPhone models** (12, 13, 14, 15)
6. **iOS versions** (17.0, 17.5, 18.0+)

### Known Limitations

1. **Large download**: 2GB model = significant barrier
   - Consider progressive download
   - Or cloud API fallback option

2. **Generation speed**: Slower than cloud APIs
   - Set proper user expectations
   - Show streaming progress clearly

3. **Model accuracy**: Smaller models = occasional errors
   - Emphasize disclaimers
   - Add "report issue" button

4. **Storage**: Takes up significant space
   - Allow model deletion
   - Show storage usage in settings

### Security Considerations

1. **No PHI/PII**: Enforce in UI disclaimers
2. **Data isolation**: Everything stays on-device
3. **No telemetry**: No analytics or crash reporting by default
4. **Model integrity**: Verify model checksums on download

### Deployment Checklist

Before App Store submission:

- [ ] Replace mock MLX implementation with real one
- [ ] Test on 3+ different iPhone models
- [ ] Add app icons (required for App Store)
- [ ] Add privacy policy
- [ ] Test with TestFlight
- [ ] Add App Store screenshots
- [ ] Write comprehensive App Store description
- [ ] Add age rating (likely 17+ due to medical content)
- [ ] Implement proper error tracking
- [ ] Add onboarding tutorial
- [ ] Create demo video

### File Structure Reference

```
CramForRounds/
├── CramForRounds/
│   ├── CramForRoundsApp.swift       # Main app entry point
│   ├── Models/
│   │   ├── Message.swift            # Chat message model
│   │   ├── StudyGuide.swift         # Study guide + export
│   │   └── AppState.swift           # Global app state
│   ├── ViewModels/
│   │   ├── MLXManager.swift         # ⚠️ Needs real MLX implementation
│   │   └── ChatViewModel.swift      # Chat logic
│   ├── Views/
│   │   ├── ContentView.swift        # Main navigation
│   │   ├── InitializationView.swift # Model setup
│   │   ├── StudyGuideInputView.swift # Case input
│   │   └── ChatView.swift           # Practice rounds
│   ├── Resources/
│   │   └── Prompts/
│   │       └── CramForRoundsPrompt.txt # Prompt template
│   └── Info.plist
├── Package.swift                     # SPM dependencies
├── README.md                         # Full documentation
├── QUICKSTART.md                     # Setup guide
└── NOTES.md                          # This file
```

### Next Steps for Production

1. **Implement real MLX Swift integration** (highest priority)
2. **Add app icons and launch screen**
3. **Implement persistent storage** (CoreData/SwiftData)
4. **Add settings screen** (model selection, theme, etc.)
5. **Improve error handling** and user feedback
6. **Add unit tests** for models and view models
7. **Add UI tests** for critical flows
8. **Optimize for iPad** (larger screens)
9. **Consider Apple Watch** companion app
10. **Submit to App Store**

### Resources

- **MLX Swift**: https://github.com/ml-explore/mlx-swift
- **MLX Examples**: https://github.com/ml-explore/mlx-swift-examples
- **Hugging Face MLX Models**: https://huggingface.co/mlx-community
- **SwiftUI Docs**: https://developer.apple.com/documentation/swiftui
- **iOS App Store Guidelines**: https://developer.apple.com/app-store/review/guidelines/

---

**Status**: ✅ Core structure complete, ⚠️ Needs MLX implementation for production use
