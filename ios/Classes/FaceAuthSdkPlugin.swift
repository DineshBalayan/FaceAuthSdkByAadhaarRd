import Flutter
import UIKit
import MachO
import Darwin
import Foundation
import LocalAuthentication

public class FaceAuthSdkPlugin: NSObject, FlutterPlugin {

  private var flutterResult: FlutterResult?
  private var channel: FlutterMethodChannel?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "face_auth_sdk", binaryMessenger: registrar.messenger())
    let instance = FaceAuthSdkPlugin()
    instance.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {

    // ✅ Platform version
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    // ✅ Start authentication ()
    case "startFaceAuthentication":
      startFaceAuth(result: result)

    // ✅ Start face capture flow (By Aadhaar RD)
    case "startAadhaarRd":
      guard let args = call.arguments as? [String: Any],
      let pidOptions = args["pidOptions"] as? String else {
        result(FlutterError(code:"INVALID_ARGS", message:"pidOptions missing", details:nil))
        return
      }
      self.flutterResult = result
      launchFaceRD(pidOptions: pidOptions)

    // ✅ RD App check
    case "isRdAppInstalled":
      isRdAppInstalled(result: result)

    // ✅ Security checks
    case "isJailBroken":
      result(isJailBroken())

    case "isDebuggerAttached":
      result(isDebuggerAttached())

    case "isFridaDetected":
      result(isFridaDetected())

    case "isEmulator":
      result(isSimulator())

    // ✅ Exit app (host app)
    case "exitApp":
      DispatchQueue.main.async {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          exit(0)
        }
      }
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func getDeviceToken() -> String? {
    #if targetEnvironment(simulator)
    return nil // Simulator cannot generate device token
    #else
    if #available(iOS 11.0, *) {
      let device = DCDevice.current
      if device.isSupported {
        var tokenString: String?
        let semaphore = DispatchSemaphore(value: 0)

        device.generateToken { data, error in
          if let data = data {
            tokenString = data.map { String(format: "%02hhx", $0) }.joined()
          }
          semaphore.signal()
        }
        semaphore.wait()
        return tokenString
      } else {
        return nil
      }
    } else {
      return nil
    }
    #endif
  }
  // MARK: - 🔹 Initialize on load
  override public init() {
    super.init()

    // Setup capture/screenshot monitoring
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenCaptureChanged),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(userDidTakeScreenshot),
      name: UIApplication.userDidTakeScreenshotNotification,
      object: nil
    )

    handleScreenCapture()
  }

  // MARK: - 🔹 Face Authentication Flow (Play integrity)
  private func startFaceAuth(result: @escaping FlutterResult) {
    #if targetEnvironment(simulator)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      result([
        "status": "success",
        "message": "Simulated Face Authentication (Simulator)",
        "transactionId": UUID().uuidString
      ])
    }
    #else
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      let response: [String: Any] = [
        "status": "success",
        "message": "Real Device Face Authentication Successful (stub)",
        "transactionId": UUID().uuidString
      ]
      result(response)
    }
    #endif
  }

  // MARK: - 🔹 Face RD Integration
  private func isRdAppInstalled(result: @escaping FlutterResult) {
    #if targetEnvironment(simulator)
    result(false)
    #else
    guard let url = URL(string: "FaceRDLib://") else {
      result(false)
      return
    }
    result(UIApplication.shared.canOpenURL(url))
    #endif
  }

  private func launchFaceRD(pidOptions: String) {
    let callbackScheme = "faceRDCallBack://response"
    let encodedRequest = pidOptions.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let urlString = "FaceRDLib://in.gov.uidai.rdservice.face.CAPTURE?request=\(encodedRequest)&callback=\(callbackScheme)"

    guard let url = URL(string: urlString) else {
      flutterResult?(FlutterError(code: "INVALID_URL", message: "Cannot create RD URL", details: nil))
      flutterResult = nil
      return
    }

    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      flutterResult?(FlutterError(code: "RD_NOT_INSTALLED", message: "Face RD App not installed", details: nil))
      flutterResult = nil
    }
  }

  // MARK: - 🔹 Security Checks
  private func isJailBroken() -> Bool {
    #if targetEnvironment(simulator)
    return false
    #endif

    let suspiciousPaths = [
      "/Applications/Cydia.app",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/sbin/sshd",
      "/etc/apt",
      "/private/var/lib/apt/"
    ]

    if suspiciousPaths.contains(where: { FileManager.default.fileExists(atPath: $0) }) {
      return true
    }

    let testPath = "/private/" + UUID().uuidString
    do {
      try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
      try FileManager.default.removeItem(atPath: testPath)
      return true
    } catch {}

    if UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!) {
      return true
    }
    return false
  }

  private func isDebuggerAttached() -> Bool {
    #if targetEnvironment(simulator)
    return false
    #endif

    var info = kinfo_proc()
    var size = MemoryLayout<kinfo_proc>.size
    var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]

    let result = sysctl(&name, UInt32(name.count), &info, &size, nil, 0)
    if result != 0 { return false }

    return (info.kp_proc.p_flag & P_TRACED) != 0
  }

  private func isFridaDetected() -> Bool {
    #if targetEnvironment(simulator)
    return false
    #endif

    let suspiciousLibs = ["fridagadget", "frida", "cycript", "libcycript"]

    for i in 0..<_dyld_image_count() {
      if let namePtr = _dyld_get_image_name(i),
      let name = String(validatingUTF8: namePtr)?.lowercased() {
        for lib in suspiciousLibs where name.contains(lib) {
          return true
        }
      }
    }
    return false
  }

  private func isSimulator() -> Bool {
    #if targetEnvironment(simulator)
    return true
    #else
    return false
    #endif
  }

  // MARK: - 🔹 Screen Recording & Screenshot Handling
  @objc private func screenCaptureChanged() {
    handleScreenCapture()
  }

  private func handleScreenCapture() {
    if UIScreen.main.isCaptured {
      if let window = UIApplication.shared.windows.first {
        let overlay = UIView(frame: window.bounds)
        overlay.backgroundColor = .black
        overlay.tag = 9999
        window.addSubview(overlay)
      }
    } else {
      if let window = UIApplication.shared.windows.first,
      let overlay = window.viewWithTag(9999) {
        overlay.removeFromSuperview()
      }
    }
  }

  @objc private func userDidTakeScreenshot() {
    if let window = UIApplication.shared.windows.first {
      let overlay = UIView(frame: window.bounds)
      overlay.backgroundColor = UIColor.black
      overlay.alpha = 1.0
      overlay.tag = 9998
      window.addSubview(overlay)
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        overlay.removeFromSuperview()
      }
    }
  }

  // MARK: - 🔹 Handle Callback from RD App
  public func handleOpenUrl(_ url: URL) -> Bool {
    guard url.scheme == "faceRDCallBack" else { return false }

    if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
    let queryItems = components.queryItems {
      if let item = queryItems.first(where: { $0.name == "request" }),
      let pidBlock = item.value {
        flutterResult?(pidBlock)
        flutterResult = nil
        return true
      }
    }

    flutterResult?(FlutterError(code: "INVALID_CALLBACK", message: "PID block missing", details: nil))
    flutterResult = nil
    return true
  }
}
