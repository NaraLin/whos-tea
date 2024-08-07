//
//  MainTabBarController.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/6/22.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tabbar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(named: "mainColor")
        //tab點擊樣式
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        //tab未點擊樣式
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .white
        //tab未點擊文字顏色
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor : UIColor.lightGray
        ]
        //tab點擊文字顏色
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor : UIColor.white
        ]
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
        //menu controller tabbar item setting
        let menuVC = MenuViewController()
        
        menuVC.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(systemName: "menucard"), selectedImage: UIImage(systemName: "menucard.fill"))
        
        //menu controller navi bar title & appearance setting
        menuVC.title = "Menu"
        let menuNavC = UINavigationController(rootViewController: menuVC)
        
        //navigationbar appearance
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "mainColor")
        appearance.titleTextAttributes = [
            .font: UIFont(name: "NatsuzemiMaruGothic-Black", size: 24)!,
            .foregroundColor: UIColor.white
        ]
        
        menuNavC.navigationBar.standardAppearance = appearance
        menuNavC.navigationBar.scrollEdgeAppearance = appearance
        
        //profile controller tabbar item setting
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        
        //profile controller navi bar title & appearance setting
        profileVC.title = "Profile"
        let profileNavC = UINavigationController(rootViewController: profileVC)
        
        profileNavC.navigationBar.standardAppearance = appearance
        profileNavC.navigationBar.scrollEdgeAppearance = appearance
        
        //cart controller
        let cartVC = CartViewController()
        cartVC.tabBarItem = UITabBarItem(title: "購物車", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))
        
        cartVC.title = "購物車"
        let cartNavC = UINavigationController(rootViewController: cartVC)
        cartNavC.navigationBar.standardAppearance = appearance
        cartNavC.navigationBar.scrollEdgeAppearance = appearance
  
        
        //add navi controller
        viewControllers = [menuNavC, cartNavC, profileNavC]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
