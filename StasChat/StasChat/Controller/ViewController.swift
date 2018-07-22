//
//  ViewController.swift
//  StasChat
//
//  Created by Stanislav Cherkasov on 14.07.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    translucentNavBar()
    
    // Make an arrow back button item white color
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done,
                                                       target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    //*******************************************
  }
  
  func translucentNavBar() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
  }
}
