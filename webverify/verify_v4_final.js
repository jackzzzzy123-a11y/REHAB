// 最终尝试：精确坐标 + 5 次 click
const puppeteer = require('puppeteer-core');
const path = require('path');

async function clickHard(page, x, y) {
  for (let i = 0; i < 5; i++) {
    await page.mouse.click(x, y);
    await new Promise((r) => setTimeout(r, 500));
  }
}

(async () => {
  const userDataDir = path.resolve('./profile-final');
  const browser = await puppeteer.launch({
    executablePath: 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
    headless: false,
    userDataDir,
    args: ['--no-sandbox', '--disable-gpu', '--disable-dev-shm-usage', '--window-size=1280,900'],
  });
  try {
    const page = await browser.newPage();
    await page.setViewport({ width: 1280, height: 900 });
    await page.goto('http://localhost:8080/', { waitUntil: 'networkidle0', timeout: 60000 });
    await new Promise((r) => setTimeout(r, 15000));

    // 不点 segmented，确保角色保持 doctor
    // 帳號框精确中心（基于 shot1 测算：y ≈ 380）
    await clickHard(page, 640, 380);
    await page.keyboard.type('doc', { delay: 100 });
    await new Promise((r) => setTimeout(r, 800));
    await page.screenshot({ path: 'f_username.png' });
    const usernameVal = await page.evaluate(() => {
      // 找 Flutter hidden input（如果存在）
      return null;
    });

    // 密碼框精确中心
    await clickHard(page, 640, 448);
    await page.keyboard.type('123456', { delay: 100 });
    await new Promise((r) => setTimeout(r, 800));
    await page.screenshot({ path: 'f_password.png' });

    // 同意
    await page.mouse.click(290, 510);
    await new Promise((r) => setTimeout(r, 600));
    await page.screenshot({ path: 'f_consent.png' });

    // 登入
    await page.mouse.click(640, 560);
    await new Promise((r) => setTimeout(r, 9000));
    await page.screenshot({ path: 'f_logged_in.png' });

    console.log('FINAL_DONE');
  } catch (e) {
    console.error('ERR:', e.message);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
})();
