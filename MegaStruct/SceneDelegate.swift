//
//  SceneDelegate.swift
//  MegaStruct
//
//  Created by 김정호 on 4/23/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let myPageStoryboard = UIStoryboard(name: "MypageView", bundle: nil)
        let myPageViewController = myPageStoryboard.instantiateViewController(withIdentifier: "MyPageController") as! MyPageController
        
        let firstVC = UINavigationController(rootViewController: SearchViewController())
        let secondVC = UINavigationController(rootViewController: MainViewController())
        let thirdVC = UINavigationController(rootViewController: myPageViewController)
                                             
        let tabbarController = UITabBarController()
        tabbarController.setViewControllers([firstVC,secondVC,thirdVC], animated: true)
                                             
        if let items = tabbarController.tabBar.items {
            items[0].image = .search
            items[1].image = .category
            items[2].image = .profile
        }
        tabbarController.tabBar.items?.forEach { $0.title = nil }
        tabbarController.tabBar.items?.forEach {
            $0.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0)
        }
                                             
        tabbarController.tabBar.backgroundColor = .megaRed //.white
        tabbarController.tabBar.tintColor = .white
        tabbarController.tabBar.unselectedItemTintColor = .black
        tabbarController.tabBar.layer.cornerRadius = 34
        tabbarController.tabBar.itemPositioning = .centered
        tabbarController.selectedIndex = 1
                                             
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

