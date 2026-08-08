import UIKit
import Flutter

enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}


@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var windowAlert: UIWindow?

    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      self.windowAlert = UIWindow(frame: UIScreen.main.bounds)

      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      let batteryChannel = FlutterMethodChannel(name: "app_data",
                                                   binaryMessenger: controller.binaryMessenger)
      
      batteryChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          // Note: this method is invoked on the UI thread.
          if call.method == "appForceUpdate"
          {
              
              var argument = call.arguments as? [String: Any] // Cast arguments to a dictionary
              if let versionCode = argument?["AppStoreVersion"] as? String {
                  // Now you can use versionCode safely as a String
                  print("Version Code: \(versionCode)")
              } else {
                  print("AppStoreVersion is not a valid String or is nil")
              }
            
              self?.checkVersionApp()
              result(1)
          }
        })

    GeneratedPluginRegistrant.register(with: self)
    self.registerForPushNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func checkVersionApp() {
        
        DispatchQueue.global().async { [self] in
            
            try? isUpdateAvailable {[self] (update, error) in
                if let error = error {
                    print(error)
                } else{
                    if let app = update{
                        if app == true{
                            
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "New Version Available", message: "There is a newer version available for download! Please update the app by visiting the App Store.", preferredStyle: .alert)
                                
                                                                    alert.addAction(UIAlertAction.init(title: "Update", style: .default, handler: { (alertAction) in
                                                                        //topWindow?.isHidden = true
                                                                        //topWindow = nil
                                
                                                                        if let url = URL(string: "itms-apps://itunes.apple.com/app/id6443715290") {
                                                                            UIApplication.shared.open(url)
                                                                        }
                                                                    }))
                                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                            }
                            
                            
//                            DispatchQueue.main.async {
//
//                                let topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
//                                topWindow?.rootViewController = UIViewController()
//                                topWindow?.windowLevel = UIWindow.Level.alert + 1
//                                let alert: UIAlertController =  UIAlertController(title: "Update", message: "", preferredStyle: .alert)
//                                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (alertAction) in
//                                        //topWindow?.isHidden = true
//                                        //topWindow = nil
//
//                                        if let url = URL(string: "itms-apps://itunes.apple.com/app/id6443715290") {
//                                            UIApplication.shared.open(url)
//                                        }
//                                    }))
//
//                                topWindow?.makeKeyAndVisible()
//                                topWindow?.rootViewController?.present(alert, animated: true, completion:nil)
//
//                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
       
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        print(url)
        print(currentVersion)
        print(url)

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                //if([appStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending)
               // {
                print("Latest Version from APPLE: ")
                print(version)
                
                if version.compare(currentVersion, options: .numeric) == .orderedDescending {
                    print("store version is newer")
                    completion(true, nil)

                }else{
                    completion(false, nil)

                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    
    
    func registerForPushNotifications() {
          if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
          UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                  (granted, error) in
                  guard granted else { return }
                   self.getNotificationSettings()
              }
          } else {
              let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
              UIApplication.shared.registerUserNotificationSettings(settings)
              UIApplication.shared.registerForRemoteNotifications()
          }
         
      }
    
    func getNotificationSettings() {
         if #available(iOS 10.0, *) {
             UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                 guard settings.authorizationStatus == .authorized else { return }
                 DispatchQueue.main.async(execute: {
                     UIApplication.shared.registerForRemoteNotifications()
                     UNUserNotificationCenter.current().delegate = self
                     UIApplication.shared.applicationIconBadgeNumber = 0
                     UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                 })
             }
         } else {
               let settings: UIUserNotificationSettings =
               UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
               UIApplication.shared.registerUserNotificationSettings(settings)
         }
     }
}
