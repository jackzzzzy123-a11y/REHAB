# Web 浏览器离线重开验证指南

> 目的：验证「数据写入 → 完全关闭浏览器 → 重新打开 → 数据仍在」（Hive 在 Web 端走 IndexedDB 的持久化承诺）。
> 适用：RehabMed Web build（`build/web/`）。
> 用时：约 5 分钟。

## 0. 前置条件

- `build/web/` 已构建（`flutter build web --release`）。如未构建，先跑：
  ```bash
  flutter build web --release
  ```
- 本机有 **Python 3**（用于起静态服务）。**Edge 或 Chrome 浏览器**。

## 1. 一键启动（推荐）

双击 `webverify/verify_web_browser.bat`（项目根的 `webverify/` 下）。

脚本会自动：
1. 启动 Python 静态服务器（后台，最小化窗口，端口 8080/8081）
2. 用默认浏览器打开 `http://localhost:PORT/`

按浏览器里的步骤操作即可。

## 2. 手动启动（备选）

```bash
# 进入 build/web 目录
cd build/web

# 任选一种静态服务器
python -m http.server 8080        # Python
npx serve . -l 8080              # Node.js
```

然后浏览器打开 `http://localhost:8080/`。

## 3. 验证步骤（按序操作）

| 步骤 | 操作 | 预期 |
|------|------|------|
| 1 | 浏览器出现 RehabMed 登录页（医生角色默认选中） | 看到「康復醫療」标题 + 角色选择 + 帐號密碼 |
| 2 | 点「醫生」段（确保未切到患者） | 「醫生」保持 ✓ |
| 3 | 点「帳號」输入框 → 输入 `doc` | 框内出现 `doc` |
| 4 | 点「密碼」输入框 → 输入 `123456`（≥6 位） | 框内出现 `●●●●●●` |
| 5 | 勾选「我已閱讀並同意《個人資料收集聲明》」 | 勾选框变 ✓ |
| 6 | 点「登入」按钮 | 跳转至仪表板，显示 AppBar 顶栏 + 空患者列表 |
| 7 | 点 AppBar **右起第 3 个图标**（烧瓶 🔬，tooltip「載入範例」） | 短暂 loading，随后患者列表出现 2 条 |
| 8 | 确认患者卡片：床號 A-12·康（A-15·復） | 列表渲染姓名 + 床號 |
| 9 | **完全关闭整个浏览器**（窗口右上 ✕ 全部关闭） | 浏览器进程结束 |
| 10 | 等待 2 秒，重新打开 `http://localhost:8080/` | 重新进入登录页（登录态因 Web secure_storage 仍持久化，会**自动还原**为已登录；若未自动还原则重新走 1-6 步） |
| 11 | 检查仪表板患者列表 | **2 条患者仍在** = 离线重开通过 ✅ |

> **为何关闭后还要再登录？** Web 端 secure_storage 走 IndexedDB 加密存储 token，重开应能自动还原（`restoreSession`）。若自动还原未生效，重复 1-6 步即可——患者数据本身仍由 Hive patientsBox 持久化，**这才是本验证的目标**。

## 4. 预期结果判断

| 检查项 | 通过条件 |
|--------|----------|
| **A. 写入成功** | 步骤 7 后仪表板出现 2 个患者（P-1001「康」、P-1002「復」） |
| **B. 重开仍在** | 步骤 11 后**无需重新载入选中範例**，2 个患者**仍在**（同一 ID 同一姓名） |
| **C. 登录态**（加分项） | 步骤 10 重开时若直接进入仪表板（无登录页）= secure_storage Web 端持久化也通过 |

A + B 是核心，B 通过 = spec §16「離線重開仍在」验收通过。

## 5. 故障排查

| 现象 | 排查 |
|------|------|
| 步骤 1 页面一直白屏 | 等 10-20 秒（CanvasKit 首次加载）；如仍白屏：DevTools Console 看网络错误 |
| 步骤 6 登入后未跳转，仍停留登录页 | 检查帳號非空 + 密碼 ≥ 6 位（mock auth 校验）；错误信息会显示 |
| 步骤 7 点了烧瓶图标但患者没出现 | AppBar 第几个图标对一下：右起 1=登出，2=设置，3=载入选中範例，4=导入 |
| 步骤 11 患者列表为空 | IndexedDB 未持久化——可能浏览器隐私模式/自动清缓存/换浏览器；请用**非隐私**窗口 |

## 6. 进阶验证（DevTools）

按 `F12` → Application 面板 → Storage → IndexedDB：

- 重开**前**应看到 hive 相关数据库（如 `hive`、`box`）含 `patients` 等 object store
- 重开**后**这些数据库和 object store 仍在
- 加密的 record 内容（binary）应与重开前一致

## 7. 沙箱环境说明

**为何不在沙箱内做端到端 UI 自动化？**

- Flutter 3.44 Web 默认用 **CanvasKit** 渲染（HTML 元素极少），无 a11y 语义树
- puppeteer headless 模式下，**点击 TextField 切焦点不可靠**（canvas hit-test 在 headless 失效）
- 也无 hidden `<input>` 桥接可注入字符（DOM dump 已确认 `flt-glass-pane` 是空壳）
- 沙箱内可做的**基础层验证**（puppeteer 直接 evaluate 写 IndexedDB 跨会话仍在）已通过；App 行为层的「数据流 + 重开」必须在真实浏览器手验
- **沙箱限制：headless CanvasKit UI 自动化不可行**（此结论 2026-08-18 验证）

## 8. 交付物

- `webverify/verify_web_browser.bat`：一键启动脚本（双击即用）
- `build/web/`：已构建的 Web 产物（**可部署**到任何静态托管：CloudStudio / GitHub Pages / Vercel）
- 线上已部署（项目内 CloudStudio 沙盒）见 `docs/cross_platform_matrix.md` §6/§8
