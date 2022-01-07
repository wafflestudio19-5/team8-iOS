//
//  MainTabBarController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/11/27.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeNavigationController = UINavigationController(rootViewController: HomeViewController())
        let chatNavigationController = UINavigationController(rootViewController: ChatRoomListViewController())
        let mypageNavigationController = UINavigationController(rootViewController: MypageViewController())
        
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        chatNavigationController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        mypageNavigationController.tabBarItem = UITabBarItem(title: "My Waffle", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.viewControllers = [homeNavigationController, chatNavigationController, mypageNavigationController]
        
        // Do any additional setup after loading the view.
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
