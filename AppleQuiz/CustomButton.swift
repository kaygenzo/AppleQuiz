//
//  CustomButton.swift
//  AppleQuiz
//
//  Created by Karim Yarboua on 06/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    func setup(string: String) {
        setLayer()
        setTitle(string, for: UIControl.State.normal)
        setTitleColor(UIColor.darkGray, for: .normal)
    }

}
