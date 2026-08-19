// Stage 1 v3：click 多次确保 focus + 慢速 type
const puppeteer = require('puppeteer-core');
const path = require('path');

async function ensureFocus(page, x, y, n = 3) {
  for (let i = 0; i < n; i++) {
    await page.mouse.click(x, y);
    await new Promise((r) => setTimeout(r, 400));
  }
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
    await new Promise((r) => setTimeout(r, 15000));

    // 1) 點擊空白處拿 canvas focus
    await page.mouse.click(200, 200);
    await new Promise((r) => setTimeout(r, 600));

    // 2) 帳號：click 3 次確保 focus，type 慢
    await ensureFocus(page, 640, 371, 3);
    await new Promise((r) => setTimeout(r, 600));
    await page.screenshot({ path: 'shot_a_focus_username.png' });
    await page.keyboard.type('doc', { delay: 100 });
    await new Promise((r) => setTimeout(r, 500));
    await page.screenshot({ path: 'shot_b_after_doc.png' });

    // 3) 密碼：click 3 次，type
    await ensureFocus(page, 640, 437, 3);
    await new Promise((r) => setTimeout(r, 600));
    await page.screenshot({ path: 'shot_c_focus_password.png' });
    await page.keyboard.type('123456', { delay: 100 });
    await new Promise((r) => setTimeout(r, 500));
    await page.screenshot({ path: 'shot_d_after_pwd.png' });

    // 4) 同意：click 3 次（checkbox 會切換，先看截图决定是否要再点）
    await ensureFocus(page, 288, 503, 1);
    await new Promise((r) => setTimeout(r, 500));
    await page.screenshot({ path: 'shot_e_consent.png' });

    // 5) 登入
    await ensureFocus(page, 640, 553, 1);
    await new Promise((r) => setTimeout(r, 9000));
    await page.screenshot({ path: 'shot_f_dashboard.png' });

    console.log('STAGE1_V3_OK');
  } catch (e) {
    console.error('ERR:', e.message);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
})();
