//
//  AppDelegate.swift
//  TodayRecipe
//
//  Created by Seoyoung on 23/05/2019.
//  Copyright © 2019 Seoyoung. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import KakaoOpenSDK
import NaverThirdPartyLogin
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // FB
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        // 네이버 앱이 설치되어 있으면 네이버 앱을 통해서 인증 진행
        instance?.isInAppOauthEnable = true
        // 네이버 앱이 설치되어 있지 않다면 사파리를 통해서 인증 진행. 둘다 활성화 되어 있다면, 네이버 앱 유무를 먼저 체크 한다.
        instance?.isNaverAppOauthEnable = true
        // 세로모드에서만 인증화면 진행
        instance?.isOnlyPortraitSupportedInIphone()
        
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
        
        // Google
        GIDSignIn.sharedInstance()?.clientID = "634057378178-71t64en5aaglh6l9d0bq4sqpb9vvg9sj.apps.googleusercontent.com"
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
        KOSession.handleDidBecomeActive()
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        
        // FaceBook
        let handled = ApplicationDelegate.shared.application(application, open: url, options: options)
        return handled
        
        // Kakao
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        
        // Google
        guard let scheme = url.scheme else { return true }
        if #available(iOS 9.0, *) {
            if scheme.contains("com.googleusercontent.apps") {
                return GIDSignIn.sharedInstance().handle(url as URL?,
                                                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                         annotation: options[UIApplication.OpenURLOptionsKey.annotation])
            }
        }
    }
    
    //kakao login
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        
        guard let scheme = url.scheme else { return true }
        if scheme.contains("com.googleusercontent.apps") {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return true
    }
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodayRecipe")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

