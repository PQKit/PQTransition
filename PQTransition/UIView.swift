//
//  UIView.swift
//  PQTransition
//
//  Created by 盘国权 on 2019/6/10.
//  Copyright © 2019 pgq. All rights reserved.
//

import Foundation


extension UIView {
    func cut(size: CGSize, cutFrame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
         UIGraphicsBeginImageContextWithOptions(cutFrame.size, false, UIScreen.main.scale)
        
        image?.draw(at: CGPoint(x: -cutFrame.origin.x, y: -cutFrame.origin.y))
        let image2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image2 
    }
}
