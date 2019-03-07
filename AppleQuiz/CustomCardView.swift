//
//  CustomCardView.swift
//  AppleQuiz
//
//  Created by Karim Yarboua on 06/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import UIKit

class CustomCardView: UIView {
    
    var customMask = UIView()
    var imageView: UIImageView?
    var response = Response.maybe
    var logo: Logo? {
        didSet {
            guard let l = logo else { return }
            response = .maybe
            setMaskColor(response)
            if imageView == nil {
                imageView = UIImageView(frame: bounds)
                imageView?.contentMode = .scaleAspectFit
                addSubview(imageView ?? UIImageView())
                sendSubviewToBack(imageView ?? UIImageView())
            }
            imageView?.image = l.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func addMask() {
        customMask = UIView(frame: bounds)
        customMask.backgroundColor = .clear
        customMask.alpha = 0.25
        customMask.layer.cornerRadius = 10
        addSubview(customMask)
    }
    
    func setup() {
        setLayer()
        isUserInteractionEnabled = true
        addMask()
    }
    
    func setMaskColor(_ response: Response) {
        switch response {
        case .yes:
            customMask.backgroundColor = .green
        case .no:
            customMask.backgroundColor = .red
        case .maybe:
            customMask.backgroundColor = .clear
        }
        
        self.response = response
    }
}
