//
//  UITextField+Extensions.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/05.
//

import UIKit

extension UITextField {
    func applyDefaultStyle() {
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.autocapitalizationType = .none
        self.textContentType = .none
        self.borderStyle = .roundedRect
    }
}
