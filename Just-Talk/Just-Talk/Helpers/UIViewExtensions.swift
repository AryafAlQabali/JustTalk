//
//  UIViewExtensions.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 01/06/1443 AH.
//

import UIKit


extension UIView {
    
   @IBInspectable var cornerRadius: CGFloat {
         get { return cornerRadius }
       set {
           self.layer.cornerRadius = newValue
       }
    }
}
