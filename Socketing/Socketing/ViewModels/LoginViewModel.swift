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
    
//    let disposeBag = DisposeBag()
    
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
    
    func requestLogin(completionHandler: @escaping (LoginData?) -> Void) {
        let loginBody = LoginRequest(email: email.value+"@jungle.com", password: pw.value)
        
        APIClient.shared.postRequest(
            urlString: APIEndpoint.authentication.url + "login",
            requestBody: loginBody,
            responseType: LoginResponse.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.data?.accessToken, forKey: "authToken")
                    completionHandler(response.data)
                case .failure(let error):
                    print("로그인 실패: \(error.localizedDescription)")
                    completionHandler(nil)
                }
            }
        }
    }
}
