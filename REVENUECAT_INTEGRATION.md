# RevenueCat Integration Guide - Verse Daily iOS

Complete RevenueCat SDK integration for Verse Daily with subscriptions, paywalls, and entitlements.

## Current Status

✅ **Architecture Ready**: Clean Architecture pattern with repository layer prepared  
✅ **Code Files Created**: RevenueCatManager, RevenueCatMonetizationRepository, RevenueCatPaywallView  
⏳ **SPM Integration**: Manual completion required via Xcode UI  

## Step-by-Step Integration

### Step 1: Add RevenueCat SDK via Swift Package Manager

1. Open Xcode project:
   ```bash
   open VerseDaily-iOS/VerseDaily.xcodeproj
   ```

2. In Xcode menu: **File** → **Add Packages...**

3. In the search box, enter:
   ```
   https://github.com/RevenueCat/purchases-ios-spm.git
   ```

4. Select version: **Up to Next Major Version** (4.0.0)

5. Choose target: **VerseDaily** (main app target)

6. Click **Add Package**

7. Xcode will resolve and add the dependency

### Step 2: Verify MonetizationServices Package

The `MonetizationServices` local Swift package has been created at:
```
VerseDaily-iOS/LocalPackages/MonetizationServices/
```

Xcode should automatically discover it. Verify:

1. File → Add Packages...
2. Look for "MonetizationServices" in the list
3. If not there, drag the folder into Xcode or use **File** → **Add Files to "VerseDaily"...**

### Step 3: Enable RevenueCat in Code

#### 3.1 Update DependencyContainer

Replace line 34 in `App/DependencyContainer.swift`:

**Change from:**
```swift
let monetizationRepo = MockMonetizationRepository()
```

**To:**
```swift
let monetizationRepo = RevenueCatMonetizationRepository()
```

#### 3.2 Initialize RevenueCat in VerseDailyApp

Update `App/VerseDailyApp.swift` to initialize RevenueCat:

```swift
import MonetizationServices

@main
struct VerseDailyApp: App {
    @StateObject private var revenueCatManager = RevenueCatManager.shared
    // ... other code ...

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .task {
                    // Initialize RevenueCat
                    await RevenueCatManager.shared.initialize()
                    
                    // ... rest of initialization ...
                }
        }
    }
}
```

### Step 4: Configure RevenueCat Dashboard

1. Go to [RevenueCat Dashboard](https://app.revenuecat.com)

2. Create new app for Verse Daily iOS:
   - Platform: iOS
   - Bundle ID: `com.leadtech.versedaily.VerseDaily`

3. **Configure Entitlements:**
   - Name: `Verse Daily Pro`
   - Identifier: `verse_daily_pro`

4. **Create Products** in RevenueCat:
   - **Monthly**: ID `monthly`, Price $4.99
   - **Yearly**: ID `yearly`, Price $39.99, Savings ~33%
   - **Lifetime**: ID `lifetime`, Price $99.99

5. **Create Offering:**
   - Name: `default`
   - Add all 3 products/packages

6. **Link to App Store:**
   - In RevenueCat: Settings → Apps
   - Connect App Store via shared secret
   - Map in-app purchase SKUs

### Step 5: Implement RevenueCat PaywallView

Update `Features/Monetization/Presentation/Views/SubscriptionView.swift` to use RevenueCat PaywallView:

```swift
import MonetizationServices

struct SubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showPaywall = true

    var body: some View {
        if showPaywall {
            RevenueCatPaywallView(
                onPurchaseComplete: {
                    // Handle successful purchase
                    dismiss()
                },
                onDismiss: {
                    dismiss()
                }
            )
        }
    }
}
```

### Step 6: Update SettingsView to Show Premium Status

Update `Features/User/Presentation/Views/SettingsView.swift`:

```swift
var isPremium: Bool {
    RevenueCatManager.shared.hasEntitlement("Verse Daily Pro")
}
```

### Step 7: Add Customer Center (Optional)

For advanced subscription management:

```swift
import MonetizationServices

@available(iOS 17.0, *)
struct CustomerCenterButton: View {
    var body: some View {
        Button("Manage Subscription") {
            // RevenueCat's Customer Center
            // Coming in future implementation
        }
    }
}
```

## Testing RevenueCat Integration

### Test in Sandbox Mode

1. Create test App Store account
2. Use in Sandbox environment
3. RevenueCat SDK will automatically use test mode

### Verify Initialization

In Xcode Console, look for:
```
🔄 Initializing RevenueCat with API key
✅ RevenueCat initialized
```

### Test Purchases

1. Open Subscription View
2. RevenueCat PaywallView should load
3. Tap product → Purchase flow
4. Complete in sandbox
5. Verify entitlement granted

## File Locations

| File | Purpose |
|------|---------|
| `App/RevenueCatManager.swift` | Singleton manager for RevenueCat initialization |
| `App/RevenueCatMonetizationRepository.swift` | Repository implementing subscription logic |
| `LocalPackages/MonetizationServices/` | Swift Package with PaywallView and dependencies |
| `Infrastructure/RevenueCat/` | Additional RevenueCat utilities |

## API Key & Configuration

**Current API Key (Test):** `test_ZrHINtPwuOTHWiqoLLnYZsCYfBi`

⚠️ **Production API Key Needed:**
- Get from RevenueCat Dashboard → Settings → API Keys
- Replace in `RevenueCatManager.swift` line 10 before release

## Next Steps

1. ✅ Swift Package Manager integration (manual via Xcode UI)
2. ✅ Code integration (files created, ready to enable)
3. ⏳ RevenueCat Dashboard configuration
4. ⏳ App Store integration (shared secret)
5. ⏳ Testing & QA
6. ⏳ Production API key setup

## Troubleshooting

### "Module not found" errors
- Clean build folder: **Shift + Cmd + K**
- Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`
- Restart Xcode

### PaywallView not displaying
- Ensure RevenueCat is initialized
- Check API key is correct
- Verify offerings exist in RevenueCat Dashboard
- Check console for RevenueCat errors

### Entitlements not granted
- Verify entitlement name matches ("Verse Daily Pro")
- Check product is linked to entitlement in Dashboard
- Test in App Store Sandbox environment

## Resources

- [RevenueCat Docs](https://www.revenuecat.com/docs)
- [RevenueCat SDK for iOS](https://github.com/RevenueCat/purchases-ios)
- [PaywallView Documentation](https://www.revenuecat.com/docs/tools/paywalls)
- [Customer Center](https://www.revenuecat.com/docs/tools/customer-center)

## Questions?

Refer to `LocalPackages/MonetizationServices/Package.swift` for dependency configuration and `Infrastructure/RevenueCat/` for implementation details.
