//
//  AppDelegate.swift
//  OrbifoListProject
//
//  Created by Ayse Cengiz on 4.12.2020.
//

import UIKit
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            
            print("aaReceived Notification: \(notification!.payload.notificationID)")
            
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload = result!.notification.payload
            
            
            
            if payload.title.elementsEqual("qr_code")
            {
               
                
                let aViewController = QRCodeScannerViewController()
                UIApplication.shared.keyWindow?.rootViewController?.present(aViewController, animated: true, completion:nil)
                
            }
        }
        
        
        //Remove this method to stop OneSignal Debugging
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        
        // Replace 'YOUR_ONESIGNAL_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "d3c06656-e659-4b91-ac60-7daaf3d87925",
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
        
        
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // promptForPushNotifications will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        //END OneSignal initializataion code
        
        
        
        
        return true
    }
    
    
}

