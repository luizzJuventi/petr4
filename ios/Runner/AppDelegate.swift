import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller = window.rootViewController as! FlutterViewController
    
    let channel = FlutterMethodChannel(name: "petr4_module", binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      if call.method == "openMyCustomScreen" {
        let vc = MyCustomScreen()
        controller.present(vc, animated: true, completion: nil)
        result("Custom screen opened successfully.")
      }
      else {
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

class MyCustomScreen: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create a label to display some text
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    label.text = "This is my custom screen"
    label.textAlignment = .center
    label.center = view.center
    
    // Add the label to the view
    view.addSubview(label)
    
    // Set the background color
    view.backgroundColor = .white
  }
}
