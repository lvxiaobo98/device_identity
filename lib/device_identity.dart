import 'dart:io';

import 'package:flutter/services.dart';

/// iOS ATT 授权状态，对应 ATTrackingManager.AuthorizationStatus
enum TrackingAuthorizationStatus {
  /// 用户尚未授权
  notDetermined,

  /// 设备受限，无法请求授权
  restricted,

  /// 用户已拒绝
  denied,

  /// 用户已授权
  authorized,
}

/// 获取设备标识
class DeviceIdentity {
  static const MethodChannel _channel = MethodChannel('device_identity');

  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;

  /// 在`Application#onCreate`里初始化（仅 Android）
  /// 注意APP合规性，若最终用户未同意隐私政策则不要调用
  static Future<void> register() async {
    if (!isAndroid) return;
    try {
      await _channel.invokeMethod<void>('register');
    } on PlatformException catch (_) {
      // 初始化失败时静默忽略，后续获取标识时会返回空字符串
    }
  }

  /// 获取安卓ID，可能为空（仅 Android）
  static Future<String> get androidId async {
    if (!isAndroid) return '';
    try {
      return await _channel.invokeMethod<String>('getAndroidID') ?? '';
    } on PlatformException {
      return '';
    }
  }

  /// 获取IMEI，只支持Android 10之前的系统，需要READ_PHONE_STATE权限，可能为空（仅 Android）
  static Future<String> get imei async {
    if (!isAndroid) return '';
    try {
      return await _channel.invokeMethod<String>('getIMEI') ?? '';
    } on PlatformException {
      return '';
    }
  }

  /// 获取OAID/AAID，可能为空（仅 Android）
  static Future<String> get oaid async {
    if (!isAndroid) return '';
    try {
      return await _channel.invokeMethod<String>('getOAID') ?? '';
    } on PlatformException {
      return '';
    }
  }

  /// 获取UA（仅 Android）
  static Future<String> get ua async {
    if (!isAndroid) return '';
    try {
      return await _channel.invokeMethod<String>('getUA') ?? '';
    } on PlatformException {
      return '';
    }
  }

  /// 请求广告追踪权限（仅 iOS）
  ///
  /// iOS 14+ 会弹出系统授权弹窗；iOS 12/13 直接根据
  /// `isAdvertisingTrackingEnabled` 返回结果。
  ///
  /// 需在应用的 Info.plist 中添加：
  /// `NSUserTrackingUsageDescription` — 说明追踪用途的文案
  static Future<TrackingAuthorizationStatus> requestTrackingAuthorization() async {
    if (!isIOS) return TrackingAuthorizationStatus.authorized;
    try {
      final int raw =
          await _channel.invokeMethod<int>('requestTrackingAuthorization') ?? 0;
      if (raw < 0 || raw >= TrackingAuthorizationStatus.values.length) {
        return TrackingAuthorizationStatus.notDetermined;
      }
      return TrackingAuthorizationStatus.values[raw];
    } on PlatformException {
      return TrackingAuthorizationStatus.notDetermined;
    }
  }

  /// 获取 IDFA（广告标识符），未授权或不支持时返回空字符串（仅 iOS）
  ///
  /// 调用前请先通过 [requestTrackingAuthorization] 获取用户授权。
  static Future<String> get idfa async {
    if (!isIOS) return '';
    try {
      return await _channel.invokeMethod<String>('getIDFA') ?? '';
    } on PlatformException {
      return '';
    }
  }
}
