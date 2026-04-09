# RevenueCat Configuration - Verse Daily

## Credentials
- **API Key**: `sk_GWaRZMPDHSYnuWIuhRaBReqfMQXnR`
- **App ID**: `90031fc1`
- **Entitlement ID**: `Verse Daily Pro`

---

## Configuration Steps

### 1. Create Offering
**Name**: `Verse Daily subscription`
**Description**: Main subscription offering for Verse Daily app

### 2. Create Packages

#### Package 1: Trial (Free Trial)
- **Identifier**: `verse_daily_trial`
- **Type**: Subscription
- **Duration**: 7 days free trial
- **Entitlement**: `Verse Daily Pro`
- **Platform**: iOS
  - **Product ID**: `verse_daily_trial` (match with App Store)
  - **Trial Duration**: 7 days
  - **Billing**: $4.99 per week after trial

---

#### Package 2: Yearly (Recommended)
- **Identifier**: `verse_daily_yearly`
- **Type**: Subscription
- **Duration**: Yearly
- **Entitlement**: `Verse Daily Pro`
- **Platform**: iOS
  - **Product ID**: `verse_daily_yearly` (match with App Store)
  - **Intro Offer**: $29.99 for first year
  - **Regular Price**: $59.99/year

---

## Manual Setup in RevenueCat Dashboard

1. Go to: https://app.revenuecat.com/projects/90031fc1/apps
2. Click your app (Verse Daily)
3. Navigate to **Products** → **Offerings**
4. Create new Offering: `Verse Daily subscription`
5. Add the two packages above with their Product IDs from App Store Connect
6. Verify Entitlement is set to `Verse Daily Pro`
7. Save and publish

---

## iOS Configuration

### App Store Connect Requirements
Create these products in App Store Connect:
- `verse_daily_trial` - Auto-renewable subscription (7 day free trial)
- `verse_daily_yearly` - Auto-renewable subscription (yearly)

Both should grant entitlement: `Verse Daily Pro`

---

## Notes
- All prices are in USD (RevenueCat auto-converts to other currencies)
- Test with `sk_test_*` key during development
- Switch to production key before release
- Product IDs must exactly match App Store Connect

