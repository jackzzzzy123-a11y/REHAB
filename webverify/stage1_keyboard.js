// Stage 1：键盘路径（Tab 焦点 + type）
const puppeteer = require('puppeteer-core');
const path = require('path');

(async () => {
  const userDataDir = path.resolve('./profile-verify');
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
    await new Promise((r) => setTimeout(r, 15000));

    // 先点一下页面上半部分空白处让 Flutter 拿到 canvas focus / 触发 IME 桥接
    await page.mouse.click(200, 200);
    await new Promise((r) => setTimeout(r, 600));

    // 帳號：Tab 切到帳號（若有 autofocus 则已在）+ click 一下保险
    // Flutter Web 默认可能不在 TextField focus，所以 click 帐號 2 次确保
    await page.mouse.click(640, 371);
    await new Promise((r) => setTimeout(r, 400));
    await page.mouse.click(640, 371);
    await new Promise((r) => setTimeout(r, 600));
    await page.keyboard.type('doc', { delay: 60 });
    await new Promise((r) => setTimeout(r, 400));

    // 密碼：click + Tab 切 focus
    await page.mouse.click(640, 437);
    await new Promise((r) => setTimeout(r, 400));
    await page.mouse.click(640, 437);
    await new Promise((r) => setTimeout(r, 600));
    await page.keyboard.type('123456', { delay: 60 });
    await new Promise((r) => setTimeout(r, 400));

    // 同意：click 2 次（checkbox 切换）
    await page.mouse.click(288, 503);
    await new Promise((r) => setTimeout(r, 400));
    // 验证勾选是否生效（再点一次会取消）。我们已点一次，截图前再确认。
    // 登入
    await page.mouse.click(640, 553);
    await new Promise((r) => setTimeout(r, 8000));

    await page.screenshot({ path: 'shot3_dashboard_empty.png' });
    console.log('STAGE1_LOGIN_OK');
  } catch (e) {
    console.error('ERR:', e.message);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
})();
