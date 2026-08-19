# iOS 构建指引（Windows 环境无法本地构建）

> 背景：RehabMed 需要双端（手机 + 网页）运行。当前开发环境为 **Windows**，而 iOS 构建**必须**在 **macOS + Xcode** 上进行（Apple 平台工具链约束，与项目代码无关）。
> 本文给出两条可执行路径，任选其一即可获得 iOS 构建产物与验证结果。

## 路径 A：GitHub Actions CI（推荐，零本地依赖）

项目已含 `.github/workflows/ci.yml`，其中 `build-ios` job 会在 macOS runner 上执行：

```bash
# 1. 初始化仓库并推送（当前项目尚未 git 化）
git init
git add -A
git commit -m "chore: 平台壳 + CI"
git remote add origin <your-github-repo-url>
git push -u origin main
```

推送后 Actions 自动运行 4 个 job：
- `analyze-test`（ubuntu）→ flutter analyze + flutter test
- `build-web`（ubuntu）→ flutter build web（产物上传 artifact）
- `build-android`（ubuntu）→ flutter build apk --release（产物上传 artifact）
- `build-ios`（macos）→ `flutter build ios --release --no-codesign`（产物上传 artifact）

> `--no-codesign` 无需 Apple 证书即可验证**编译通过**（验收「iOS 端可构建」的最低标准）。
> 产物在 Actions 页面 Artifacts 区下载（`.app` 包），可拖入已解锁的模拟器安装。

## 路径 B：本地 macOS（有 Mac 时的最快路径）

```bash
# 前置：Xcode（含 Command Line Tools）+ CocoaPods
xcode-select --install
sudo gem install cocoapods   # 或 brew install cocoapods

cd rehab
flutter pub get
cd ios && pod install && cd ..

# 构建（无需签名，验证编译）
flutter build ios --release --no-codesign

# 真机部署（需 Apple Developer 账号 + 签名配置）
# flutter build ios --release
# flutter install
```

## iOS 特有注意事项（RehabMed）

| 项 | 说明 |
|----|------|
| 最低系统要求 | macOS 14+ / Xcode 15+（配合 Flutter 3.44.8） |
| 生物辨识 | `local_auth` 在 iOS 走 Face ID / Touch ID，需在 `Info.plist` 声明 `NSFaceIDUsageDescription`（已由模板生成，文案可定制） |
| 本机通知 | `flutter_local_notifications` iOS 需在 `AppDelegate.swift` 挂载插件注册（Flutter 模板默认已处理） |
| 隐私合规 | 香港 PDPO 第4原则：iOS Keychain（`flutter_secure_storage`）已加密存储 token/密钥，符合 at-rest 加密要求 |
| 审核注意 | 如 App 上架 App Store，需额外完成 MDACS 医疗器械评估（若被界定为 SaMD，见 p1_spec 合规章节） |

## 验收结论（iOS）

- **编译级验证**：CI `build-ios` job 绿 = 通过（无需本机 Mac）。
- **真机级验证**：需在真实 iPhone 上执行 `docs/acceptance_device_checklist.md` 的生物辨识锁 / 通知 / 选档 / 视觉清单。
