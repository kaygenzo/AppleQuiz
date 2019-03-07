//
//  ExtensionView.swift
//  AppleQuiz
//
//  Created by Karim Yarboua on 06/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import UIKit

extension UIView {
    func setLayer() {
        backgroundColor = .white
        layer.cornerRadius = 10
        //layer.borderWidth = 2
        //layer.borderColor = UIColor.red.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.75
        layer.shadowOffset = CGSize(width: 3, height: 3)
    }
}
