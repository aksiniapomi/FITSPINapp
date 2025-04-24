//
//  FITSPIN_appApp.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 04/04/2025.
//

import SwiftUI
import FirebaseCore

//delegate that bootstraps Firebase
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
    return true
  }
}

@main
struct FITSPIN_appApp: App {
    //bootstrap Firebase
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    //Create one at State object for the whole app
  @StateObject private var authVM = AuthViewModel()

  var body: some Scene {
    WindowGroup {
      Group {
        if authVM.user == nil {
            NavigationStack {
                SignInView()
            }
        }
 
        else {
          BottomTabView()
        }
      }
        //inject the AuthViewModel into the environment
      .environmentObject(authVM)
      .preferredColorScheme(.dark)
    }
  }
}

