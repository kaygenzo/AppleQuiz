//
//  CustomLabel.swift
//  AppleQuiz
//
//  Created by Karim Yarboua on 06/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import UIKit

class CustomLabel : UILabel {
    
    let FONT = UIFont.systemFont(ofSize: 20)
    let COLOR = UIColor.white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        textColor = COLOR
        numberOfLines = 0
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        font = FONT
        updateText(nil, nil)
    }
    
    func updateText(_ availableTime: Int?, _ score: Int?) {
        let text = "Is it a delicious Apple ?"
        if availableTime == nil && score == nil {
            self.text = text
        } else {
            let attributes = NSMutableAttributedString(string: text + "\n", attributes: [
                NSAttributedString.Key.foregroundColor: COLOR,
                NSAttributedString.Key.font: FONT
            ])
            attributes.append(NSAttributedString(string: "Available time: \(availableTime!) - Score: \(score!)", attributes: [
                .foregroundColor: UIColor.red,
                .font: UIFont.boldSystemFont(ofSize: 24)
            ]))
            attributedText = attributes
        }
    }
}
