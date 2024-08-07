//
//  Extension.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/8/1.
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

//擴展view畫圓角
extension UIView {
    
    func roundCorners(coners: UIRectCorner, radius: CGFloat){
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: coners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
    }
}
