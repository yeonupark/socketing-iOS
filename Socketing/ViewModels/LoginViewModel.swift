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
    
    static let shared = LoginViewModel()
    
    let email = BehaviorRelay(value: "")
    let pw = BehaviorRelay(value: "")
    
    var firstLogined = false
    var logouted = false

    let loginButtonEnabled: Driver<Bool>
    let loginButtonColor: Driver<UIColor>
    
//    let disposeBag = DisposeBag()
    
    init() {
        
        loginButtonEnabled = Observable
            .combineLatest(email, pw) { email, password in
                return !email.isEmpty && password.count > 5
            }
            .asDriver(onErrorJustReturn: false)
        
        loginButtonColor = loginButtonEnabled
            .map { isEnabled in
                return isEnabled ? UIColor.systemPink : UIColor.lightGray
            }
            .asDriver(onErrorJustReturn: UIColor.lightGray)
    }
    
    func requestLogin(email: String, pw: String, completionHandler: @escaping (LoginData?) -> Void) {
        let loginBody = LoginRequest(email: email, password: pw)
        
        APIClient.shared.postRequest(
            urlString: APIEndpoint.authentication.url + "login",
            requestBody: loginBody,
            responseType: LoginResponse.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.data?.accessToken, forKey: "authToken")
                    self.getUserInfo(email: email)
                    completionHandler(response.data)
                case .failure(let error):
                    print("로그인 실패: \(error.localizedDescription)")
                    completionHandler(nil)
                }
            }
        }
    }
    
    func getUserInfo(email: String) {
        
        APIClient.shared.getRequest(urlString: APIEndpoint.users.url + "email/" + email, responseType: UserResponse.self) { result in
            
            switch result {
            case .success(let response):
                if let data = response.data {
                    UserDefaults.standard.setValue(data.id, forKey: "userId")
                    UserDefaults.standard.setValue(data.email, forKey: "email")
                    UserDefaults.standard.setValue(data.nickname, forKey: "nickname")
                }
            case .failure(let error):
                print("get events api error: ", error.localizedDescription)
            }
        }
    }
}
