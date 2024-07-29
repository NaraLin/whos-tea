//
//  AppDelegate.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/6/19.
//

import UIKit
import FirebaseCore
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window:UIWindow?
    
    //處理從其他應用程式打開你的應用程式時傳遞過來的 URL
    //process: 收到一個 URL，可以從 URL 物件中解析出需要的資訊，並根據這些資訊來決定如何處理這個請求
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 處理從 Google 登入返回的 URL
        return GIDSignIn.sharedInstance.handle(url)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        AuthManager.shared.checkAuthStatus { [weak self] isAuth in
            
            guard let strongSelf = self else { return }
            
            if isAuth {
                //已登入
                let tabBarController = MainTabBarController()
                strongSelf.window?.rootViewController = UINavigationController(rootViewController: tabBarController)
            } else {
                //未登入or未認證
                let vc = LoginViewController()
                strongSelf.window?.rootViewController = UINavigationController(rootViewController: vc)
            }
            strongSelf.window?.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

