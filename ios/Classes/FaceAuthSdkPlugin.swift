import Flutter
import UIKit

public class FaceAuthSdkPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "face_auth_sdk", binaryMessenger: registrar.messenger())
    let instance = FaceAuthSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    case "startFaceAuth":
      startFaceAuth(result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func startFaceAuth(result: @escaping FlutterResult) {
    // Example: simulate a successful face auth result
    // Later replace with your Aadhaar RD face service call

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      let response: [String: Any] = [
        "status": "success",
        "message": "Face authentication successful",
        "transactionId": UUID().uuidString
      ]
      result(response)
    }
  }
}
