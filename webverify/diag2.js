// 探查 Flutter Web 全局 API + 启用 a11y
const puppeteer = require('puppeteer-core');
const path = require('path');

(async () => {
  const userDataDir = path.resolve('./profile-diag2');
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

    const info = await page.evaluate(() => {
      // 1) 探查全局
      const w = window;
      const flutterKeys = Object.keys(w).filter((k) => /flutter/i.test(k));
      const result = {
        flutterKeys,
        hasFlutter: typeof w._flutter,
        flutterViewShadows: [],
        bodyChildren: Array.from(document.body.children).map((c) => c.tagName),
      };
      // 2) 探查每个 body child 的 shadowRoot 内容（浅）
      for (const c of document.body.children) {
        if (c.tagName.startsWith('FLUTTER-') && c.shadowRoot) {
          result.flutterViewShadows.push({
            tag: c.tagName,
            shadowChildCount: c.shadowRoot.children.length,
            firstFew: Array.from(c.shadowRoot.children).slice(0, 5).map((e) => e.tagName),
            hasGlassPane: !!c.shadowRoot.querySelector('flt-glass-pane'),
            inputCount: c.shadowRoot.querySelectorAll('input,textarea').length,
          });
        }
      }
      // 3) 检查 _flutter 内部
      if (w._flutter) {
        result._flutterKeys = Object.keys(w._flutter);
        if (w._flutter.loader) result.loaderKeys = Object.keys(w._flutter.loader);
        if (w._flutter.views) result.viewsCount = w._flutter.views.length;
      }
      return result;
    });
    console.log(JSON.stringify(info, null, 2));
  } catch (e) {
    console.error('ERR:', e.message);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
})();
