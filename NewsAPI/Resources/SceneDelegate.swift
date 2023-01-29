//
//  SceneDelegate.swift
//  NewsAPI
//
//  Created by sss on 29.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        /// Create and settings tabBarController
        let tabBarController = UITabBarController()
        
        let topNewsVC = ModuleBuilder.createTopNewVC()
        topNewsVC.title = "Top news"
        
        let searchNewsVC = ModuleBuilder.createSearchNewsVC()
        searchNewsVC.title = "Search"
        
        let firstNavigationController = UINavigationController(rootViewController: topNewsVC)
        let secondNavigationController = UINavigationController(rootViewController: searchNewsVC)
        
        let arrayNavControllers = [firstNavigationController, secondNavigationController]
        tabBarController.setViewControllers(arrayNavControllers, animated: true)
        
        for controller in arrayNavControllers {
            controller.navigationBar.prefersLargeTitles = true 
        }
        
        topNewsVC.tabBarItem = UITabBarItem(title: "Top news", image: UIImage(systemName: "doc.plaintext"), tag: 0)
        searchNewsVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .clear
    }
}

