import Flutter
import UIKit
import AdSupport
import AppTrackingTransparency

public class SwiftDeviceIdentityPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "device_identity",
            binaryMessenger: registrar.messenger()
        )
        let instance = SwiftDeviceIdentityPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getIDFA":
            result(getIDFA())
        case "requestTrackingAuthorization":
            requestTrackingAuthorization(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // 获取 IDFA，未授权时返回空字符串
    private func getIDFA() -> String {
        if #available(iOS 14, *) {
            guard ATTrackingManager.trackingAuthorizationStatus == .authorized else {
                return ""
            }
        } else {
            guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
                return ""
            }
        }
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }

    // 请求 ATT 权限（iOS 14+），返回授权状态的 rawValue（Int）
    // 状态值对应 ATTrackingManager.AuthorizationStatus:
    //   0 = notDetermined, 1 = restricted, 2 = denied, 3 = authorized
    // iOS 14 以下直接根据 isAdvertisingTrackingEnabled 返回 denied(2) 或 authorized(3)
    private func requestTrackingAuthorization(result: @escaping FlutterResult) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    result(Int(status.rawValue))
                }
            }
        } else {
            let enabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            result(enabled ? 3 : 2)
        }
    }
}
