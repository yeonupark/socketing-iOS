//
//  RegisterViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/05.
//

import UIKit
import RxSwift

class RegisterViewController: BaseViewController {

    let mainView = RegisterView()
    let viewModel = RegisterViewModel()
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
        navigationItem.title = "회원가입"
    }
    
    func bind() {
        
        mainView.idField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        mainView.pwField.rx.text.orEmpty
            .bind(to: viewModel.pw)
            .disposed(by: disposeBag)
        
        viewModel.joinButtonEnabled
            .drive(mainView.joinButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.joinButtonColor
            .drive(mainView.joinButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        mainView.joinButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.hideKeyboard()
                self.viewModel.requestJoin { data in
                    if let data {
                        self.handleLoginSuccess(data: data)
                    } else {
                        self.handleJoinFailure()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func handleLoginSuccess(data: LoginData) {
        let vc = MainViewController()
        vc.viewModel.logined = true
        self.navigationController?.setViewControllers([vc], animated: true)
    }

    private func handleJoinFailure() {
        let alert = UIAlertController(title: "회원가입 실패", message: "이미 등록된 닉네임입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
        
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    

}
