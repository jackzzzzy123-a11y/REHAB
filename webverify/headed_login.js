// headed 模式登录测试：验证 CanvasKit hit-test 在非 headless 下是否工作
const puppeteer = require('puppeteer-core');
const path = require('path');

async function ensureFocus(page, x, y, n = 3) {
  for (let i = 0; i < n; i++) {
    await page.mouse.click(x, y);
    await new Promise((r) => setTimeout(r, 400));
  }
}

(async () => {
  const userDataDir = path.resolve('./profile-headed');
  const browser = await puppeteer.launch({
    executablePath: 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
    headless: false, // ⭐ 关键：真实窗口模式
    userDataDir,
    args: ['--no-sandbox', '--disable-gpu', '--disable-dev-shm-usage', '--window-size=1280,900'],
  });
  try {
    const page = await browser.newPage();
    await page.setViewport({ width: 1280, height: 900 });
    await page.goto('http://localhost:8080/', { waitUntil: 'networkidle0', timeout: 60000 });
    await new Promise((r) => setTimeout(r, 15000));

    // 帳號
    await ensureFocus(page, 640, 371, 3);
    await page.keyboard.type('doc', { delay: 80 });
    await new Promise((r) => setTimeout(r, 500));
    await page.screenshot({ path: 'h_after_username.png' });

    // 密碼
    await ensureFocus(page, 640, 437, 3);
    await page.keyboard.type('123456', { delay: 80 });
    await new Promise((r) => setTimeout(r, 500));
    await page.screenshot({ path: 'h_after_password.png' });

    // 同意
    await page.mouse.click(288, 503);
    await new Promise((r) => setTimeout(r, 500));
    await page.screenshot({ path: 'h_after_consent.png' });

    // 登入
    await page.mouse.click(640, 553);
    await new Promise((r) => setTimeout(r, 9000));
    await page.screenshot({ path: 'h_after_login.png' });

    console.log('HEADED_LOGIN_DONE');
  } catch (e) {
    console.error('ERR:', e.message);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
})();
