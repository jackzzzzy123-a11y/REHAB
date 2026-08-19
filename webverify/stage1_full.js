// Stage 1 完整：使用 Flutter Web 隐藏 IME input 设值（CanvasKit 下坐标点击不可靠）
const puppeteer = require('puppeteer-core');
const path = require('path');

const FLUTTER_INPUT_SELECTORS = [
  'flt-glass-pane input',
  'flt-glass-pane textarea',
  'input.editable',
  'textarea.editable',
  'input[type="text"]',
  'input',
];

async function clickField(page, x, y) {
  // 切 focus：点 canvas 上的 TextField 位置
  await page.mouse.click(x, y);
  await new Promise((r) => setTimeout(r, 400));
}

async function setFlutterInputValue(page, value) {
  // Flutter Web 只在 TextField 获得 focus 时才挂隐藏 input。先等它出现。
  await page.waitForSelector(
    'flt-glass-pane input, flt-glass-pane textarea, input.editable, input',
    { timeout: 6000 },
  );
  // Flutter Web 把所有 IME 字符送到一个隐藏 input。点击切换 FocusNode 后，
  // 直接对该隐藏 input 设值并 dispatch input 事件，Flutter 路由到当前 focus TextField。
  await page.evaluate((val) => {
    const sels = ['flt-glass-pane input', 'flt-glass-pane textarea', 'input.editable', 'textarea.editable', 'input'];
    let target = null;
    for (const sel of sels) {
      const el = document.querySelector(sel);
      if (el) { target = el; break; }
    }
    if (!target) throw new Error('flutter hidden input not found');
    const proto = target.tagName === 'TEXTAREA' ? window.HTMLTextAreaElement.prototype : window.HTMLInputElement.prototype;
    const setter = Object.getOwnPropertyDescriptor(proto, 'value').set;
    setter.call(target, val);
    target.dispatchEvent(new Event('input', { bubbles: true }));
    target.dispatchEvent(new Event('change', { bubbles: true }));
  }, value);
  await new Promise((r) => setTimeout(r, 400));
}

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
    await new Promise((r) => setTimeout(r, 12000));

    // 确保角色 = 醫生（SegmentedButton 默认 doctor，但保险起见点一下醫生）
    await page.mouse.click(595, 307);
    await new Promise((r) => setTimeout(r, 300));

    // 帳號：click focus + 设值
    await clickField(page, 640, 371);
    await setFlutterInputValue(page, 'doc');
    // 密碼：click focus + 设值
    await clickField(page, 640, 437);
    await setFlutterInputValue(page, '123456');
    // 同意
    await page.mouse.click(288, 503);
    await new Promise((r) => setTimeout(r, 400));
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
