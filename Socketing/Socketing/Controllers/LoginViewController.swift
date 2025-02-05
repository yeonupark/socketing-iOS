//
//  LoginViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/03.
//

import UIKit
import RxSwift
import Toast

class LoginViewController: BaseViewController {

    let mainView = LoginView()
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.mainView.idField.becomeFirstResponder()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        bind()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.logouted {
            self.view.makeToast("로그아웃 되었습니다. 다시 로그인 해주세요", duration: 2.0, position: .top)
        }
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
        
        // Login Button Tap
        mainView.loginButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.hideKeyboard()
                self.viewModel.requestLogin(email: viewModel.email.value+"@jungle.com", pw: viewModel.pw.value) { data in
                    if let data {
                        self.handleLoginSuccess(data: data)
                    } else {
                        self.handleLoginFailure()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        mainView.signUpButton.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func registerButtonClicked() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleLoginSuccess(data: LoginData) {
        let vc = MainViewController()
        vc.viewModel.logined = true
        self.navigationController?.setViewControllers([vc], animated: true)
    }

    private func handleLoginFailure() {
        let alert = UIAlertController(title: "로그인 실패", message: "아이디와 비밀번호를 확인하세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
        
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

}
