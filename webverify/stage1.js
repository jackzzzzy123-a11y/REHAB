// Stage 1：登录 → 截图 dashboard（用于定位"載入範例"按钮）
const puppeteer = require('puppeteer-core');
const path = require('path');

(async () => {
  const userDataDir = path.resolve('./profile-stage1');
  const browser = await puppeteer.launch({
    executablePath: 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
    headless: 'new',
    userDataDir,
    args: ['--no-sandbox', '--disable-gpu', '--disable-dev-shm-usage'],
  });
  try {
    const page = await browser.newPage();
    await page.setViewport({ width: 1280, height: 900 });
    await page.goto('http://localhost:8080/', { waitUntil: 'networkidle0', timeout: 60000 });
    await new Promise((r) => setTimeout(r, 12000));
    // 同意勾选（已观测坐标）
    await page.mouse.click(288, 503);
    await new Promise((r) => setTimeout(r, 500));
    // 登入按钮
    await page.mouse.click(640, 553);
    await new Promise((r) => setTimeout(r, 6000));
    await page.screenshot({ path: 'shot2_dashboard.png' });
    console.log('STAGE1_OK');
  } catch (e) {
    console.error('ERR:', e.message);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
})();
