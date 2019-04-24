//
//  AppDelegate.swift
//  BookMe
//
//  Created by mac on 20.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        realmMigration(version: 0)
        createEmptyHistory()
        freeKeyboardLag()
        remoteNotificationRequest()
        navigationBarSettings()
        NotificationCenter.default.addObserver(self, selector: #selector(self.applyRootController), name: .rootController, object: nil)
        UIApplication.shared.statusBarStyle = .default
        applyRootController()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var tokenString = ""
        for i in 0..<deviceToken.count {
            tokenString = tokenString + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        Session.deviceToken = tokenString
    }
    
    func navigationBarSettings() {
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navigation_bar"), for: .default)
        UITabBar.appearance().tintColor = Session.tintColor
    }
    
    func remoteNotificationRequest() {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applyRootController() {
        Session.userLoggedIn = true
        let storyboard : UIStoryboard = UIStoryboard(name: Session.userLoggedIn == false ? "Auth" : "Main", bundle: nil)
        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "root")
    }
    
    func freeKeyboardLag() {
        let textField = UITextField()
        self.window?.addSubview(textField)
        textField.becomeFirstResponder()
        textField.resignFirstResponder()
        textField.removeFromSuperview()
    }
    
    func createEmptyHistory() {
        let realm = try! Realm()
        if realm.objects(History.self).first == nil {
            let history = History()
            try! realm.write() {
                realm.add(history, update: true)
            }
        }
    }
    
    func realmMigration(version: UInt64) {
        let config = Realm.Configuration(
            schemaVersion: version,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < version {
                    
                }
        })
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
    
    
    

}

