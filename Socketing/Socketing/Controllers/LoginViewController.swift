//
//  LoginViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/03.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {

    let mainView = LoginView()
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view.self = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
    }
    
    func bind() {
        
        // TextField -> ViewModel
        mainView.idField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        mainView.pwField.rx.text.orEmpty
            .bind(to: viewModel.pw)
            .disposed(by: disposeBag)
        
        // ViewModel -> Button State
        viewModel.loginButtonEnabled
            .drive(mainView.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.loginButtonColor
            .drive(mainView.loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        // Login Button Tap -> ViewModel
        mainView.loginButton.rx.tap
            .bind { _ in
                print(self.viewModel.email.value)
            }
            .disposed(by: disposeBag)
    }
}
