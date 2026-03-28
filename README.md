# device_identity

用于获取设备标识的插件（androidId、Imei、oaid、idfa等）

## 安装

```yaml
device_identity: latestVersion
```

---

## Android 使用

> 注意 APP 合规性，须在用户同意隐私政策后再调用任何接口。

**1. 初始化（同意协议后调用）**

```dart
await DeviceIdentity.register();
```

**2. 获取各标识符**

```dart
// 获取安卓ID，可能为空
String androidId = await DeviceIdentity.androidId;

// 获取IMEI，只支持 Android 10 以下，需要 READ_PHONE_STATE 权限，可能为空
String imei = await DeviceIdentity.imei;

// 获取 OAID/AAID，可能为空
String oaid = await DeviceIdentity.oaid;

// 获取 User-Agent
String ua = await DeviceIdentity.ua;
```

**注意事项**

- 在 `android/app/build.gradle` 中将 `minSdkVersion` 设置为 19 或以上

---

## iOS 使用

### 配置 Info.plist

在应用的 `ios/Runner/Info.plist` 中添加追踪用途说明（必须，否则审核被拒）：

```xml
<key>NSUserTrackingUsageDescription</key>
<string>我们使用广告标识符来为您提供个性化的广告内容</string>
```

### 请求权限并获取 IDFA

```dart
// 弹出系统授权弹窗（iOS 14+），iOS 12/13 直接返回结果
TrackingAuthorizationStatus status = await DeviceIdentity.requestTrackingAuthorization();

if (status == TrackingAuthorizationStatus.authorized) {
  String idfa = await DeviceIdentity.idfa;
  print('IDFA: $idfa');
}
```

### TrackingAuthorizationStatus 枚举值

| 值 | 含义 |
|----|------|
| `notDetermined` | 用户尚未授权 |
| `restricted` | 设备受限，无法请求 |
| `denied` | 用户已拒绝 |
| `authorized` | 用户已授权 |

---

## 感谢

- [Android_CN_OAID](https://github.com/gzu-liyujiang/Android_CN_OAID) 提供的 OAID SDK
