//
//  RegisterViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/05.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class RegisterViewModel {
    
    let email = BehaviorRelay(value: "")
    let pw = BehaviorRelay(value: "")
    
    let joinButtonEnabled: Driver<Bool>
    let joinButtonColor: Driver<UIColor>
    
    
    init() {
        
        joinButtonEnabled = Observable
            .combineLatest(email, pw) { email, password in
                return !email.isEmpty && password.count > 5
            }
            .asDriver(onErrorJustReturn: false)
        
        joinButtonColor = joinButtonEnabled
            .map { isEnabled in
                return isEnabled ? UIColor.systemPink : UIColor.lightGray
            }
            .asDriver(onErrorJustReturn: UIColor.lightGray)
    }
    
    func requestJoin(completionHandler: @escaping (LoginData?) -> Void) {
        let email = email.value+"@jungle.com"
        let joinBody = JoinRequest(email: email, password: pw.value, role: "user")
        
        APIClient.shared.postRequest(
            urlString: APIEndpoint.authentication.url + "register",
            requestBody: joinBody,
            responseType: JoinResponse.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    LoginViewModel.shared.requestLogin(email: email, pw: self.pw.value) { data in
                        if let data {
                            completionHandler(data)
                        } else {
                            completionHandler(nil)
                        }
                    }
                case .failure(let error):
                    print("회원가입 실패: \(error.localizedDescription)")
                    completionHandler(nil)
                }
            }
        }
    }
    
}
