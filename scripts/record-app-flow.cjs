const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    viewport: { width: 430, height: 932 },
    recordVideo: {
      dir: '/tmp/videos/',
      size: { width: 430, height: 932 }
    },
  });

  const page = await context.newPage();

  const expoUrl = process.env.REPLIT_EXPO_DEV_DOMAIN
    ? `https://${process.env.REPLIT_EXPO_DEV_DOMAIN}/`
    : 'http://localhost:18115/';

  console.log('Opening app at:', expoUrl);
  await page.goto(expoUrl, { waitUntil: 'networkidle', timeout: 30000 });
  console.log('Page loaded - splash screen');

  await page.waitForTimeout(5000);
  console.log('Splash done, looking for onboarding...');

  async function tryClick(texts, timeoutMs = 3000) {
    for (const t of texts) {
      try {
        const el = page.getByText(t, { exact: false }).first();
        if (await el.isVisible({ timeout: timeoutMs })) {
          await el.click();
          console.log(`  Clicked: "${t}"`);
          return true;
        }
      } catch {}
    }
    return false;
  }

  // Onboarding: 3 slides
  for (let slide = 1; slide <= 3; slide++) {
    console.log(`Onboarding slide ${slide}...`);
    await page.waitForTimeout(2000);
    if (slide < 3) {
      await tryClick(['Next']);
    } else {
      await tryClick(['Get Started', 'Begin', 'Continue', 'Next']);
    }
    await page.waitForTimeout(1000);
  }

  // Divine Offer
  console.log('Waiting for Divine Offer...');
  await page.waitForTimeout(5000);
  await tryClick(['Continue', 'Claim', 'Unlock', 'Next']);
  await page.waitForTimeout(2000);

  // Weekly Paywall - look for X button (top-right area)
  console.log('Weekly Paywall...');
  await page.waitForTimeout(2000);
  try {
    // The X close button is typically in the top-right. Let's click that area.
    // Look for any clickable element near top-right with the X icon
    const closeBtn = page.locator('div[role="button"]').filter({ hasText: /^$/ }).first();
    const pressables = page.locator('[data-testid]').first();

    // Try clicking near top-right corner (where X should be)
    await page.mouse.click(400, 67);
    console.log('  Clicked top-right for X');
  } catch(e) {
    console.log('  Could not click X:', e.message);
  }
  await page.waitForTimeout(2000);

  // Annual Paywall
  console.log('Annual Paywall...');
  await page.waitForTimeout(1000);
  await tryClick(['No thanks', 'Skip', 'Not now', 'Close']);
  await page.waitForTimeout(2000);

  // In App - Home tab
  console.log('In the app now! Showing Home tab...');
  await page.waitForTimeout(3000);

  // Bible tab
  console.log('Navigating to Bible tab...');
  await tryClick(['Bible']);
  await page.waitForTimeout(3000);

  // Click on Genesis
  console.log('Looking for Genesis...');
  await tryClick(['Genesis']);
  await page.waitForTimeout(2000);

  // Click chapter 1
  console.log('Selecting chapter 1...');
  try {
    // Chapter grid - click the first number
    const chapterOne = page.locator('text="1"').first();
    if (await chapterOne.isVisible({ timeout: 2000 })) {
      await chapterOne.click();
      console.log('  Clicked chapter 1');
    }
  } catch {}
  await page.waitForTimeout(3000);

  // Scroll down to show verses
  await page.mouse.wheel(0, 300);
  await page.waitForTimeout(2000);

  // Go back to home
  console.log('Back to Home...');
  await tryClick(['Home']);
  await page.waitForTimeout(2000);

  // Explore tab
  console.log('Explore tab...');
  await tryClick(['Explore']);
  await page.waitForTimeout(2000);

  // Favorites tab
  console.log('Favorites tab...');
  await tryClick(['Favorites']);
  await page.waitForTimeout(2000);

  console.log('Recording complete!');
  await page.close();
  await context.close();
  await browser.close();

  console.log('Done! Check /tmp/videos/ for the recording.');
})();
