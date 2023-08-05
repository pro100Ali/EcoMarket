//
//  MainTabBarController.swift
//  EcoMarket
//
//  Created by Али  on 04.08.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: MainViewController())
        let vc2 = MainViewController()
        let vc3 = MainViewController()
        let vc4 = MainViewController()
        
        vc1.tabBarItem.image = UIImage(named: "home")
        vc2.tabBarItem.image = UIImage(named: "bucket")
        vc3.tabBarItem.image = UIImage(named: "clock")
        vc4.tabBarItem.image = UIImage(named: "info")

        vc1.title = "Главная"
        vc2.title = "Корзина"
        vc3.title = "История"
        vc4.title = "Инфо"
        

        tabBar.tintColor = .green
        
        setViewControllers([vc1,vc2,vc3, vc4], animated: true)

    }


}
