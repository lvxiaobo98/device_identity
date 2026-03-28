## 1.2.0

* feat(iOS): 实现 IDFA 获取（`DeviceIdentity.idfa`）
* feat(iOS): 新增 `DeviceIdentity.requestTrackingAuthorization()` 申请 ATT 权限
* feat: 新增 `TrackingAuthorizationStatus` 枚举表示 iOS 追踪授权状态
* chore(iOS): podspec 最低版本升至 12.0，添加 AdSupport / AppTrackingTransparency 框架依赖
* docs: 更新 README，补充 iOS 使用说明

## 1.1.0

* fix: 修复 `getUA()` 在部分设备上因 `System.getProperty` 返回 null 导致的 NPE
* fix: 修复 `register()` 中 `context as? Application` 静默失败问题，改用 `applicationContext` 安全转换
* fix: 移除 AndroidManifest 中不必要的 `WRITE_SETTINGS` 权限
* fix: 所有 Kotlin 方法添加 try-catch，获取失败时返回空字符串而非崩溃
* fix: `DeviceIdentityPlugin` 添加 `else -> result.notImplemented()` 兜底分支
* feat: Dart 侧所有方法添加 `PlatformException` 异常处理
* feat: Dart 调用使用泛型 `invokeMethod<String>` 替代无类型调用
* refactor: 移除未使用的 `dart:async` import 和空 `platformVersion()` 方法
* chore: Kotlin 升级至 1.9.24
* chore: SDK 约束升级至 `>=3.0.0`，Flutter 最低版本升级至 3.3.0
* chore: example targetSdkVersion / compileSdkVersion 升级至 35
* chore: flutter_lints 升级至 ^4.0.0
* chore: 示例应用改用 Material 3，结果展示在界面卡片中替代 print 输出

## 1.0.0

* feat: 新增获取安卓端的AndroidId、imei、oaid、ua
