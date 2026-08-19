// IndexedDB 跨会话持久化验证（沙箱内底层验证）
// 证明：浏览器 IndexedDB 写入后，关闭浏览器再重开，数据库与数据仍在。
// 这间接证明 Hive 走 IndexedDB 的持久化承诺（App 层 UI 自动化因 CanvasKit 限制无法在沙箱做）。
const puppeteer = require('puppeteer-core');
const path = require('path');

async function listIdb(page) {
  return await page.evaluate(async () => {
    const dbs = await indexedDB.databases();
    const out = [];
    for (const dbInfo of dbs) {
      out.push({ name: dbInfo.name, version: dbInfo.version });
    }
    return out;
  });
}

async function writeProbe(page) {
  // 在独立 IDB 数据库 'verify-probe' 写一条记录
  return await page.evaluate(async () => {
    return new Promise((resolve, reject) => {
      const req = indexedDB.open('verify-probe', 1);
      req.onupgradeneeded = (e) => {
        const db = e.target.result;
        if (!db.objectStoreNames.contains('probe')) {
          db.createObjectStore('probe', { keyPath: 'id' });
        }
      };
      req.onsuccess = (e) => {
        const db = e.target.result;
        const tx = db.transaction('probe', 'readwrite');
        tx.objectStore('probe').put({ id: 1, payload: 'hello-from-stage1', ts: Date.now() });
        tx.oncomplete = () => { db.close(); resolve('OK'); };
        tx.onerror = () => { db.close(); reject(tx.error); };
      };
      req.onerror = () => reject(req.error);
    });
  });
}

async function readProbe(page) {
  return await page.evaluate(async () => {
    return new Promise((resolve) => {
      const req = indexedDB.open('verify-probe', 1);
      req.onsuccess = (e) => {
        const db = e.target.result;
        if (!db.objectStoreNames.contains('probe')) { db.close(); resolve(null); return; }
        const tx = db.transaction('probe', 'readonly');
        const getReq = tx.objectStore('probe').get(1);
        getReq.onsuccess = () => { db.close(); resolve(getReq.result || null); };
        getReq.onerror = () => { db.close(); resolve(null); };
      };
      req.onerror = () => resolve(null);
    });
  });
}

async function launchAndWait(userDataDir) {
  const browser = await puppeteer.launch({
    executablePath: 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
    headless: 'new',
    userDataDir,
    args: ['--no-sandbox', '--disable-gpu', '--disable-dev-shm-usage'],
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 1280, height: 900 });
  await page.goto('http://localhost:8080/', { waitUntil: 'networkidle0', timeout: 60000 });
  // 等 Flutter 完整初始化（CanvasKit + Hive boxes）
  await new Promise((r) => setTimeout(r, 20000));
  return { browser, page };
}

(async () => {
  const userDataDir = path.resolve('./profile-idb-verify');
  console.log('=== STAGE 1: 打开 + 初始化 + 写入探测数据 ===');
  let browser, page;
  try {
    ({ browser, page } = await launchAndWait(userDataDir));
    // 1) 看 Flutter 创建了哪些 IDB 数据库
    const dbs1 = await listIdb(page);
    console.log('Flutter 初始化后 IDB 数据库列表:', JSON.stringify(dbs1));
    // 2) 在独立探针库写一条数据
    const w = await writeProbe(page);
    console.log('探针写入:', w);
    // 3) 立即读回确认
    const r1 = await readProbe(page);
    console.log('探针立即读回:', JSON.stringify(r1));
    // 4) 看 hive/相关数据库的 object store 列表（深查）
    const hiveStores = await page.evaluate(async () => {
      const dbs = await indexedDB.databases();
      const out = {};
      for (const dbInfo of dbs) {
        if (!dbInfo.name) continue;
        try {
          const db = await new Promise((resolve, reject) => {
            const r = indexedDB.open(dbInfo.name);
            r.onsuccess = (e) => resolve(e.target.result);
            r.onerror = () => reject(r.error);
          });
          out[dbInfo.name] = { version: db.version, stores: Array.from(db.objectStoreNames) };
          db.close();
        } catch (e) {
          out[dbInfo.name] = { error: e.message };
        }
      }
      return out;
    });
    console.log('各数据库 object stores:', JSON.stringify(hiveStores, null, 2));
  } catch (e) {
    console.error('STAGE1 ERR:', e.message);
    process.exitCode = 1;
  } finally {
    if (browser) await browser.close();
  }

  console.log('\n=== STAGE 2: 完全关闭后重开，验证数据仍在 ===');
  // 等待几秒确保 Edge 完全关闭
  await new Promise((r) => setTimeout(r, 2000));
  try {
    ({ browser, page } = await launchAndWait(userDataDir));
    const dbs2 = await listIdb(page);
    console.log('重开后 IDB 数据库列表:', JSON.stringify(dbs2));
    const r2 = await readProbe(page);
    console.log('重开后探针读回:', JSON.stringify(r2));
    const persisted = !!r2 && r2.payload === 'hello-from-stage1';
    console.log(persisted
      ? '\n✅ 跨会话持久化通过：探针数据在浏览器完全关闭后重开仍在。'
      : '\n❌ 跨会话持久化失败！');
    process.exitCode = persisted ? 0 : 2;
  } catch (e) {
    console.error('STAGE2 ERR:', e.message);
    process.exitCode = 1;
  } finally {
    if (browser) await browser.close();
  }
})();
