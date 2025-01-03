//
//  BaseView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/03.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .white
    }
    
    func setConstraints() {
        
    }
    
}
