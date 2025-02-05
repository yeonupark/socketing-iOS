//
//  RegisterView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/05.
//

import UIKit

class RegisterView: BaseView {

    let idField = {
        let view = UITextField()
        view.applyDefaultStyle()
        view.placeholder = "닉네임을 입력하세요"
        
        return view
    }()
    
    let pwField = {
        let view = UITextField()
        view.applyDefaultStyle()
        view.isSecureTextEntry = true
        view.placeholder = "비밀번호를 입력하세요"
        
        return view
    }()
    
    let joinButton = {
        let view = UIButton()
        view.setTitle("JOIN", for: .normal)
        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        
        view.titleLabel?.textColor = .white
        view.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        addSubview(idField)
        addSubview(pwField)
        addSubview(joinButton)
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
        joinButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pwField.snp.bottom).offset(12)
            make.height.equalTo(28)
            make.width.equalTo(70)
        }
    }

}
