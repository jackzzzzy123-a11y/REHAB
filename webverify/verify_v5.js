// v5：精确避开 segmented/suffix 按钮的坐标
const puppeteer = require('puppeteer-core');
const path = require('path');

async function clickHard(page, x, y) {
  for (let i = 0; i < 3; i++) {
    await page.mouse.click(x, y);
    await new Promise((r) => setTimeout(r, 500));
  }
}

(async () => {
  const userDataDir = path.resolve('./profile-v5');
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

    // 帳號 input 区域：x 偏左（580 避开任何 suffix），y 偏下（380）
    await clickHard(page, 580, 380);
    await page.keyboard.type('doc', { delay: 100 });
    await new Promise((r) => setTimeout(r, 800));
    await page.screenshot({ path: 'v5_username.png' });

    // 密碼 input 区域：x 偏左（580 避开右侧 visibility 按钮），y 440
    await clickHard(page, 580, 440);
    await page.keyboard.type('123456', { delay: 100 });
    await new Promise((r) => setTimeout(r, 800));
    await page.screenshot({ path: 'v5_password.png' });

    // 同意：x 280（checkbox 左侧），y 505
    await clickHard(page, 280, 505, 1);
    await new Promise((r) => setTimeout(r, 500));
    await page.screenshot({ path: 'v5_consent.png' });

    // 登入：y 553 居中
    await page.mouse.click(640, 553);
    await new Promise((r) => setTimeout(r, 9000));
    await page.screenshot({ path: 'v5_dashboard.png' });

    console.log('V5_DONE');
  } catch (e) {
    console.error('ERR:', e.message);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
})();
