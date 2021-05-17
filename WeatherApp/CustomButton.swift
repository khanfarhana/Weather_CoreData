//
//  CustomButton.swift
//  CovidAPI
//
//  Created by Farhana Khan on 15/05/21.
//
import Foundation

import UIKit

@IBDesignable class CustomButton: UIButton {
    
    @IBInspectable var borderColor : UIColor = UIColor.red{
        didSet{
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 1.0{
        didSet{
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var radius : CGFloat = 2.0{
        didSet{
            self.layer.cornerRadius = self.radius
        }
    }
}
