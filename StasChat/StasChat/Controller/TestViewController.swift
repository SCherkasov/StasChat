//
//  TestViewController.swift
//  StasChat
//
//  Created by Stanislav Cherkasov on 15.07.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textViewMy: UITextField!
    
    
    @IBOutlet var scrollViewMy: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
textViewMy.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollViewMy.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollViewMy.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

}
