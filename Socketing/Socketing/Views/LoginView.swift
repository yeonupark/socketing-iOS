//
//  LoginView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/03.
//

import UIKit

class LoginView: BaseView {
    
    
    let idField = {
        let view = UITextField()
        view.applyDefaultStyle()
        view.placeholder = "enter your email"
        
        return view
    }()
    
    let pwField = {
        let view = UITextField()
        view.applyDefaultStyle()
        view.isSecureTextEntry = true
        view.placeholder = "enter your password"
        
        return view
    }()
    
    let loginButton = {
        let view = UIButton()
        view.setTitle("LOGIN", for: .normal)
        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        
        view.titleLabel?.textColor = .white
        view.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        return view
    }()
    
    let signUpLabel = {
        let view = UILabel()
        view.text = "not our member yet?"
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 14)
        
        return view
    }()
    
    let signUpButton = {
        let view = UIButton()
        view.setTitle("sign up", for: .normal)
        
        view.setTitleColor(.systemBlue, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        addSubview(idField)
        addSubview(pwField)
        addSubview(loginButton)
        addSubview(signUpLabel)
        addSubview(signUpButton)
    }
    
    override func setConstraints() {
        
        idField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        pwField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(idField.snp.bottom).offset(4)
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pwField.snp.bottom).offset(12)
            make.height.equalTo(28)
            make.width.equalTo(70)
        }
        signUpLabel.snp.makeConstraints { make in
            make.leading.equalTo(pwField)
            make.top.equalTo(loginButton.snp.bottom).offset(12)
            make.height.equalTo(20)
        }
        signUpButton.snp.makeConstraints { make in
            make.leading.equalTo(signUpLabel.snp.trailing).offset(8)
            make.verticalEdges.equalTo(signUpLabel)
        }
    }
}
