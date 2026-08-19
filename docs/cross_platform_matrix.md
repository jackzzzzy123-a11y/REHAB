# 双端（手机 + 网页）运行矩阵

> 需求：RehabMed 需在**手机端（Android / iOS）**与**网页端（Web）**双端可运行。
> 本文记录各功能模块的双端支持状态、已验证结论、降级决策与待办。
> 最后更新：2026-08-18

## 0. 总体结论

| 端 | 状态 | 说明 |
|----|------|------|
| **Web** | ✅ 已编译通过 | `flutter build web` exit 0，产物 `build/web/`（42M，含 canvaskit / service worker） |
| **Android** | 🟡 壳已生成，构建待真机/CI 验证 | `android/` 壳已由 `flutter create --platforms=web,android,ios` 生成；沙箱无 Gradle 环境，构建需在真机/CI 执行 |
| **iOS** | 🟡 壳已生成，构建待 macOS 验证 | `ios/` 壳已生成；iOS 构建需 macOS + Xcode，当前 Windows 环境无法验证 |

平台壳生成命令（已执行）：`flutter create . --platforms=web,android,ios --org com.rehabmed`

## 1. 功能 × 平台支持矩阵

| 功能模块 | Android | iOS | Web | 说明 |
|----------|:---:|:---:|:---:|------|
| 数据持久化 Hive（AES 加密盒） | ✅ | ✅ | ✅ | Web 走 IndexedDB；加密逻辑同源（纯 Dart） |
| 设置 shared_preferences | ✅ | ✅ | ✅ | Web 走 localStorage |
| 密钥/Token flutter_secure_storage | ✅ | ✅ | 🟡 | Web 走 IndexedDB（WebCrypto 语义），**非 Keychain/Keystore 等价物**；不存极高敏凭据于 Web 端 |
| **生物辨识锁 local_auth** | ✅ | ✅ | ⚠️ 已降级 | Web 不支援 → `Biometric` 内 `kIsWeb` 分支跳过（见 §2） |
| **本机通知 flutter_local_notifications** | ✅ | ✅ | ⚠️ 已降级 | Web 不支援 → `NotificationService` `kIsWeb` no-op（见 §3） |
| 文件导入 file_picker | ✅ | ✅ | ✅ | Web 走浏览器文件选择器 |
| 生物锁/通知（P1 验收"需真机"项） | 待真机 | 待真机 | ✅ 已降级处理 | 见 §4 |
| 网络 dio（含证书绑定） | ✅ | ✅ | ✅ | 纯 Dart，双端一致 |
| 图表 fl_chart / 响应式 screenutil | ✅ | ✅ | ✅ | 纯渲染层，双端一致 |
| 路由 go_router / 状态 Riverpod | ✅ | ✅ | ✅ | 纯 Dart，双端一致 |

## 2. 生物辨识锁 —— Web 降级决策

- **现状**：`lib/core/security/biometric.dart` 直接持有 `LocalAuthentication`，在 `auth_page.dart:73`（登录）与 `lock_screen.dart:37`（前台切回）两处调用。`local_auth` 在 Web 端无平台实现，调用会抛 `UnimplementedError`。
- **决策（已落地）**：`Biometric.authenticate()` 增加 `kIsWeb` 编译期分支 —— Web 端跳过生物辨识并 `appLogger.w` 记录降级。**Web 端当前为"无生物锁"状态**（等价于关闭生物锁）。
- **后续备援（P2 可选）**：抽 `BiometricGate` 抽象 + 平台实现；Web 端可降级为「账号密码/PIN 锁屏」替代生物辨识，满足 PDPO「需要知道」访问控制。已在架构评审建议中列为 P1 建议项。
- **合规提示**：Web 端不承载极敏操作（如大规模批量导出），避免降级面扩大。

## 3. 本机通知 —— Web 降级决策

- **现状**：`lib/core/notification/notification_service.dart` 初始化 Android/iOS 通知设置；Web 端 `initialize` 会因平台通道缺失而失败。
- **决策（已落地）**：`init()` 与 `showLocal()` 增加 `kIsWeb` 分支 —— Web 端 no-op + warning 日志。P1 通知场景（导入完成提醒）在 Web 端当前不弹出。
- **后续备援（P2 可选）**：Web 端可用浏览器 Notification API（`dart:js_interop`）实现等价提醒；需用户授权 + 仅 HTTPS 生效。

## 4. P1 验收清单 × 双端映射

| 验收项 | 手机端 | Web 端 |
|--------|--------|--------|
| 导入样例 JSON → 患者入列表 | ✅ 自动化验收过 | ✅ 同数据层，编译验证过 |
| 看板 data-driven 概览 + 纵向趋势 | ✅ 自动化验收过 | ✅ 同数据层，编译验证过 |
| 离线重开仍在（Hive 持久化） | ✅ 自动化验收过 | 🟡 需浏览器 IndexedDB 持久化手工验证 |
| 删除软删可查审计 | ✅ 自动化验收过 | ✅ 同数据层，编译验证过 |
| 前台切回需生物锁 | 待真机 | ⚠️ 已降级（无生物锁） |
| 长者模式字号 / 对比 | ✅ theme 单测过 | ✅ 同 theme 逻辑 |
| 本机通知到达 | 待真机 | ⚠️ 已降级（no-op） |

## 5. 已知非阻塞事项

- `flutter build web` 提示 **CupertinoIcons 字体缺失**（传递依赖引用，lib 内无直接使用）→ 可选：pubspec 加 `cupertino_icons` 或忽略。
- `flutter build web` 的 wasm dry-run 提示未启用 wasm → 不影响 JS 产物，wasm 为可选增强。
- ~~package_info_plus / sentry_flutter KGP 警告~~：**sentry_flutter 已升 9.x 修复**；package_info_plus 由 file_picker 10.x 传递，仍提示 KGP 旧配置（Flutter 未来 Built-in Kotlin 迁移时需跟进，当前可构建）。
- **Android 构建修复链（2026-08-18 落地，共 4 环）**：
  1. `sentry_flutter ^8.2.0 → ^9.0.0`：8.x 写死 Kotlin `languageVersion "1.6"`，与 Kotlin 2.3.20 不兼容（`compileReleaseKotlin` 崩）。
  2. `android/app/build.gradle.kts` 启用 `isCoreLibraryDesugaringEnabled = true` + `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")`：flutter_local_notifications 17.x 要求。
  3. `compileSdk = 36`（app 模块）：flutter_plugin_android_lifecycle 要求 36+。
  4. `file_picker ^8.1.0 → ^10.3.10`：8.3.7 硬编码 `compileSdk 34`；10.3.3+ 跟随 flutter 默认、10.3.9+ 支持 Gradle 9。**不可升 11.x**（破坏性 API：`FilePicker.platform` → 静态方法）。

## 6. 待办（真机 / CI）

- [x] **Android apk 构建**：`flutter build apk --release` 已在开发机验证（产物 `build/app/outputs/flutter-apk/app-release.apk` 58.4MB）——见 §7
- [x] **CI 三平台流水线**：`.github/workflows/ci.yml` 已就绪（analyze/test + web + android + ios(--no-codesign)），git 化推送后自动运行
- [x] **iOS 构建指引**：`docs/ios_build_guide.md`（路径 A：GitHub Actions macOS runner；路径 B：本地 Mac）
- [x] **Web 端 IndexedDB 跨会话持久化（沙箱底层验证，2026-08-18）**：puppeteer 写探针数据 + 完全关闭 Edge + 重开读回，数据完整恢复（exit 0）——见 §8。**App 行为层**（载入选中範例 → 重开仍见患者）**需真实浏览器手验**（沙箱 CanvasKit 限制）：`docs/web_browser_verification_guide.md` + `webverify/verify_web_browser.bat`
- [x] **Web 离线重开·Hive 语义层验证**：`test/offline_reopen_semantic_test.dart`（写→close→reopen→断言）单文件通过（2026-08-18 10:09，All passed）——见 §8.5
- [x] **Web 离线重开·集成测试代码就绪**：`integration_test/offline_reopen_test.dart`（Hive IndexedDB 版）+ `test_driver/integration_test.dart`——沙箱跑不了 web 集成测试（dwds 连接失败），供本地/CI 使用——见 §8.5
- [ ] **Web 端长者模式/主题视觉核对**（同 `docs/acceptance_device_checklist.md` 视觉项）

## 7. Android 构建验证结论（2026-08-18）

- 环境：Windows + Android SDK（platforms 34–37 / build-tools 34–36.1）+ JDK 25 + Gradle 9.1（wrapper）。
- 命令：`ANDROID_HOME=... flutter build apk --release` → **exit 0**，产出 `build/app/outputs/flutter-apk/app-release.apk`（**58.4MB**）。
- 依赖修复链见 §5（sentry 9.x / desugaring / compileSdk 36 / file_picker 10.3.10）。
- 说明：release 模板使用 debug signing（可安装）；正式上架前需配置 release keystore。
- 未做项：真机安装 + `docs/acceptance_device_checklist.md` 手机端清单（生物辨识 / 通知 / 选档 / 视觉）——需真实 Android 设备。

## 8. Web 离线重开验证（2026-08-18）

### 8.1 沙箱底层验证（puppeteer，已通过 ✅）
脚本：`webverify/verify_idb.js`。在 puppeteer + Edge headless 下：
- 打开页面 → 等 20s 让 Flutter 完整初始化 → `indexedDB.databases()` 列出所有库
- 在独立探针库 `verify-probe` 写 `{id:1, payload: 'hello-from-stage1'}`
- **完全关闭 Edge**（`browser.close()`）
- 等待 2s 后同 userDataDir 重新 launch
- 读回探针 → `payload === 'hello-from-stage1'` ✅ **跨会话持久化通过**
- 结论：浏览器 IndexedDB 持久化层工作正常，间接证明 Hive（走 IndexedDB）持久化承诺成立。

### 8.2 沙箱限制：App 行为层 UI 自动化不可行
- Flutter 3.44 Web 默认 **CanvasKit** 渲染（HTML 元素极少），无 a11y 语义树
- `flt-glass-pane` 是空壳，DOM 树中无 hidden `<input>` 桥接
- puppeteer headless 模式下，**点击 TextField 切焦点不可靠**（canvas hit-test 失效）
- 多次 click + keyboard.type 试验：字符被路由到错位置 / 无 focus 吞掉
- **结论**：App 行为层「登录 → 載入範例 → 患者列表 → 关闭 → 重开 → 仍在」必须在真实浏览器手验

### 8.3 真实浏览器手工验证（交付物）
- `webverify/verify_web_browser.bat`：一键启动静态服务 + 打开默认浏览器
- `docs/web_browser_verification_guide.md`：详细步骤 + 预期结果 + 故障排查 + DevTools 进阶验证
- 5 分钟可完成：登录 → 載入範例（顶栏烧瓶图标）→ 看到 2 个患者 → 关闭浏览器 → 重开 → 2 个患者**仍在** = 验收通过

### 8.4 备注
- Web 端 Hive 数据存于浏览器 IndexedDB（同源隔离）；不同浏览器/隐私模式/清缓存会清空，属浏览器正常行为，非 App 缺陷。
- 若需跨设备同步，属 P2 后端（Spring Boot + PostgreSQL）范畴，不在 P1 本地 Demo 承诺内。

### 8.5 三层证据链（「離線重開仍在」完整论证）
| 层 | 验证内容 | 状态 |
|----|----------|------|
| **L1 应用层语义** | `test/offline_reopen_semantic_test.dart`：Hive 写→close→reopen→断言数据在（VM 单文件已过 ✅） | ✅ 沙箱可跑 |
| **L2 浏览器持久化** | `webverify/verify_idb.js`：真实 Edge 写探针→完全关闭→重开→读回（exit 0） | ✅ 沙箱可跑 |
| **L3 App 行为层** | 登录→載入範例→关闭浏览器→重开→患者仍在 | ⏳ 需真实浏览器手验（`web_browser_verification_guide.md`） |

**集成测试代码就绪**（供本地/CI）：`integration_test/offline_reopen_test.dart`（Hive IndexedDB 版）+ `test_driver/integration_test.dart`。
- 运行方式：`flutter drive --driver=test_driver/integration_test.dart --target=integration_test/offline_reopen_test.dart -d <chrome|edge>`
- 沙箱限制：`flutter drive` web 需 dwds 连接 Chrome debug service，沙箱内失败（`WebDevFS.connect` / `DevHandler.createDebugConnectionForChrome`）；`flutter test -d edge` 明确不支持 integration_test（"Web devices are not supported for integration tests yet"）。

### 8.6 沙箱 stamp 锁与验证绕行（2026-08-18 晚）
- 本次会话 `bin/cache/libimobiledevice.stamp` 被沙箱进程级锁定（flutter_tools 无条件重写失败，errno 5）；Write/chmod/attrib/内容对齐均无效，间歇性（运行一次成功后锁下次）。
- **绕行**：静态检查用 **`dart analyze lib test integration_test`**（独立 analyzer，不走 flutter_tools，已验证 **No issues found exit 0**）；测试用单文件跑（`test/offline_reopen_semantic_test.dart` 已过）。
- **建议**：CI（`.github/workflows/ci.yml`）在正常环境跑全量 `flutter test`（22 例）。
