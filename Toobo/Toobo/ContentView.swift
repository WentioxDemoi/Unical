//
//  ContentView.swift
//  Toobo
//
//  Created by Rémi Desbordes on 28/03/2024.
//

import SwiftUI
import UIKit



struct ContentView: View {
    var body: some View {
        
        WelcomePage()
            //.onOpenURL { url in
                      //GIDSignIn.sharedInstance.handle(url)
                    //}
    }
}




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
      [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

#Preview {
    ContentView()
}
