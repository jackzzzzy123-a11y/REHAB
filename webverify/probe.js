// 探测：打开 Web 应用登录页并截图（用于定位 UI 元素坐标）
const puppeteer = require('puppeteer-core');

(async () => {
  const browser = await puppeteer.launch({
    executablePath: 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
    headless: 'new',
    args: ['--no-sandbox', '--disable-gpu', '--disable-dev-shm-usage'],
  });
  try {
    const page = await browser.newPage();
    await page.setViewport({ width: 1280, height: 900 });
    await page.goto('http://localhost:8080/', { waitUntil: 'networkidle0', timeout: 60000 });
    // 等 Flutter CanvasKit 首帧渲染
    await new Promise((r) => setTimeout(r, 12000));
    await page.screenshot({ path: 'shot1_login.png' });
    console.log('SHOT_OK');
  } catch (e) {
    console.error('ERR:', e.message);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
})();
