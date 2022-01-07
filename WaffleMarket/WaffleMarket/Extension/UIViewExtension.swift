//
//  UIViewExtension.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/21.
//

import Foundation
import UIKit

extension UIView{
    func dropShadow(offset: CGFloat = 3, radius: CGFloat = 3){
        
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: 0, height: offset)
        
        self.layer.shadowColor = UIColor.gray.cgColor
    }
}
