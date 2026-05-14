# RevenueCat Pro Setup

This app mirrors the Android app's free app with one-time Pro unlock model.

## App constants

- RevenueCat entitlement id: `pro`
- Suggested App Store non-consumable product id: `workout_pro_lifetime`
- Free preset limit: `3`
- Free goal limit: `5`
- Free record limit: `10`

## Local configuration

Set these Xcode build settings locally for Debug/Release, especially for Archive/TestFlight:

```xcconfig
REVENUECAT_API_KEY=appl_xxxxxxxxxxxxxxxxx
PRO_UNLOCK_CODE=your-private-friends-code
```

The app injects those values into the generated Info.plist as `REVENUECAT_API_KEY` and `PRO_UNLOCK_CODE`.

For development runs from Xcode, you can also add the same keys under Scheme > Run > Arguments > Environment Variables. The app reads Info.plist first, then falls back to process environment variables.

If `REVENUECAT_API_KEY` is empty, RevenueCat is not configured and Pro gates are disabled.

## Current Pro gates

- Presets: free users can create up to 3.
- Goals: free users can create up to 5.
- Records: free users can create up to 10.
- Saving a training day as a preset follows the same preset limit.
- Training statistics are Pro-only.

Existing local data is never deleted when a user is free. Gates only block creating more items or opening Pro-only features.

## Private access code

The paywall has an `Access code` button. Entering `PRO_UNLOCK_CODE` stores a local unlock flag on that device and enables Pro without a RevenueCat purchase.
