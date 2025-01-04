//
//  LoginViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/03.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel {
    
    let email = BehaviorRelay(value: "")
    let pw = BehaviorRelay(value: "")

    let loginButtonEnabled: Driver<Bool>
    let loginButtonColor: Driver<UIColor>
    
    let disposeBag = DisposeBag()
    
    init() {
        
        loginButtonEnabled = Observable
            .combineLatest(email, pw) { email, password in
                return !email.isEmpty && !password.isEmpty
            }
            .asDriver(onErrorJustReturn: false)
        
        loginButtonColor = loginButtonEnabled
            .map { isEnabled in
                return isEnabled ? UIColor.systemBlue : UIColor.lightGray
            }
            .asDriver(onErrorJustReturn: UIColor.lightGray)
    }
    
    
}
