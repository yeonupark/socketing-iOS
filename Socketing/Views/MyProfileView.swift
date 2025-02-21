//
//  MyProfileView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/21.
//

import UIKit

class MyProfileView: BaseView {

    let emailLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        view.text = "이메일"
        
        return view
    }()
    
    let emailTextField: UITextField = {
        let view = UITextField()
        view.isEnabled = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        view.rightViewMode = .always
    
        view.text = "sample@jungle.com"
        
        return view
    }()
    
    let nicknameLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        view.text = "닉네임"
        
        return view
    }()
    
    let nicknameTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        view.rightViewMode = .always
        
        return view
    }()
    
    let submitButton = {
        let view = UIButton()
        
        view.layer.cornerRadius = 8
        
        view.titleLabel?.textColor = .black
        view.titleLabel?.font = .boldSystemFont(ofSize: 16)
        view.setTitle("닉네임 변경하기", for: .normal)
        view.backgroundColor = .systemPink
        
        return view
    }()
    
    override func configure() {
        super.configure()
        for view in [emailLabel, emailTextField, nicknameLabel, nicknameTextField, submitButton] {
            addSubview(view)
        }
    }
    
    override func setConstraints() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(80)
            make.leading.equalToSuperview().inset(45)
            make.height.equalTo(40)
            make.width.equalTo(50)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel)
            make.leading.equalTo(emailLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(45)
            make.height.equalTo(40)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(45)
            make.height.equalTo(40)
            make.width.equalTo(50)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(45)
            make.height.equalTo(40)
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(120)
            make.centerX.equalToSuperview()
        }
    }
}
