# device_identity

用于获取设备标识的插件（androidId、Imei、oaid等）

## 安装

`device_identity: latestVersion`

## 使用

> 只能在Andoird平台调用（注：插件已经对平台做了条件判断）

- 同意协议后调用

`await DeviceIdentity.register();`
  
- 获取安卓ID，可能为空

`String androidId = await DeviceIdentity.androidId;`

- 获取IMEI，只支持Android 10之前的系统，需要READ_PHONE_STATE权限，可能为空

`String imei = await DeviceIdentity.imei;`

- 获取OAID/AAID

`String oaid = await DeviceIdentity.oaid;`

- 获取UA

`String ua = await DeviceIdentity.ua;`

## 注意

1. 在 android/app/build.gradle 中将 minSdkVersion 设置为 19（或大于19）

## 后续计划

- iOS端idfa的获取

## 感谢

[Android_CN_OAID](https://github.com/gzu-liyujiang/Android_CN_OAID)提供的SDK