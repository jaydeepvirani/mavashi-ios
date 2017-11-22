//
//  AppDelegate.swift
//  Mawashi
//
//  Created by Sandeep Gangajaliya on 11/04/17.
//  Copyright © 2017 Sandeep Gangajaliya. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var menuType = 1
    
    var arrCartDetail = NSMutableArray()
    var strContactNumber = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        sleep(3)
        
        let leftMenu: LeftMenuVC = LeftMenuVC()
        leftMenu.cellIdentifier = "RightMenuCell"
        
        let rightMenu: RightMenuVC = RightMenuVC()
        rightMenu.cellIdentifier = "RightMenuCell"
        
        SlideNavigationController.sharedInstance().leftMenu = leftMenu
        SlideNavigationController.sharedInstance().rightMenu = rightMenu
        
        SlideNavigationController.sharedInstance().menuRevealAnimationDuration = 0.18
        
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().enable = true
        
        if UserDefaults.standard.value(forKey: "isFirstTime") != nil {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = (storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC)
            SlideNavigationController.sharedInstance().pushViewController(controller, animated: false)
        }
        
        if UserDefaults.standard.value(forKey: "CartDetail") != nil {
            
            let unarchivedObject = UserDefaults.standard.object(forKey: "CartDetail") as? NSData
            
            arrCartDetail = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject! as Data) as! NSMutableArray
            
            print("Cart Detail = ",arrCartDetail)
        }
        
        if UserDefaults.standard.value(forKey: "ContactNumber") != nil {
            
            let unarchivedObject = UserDefaults.standard.object(forKey: "ContactNumber") as? NSData
            strContactNumber = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject! as Data) as! String
            print("ContactNumber = ",strContactNumber)
        }
        
//        if UserDefaults.standard.value(forKey: "DeviceToken") != nil {
//            
//            let unarchivedObject = UserDefaults.standard.object(forKey: "DeviceToken") as? NSData
//            let deviceTokenString = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject! as Data) as! String
//            print("Device Token = ",deviceTokenString)
//            
//            self.registerDeviceTokenJson(strDeviceToken: deviceTokenString)
//        }
        
        self.contactJson()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)), name: Notification.Name.MessagingRegistrationTokenRefreshed, object: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.connectToFcm()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }

    // MARK: - Remote Notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
        Messaging.messaging().apnsToken = deviceToken
        
        self.connectToFcm()
        
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.prod)

        
        
//        self.registerDeviceTokenJson(strDeviceToken: deviceTokenString)
        
//        let archivedUser = NSKeyedArchiver.archivedData(withRootObject: deviceTokenString)
//        UserDefaults.standard.setValue(archivedUser, forKey: "DeviceToken")
//        UserDefaults.standard.synchronize()
        
//        let alert = UIAlertController(title: "Alert Title", message: deviceTokenString, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print(userInfo)
    }
    
    // MARK: - FCM
    
    public func application(received remoteMessage: MessagingRemoteMessage) {
        
        print("Remote Message = ", remoteMessage.appData)
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        
        if InstanceID.instanceID().token() != nil{
            
            let refreshedToken = InstanceID.instanceID().token()!
            print("InstanceID token1: \(refreshedToken)")
            
            if refreshedToken != "" {
                UserDefaults.standard.setValue(refreshedToken, forKey: "DeviceToken")
                UserDefaults.standard.synchronize()
            }
            
            connectToFcm()
        }
    }
    
    func connectToFcm(){
        
        Messaging.messaging().connect { (error) in
            
            if error != nil{
                print("Unable to connect to FCM. ", error!)
            }else{
                print("Connected to FCM.")
            }
            
            if InstanceID.instanceID().token() != nil{
                
                print("InstanceID token2: \(InstanceID.instanceID().token()!)")
                
                if InstanceID.instanceID().token()! != "" {
                    
                    UserDefaults.standard.setValue(InstanceID.instanceID().token()!, forKey: "DeviceToken")
                    UserDefaults.standard.synchronize()
                    
                    self.registerDeviceTokenJson(strDeviceToken: InstanceID.instanceID().token()!)
                    
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
//        self.application(UIApplication(), didReceiveRemoteNotification: userInfo)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Mawashi")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //MARK:- Webservice Call
    
    func contactJson()
    {
        let strUrl = "\(ProjectSharedObj.sharedInstance.baseUrl)/products/contact"
        print("\(strUrl)")
        
        let webserviceCall = WebserviceCall()
        webserviceCall.headerFieldsDict = ["Content-Type": "application/json"]
        
        webserviceCall.get(NSURL(string: strUrl) as URL!, parameters: nil as [NSObject: AnyObject]!, withSuccessHandler: { (response) -> Void in
            
            if response?.webserviceResponse != nil{
                
                if let dictData = response?.webserviceResponse as? NSDictionary{
                    
                    print("response = ",dictData)
                    
                    if dictData.value(forKey: "status") as! Bool == true{
                        
                        if dictData.value(forKey: "data") as? NSInteger != nil{
                            
                            Constants.appDelegate.strContactNumber = NSString(format: "0%d", dictData.value(forKey: "data") as! NSInteger) as String
                        }else{
                            Constants.appDelegate.strContactNumber = "0\(dictData.value(forKey: "data") as! String)"
                        }
                        
                        
                        let archivedUser = NSKeyedArchiver.archivedData(withRootObject: Constants.appDelegate.strContactNumber)
                        UserDefaults.standard.setValue(archivedUser, forKey: "ContactNumber")
                        UserDefaults.standard.synchronize()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadUserData"), object: nil, userInfo: nil)
                    }
                    
                    return
                }
            }
            
            ProjectUtility.displayTost(erroemessage: "قائمة المنتجات غير متوفرة")
        }) { (error) -> Void in
            
            print("error = ",error)
            ProjectUtility.loadingHide()
            ProjectUtility.displayTost(erroemessage: "نحن نواجه بعض المشاكل")
        }
    }
    
    func registerDeviceTokenJson(strDeviceToken: String)
    {
        let strUrl = "\(ProjectSharedObj.sharedInstance.baseUrl)/pushnoti/savedevicetoken"
        let dict = ["unique_id":UIDevice.current.identifierForVendor!.uuidString, "device_token":strDeviceToken, "type":"1"]
        print("\(strUrl) == \(dict)")
        
        let webserviceCall = WebserviceCall()
        webserviceCall.headerFieldsDict = ["Content-Type": "application/json"]
        
        webserviceCall.post(NSURL(string: strUrl) as URL!, parameters: dict as [NSObject: AnyObject]!, withSuccessHandler: { (response) -> Void in
            
            print("response = ",response?.webserviceResponse)
            
        }) { (error) -> Void in
            
            print("error = ",error!)
        }
    }
}

class ProjectSharedObj: NSObject
{
    static let sharedInstance = ProjectSharedObj()
    
    var baseUrl = "http://kio5.com/mavashi/api"
}
