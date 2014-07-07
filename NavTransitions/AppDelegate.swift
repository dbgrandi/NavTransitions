//
//  AppDelegate.swift
//  NavTransitions
//
//  Created by David Grandinetti on 6/14/14.
//  Copyright (c) 2014 David Grandinetti. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var navController: DBGNavigationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        self.navController = DBGNavigationController()
        self.navController!.viewControllers = [DBGViewController()]

        self.window!.rootViewController = navController

        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
}

