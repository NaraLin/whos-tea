//
//  NumberpadReturn.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/6/28.
//

import Foundation
import UIKit

extension UITextField {
    
    func numberpadReturn() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donekey))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneButton], animated: true)
        self.inputAccessoryView = toolbar
    }
    
    @objc func donekey(){
        
        self.resignFirstResponder()
        
    }
}


