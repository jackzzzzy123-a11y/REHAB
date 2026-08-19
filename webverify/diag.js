// 诊断：dump Flutter Web DOM 结构
const puppeteer = require('puppeteer-core');
const path = require('path');

(async () => {
  const userDataDir = path.resolve('./profile-diag');
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

    // 1) 点帳號框，dump DOM
    await page.mouse.click(640, 371);
    await new Promise((r) => setTimeout(r, 1500));

    const dom = await page.evaluate(() => {
      const result = {
        inputCount: document.querySelectorAll('input').length,
        textareaCount: document.querySelectorAll('textarea').length,
        editableCount: document.querySelectorAll('[contenteditable]').length,
        inputTags: [],
        bodyChildTags: Array.from(document.body.children).map((c) => c.tagName + (c.id ? '#' + c.id : '')),
        glassPaneHTML: (document.querySelector('flt-glass-pane') || {}).outerHTML?.substring(0, 2000) || 'no flt-glass-pane',
      };
      document.querySelectorAll('input, textarea, [contenteditable]').forEach((el) => {
        result.inputTags.push({
          tag: el.tagName,
          type: el.type || '',
          cls: el.className || '',
          parent: el.parentElement?.tagName || '',
          visible: el.offsetParent !== null,
        });
      });
      return result;
    });
    console.log(JSON.stringify(dom, null, 2));
  } catch (e) {
    console.error('ERR:', e.message);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
})();
