//
//  MyProfileViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/21.
//

import UIKit
import RxSwift
import Toast

class MyProfileViewController: BaseViewController {

    let mainView = MyProfileView()
    let viewModel = MyProfileViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        mainView.emailTextField.text = UserDefaults.standard.string(forKey: "email")
        mainView.nicknameTextField.text = UserDefaults.standard.string(forKey: "nickname")
        
        bind()
    }
    
    private func bind() {
        
        mainView.nicknameTextField.rx.text.orEmpty
            .bind(to: viewModel.nickname)
            .disposed(by: disposeBag)
        
        viewModel.submitButtonEnabled
            .drive(mainView.submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.submitButtonColor
            .drive(mainView.submitButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        mainView.submitButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.hideKeyboard()
                self.viewModel.updateNickname { result in
                    DispatchQueue.main.async {
                        if result {
                            var style = ToastStyle()
                            style.backgroundColor = .black
                            self.view.makeToast("닉네임이 변경되었습니다!", duration: 2.0, position: .top, style: style)
                        } else {
                            var style = ToastStyle()
                            style.backgroundColor = .systemRed
                            self.view.makeToast("이미 사용중인 닉네임입니다.", duration: 2.0, position: .top, style: style)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    

}
