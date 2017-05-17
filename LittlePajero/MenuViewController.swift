//
//  MenuViewController.swift
//  LittlePajero
//
//  Created by ivyxuan on 2017/5/8.
//  Copyright © 2017年 ivyxuan. All rights reserved.
//

import UIKit
import SideMenu

class MenuViewController: UIViewController {
    
    var mainVC: MainViewController?

    @IBAction func downloadStart(_ sender: SideMenuButton) {
        mainVC?.mode = .downloading
        self.dismiss(animated: true, completion: nil)
    }
    
}
