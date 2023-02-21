//
//  ViewController.swift
//  BetaBrowser
//
//  Created by yangjian on 2023/2/14.
//

import UIKit

class ViewController: UITabBarController {
    
    private lazy var launchVC: LaunchVC = {
        LaunchVC()
    }()
    
    private lazy var homeVC: HomeVC = {
        HomeVC()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        viewControllers = [launchVC, homeVC]
        
        FirebaseUtil.log(property: .local)
        FirebaseUtil.log(event: .open)
        FirebaseUtil.log(event: .openCold)
    }
    
    func launching() {
        selectedIndex = 0
        launchVC.launching()
    }
    
    func launched() {
        selectedIndex = 1
    }

}

