//
//  WaitingView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/07.
//

import UIKit
import SnapKit

class WaitingView: BaseView {

    let waitingLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 24)
        view.textAlignment = .center
        view.textColor = .white
        view.text = "현재 입장 대기 중입니다."
        
        return view
    }()
    
    override func configure() {
        backgroundColor = .black
        addSubview(waitingLabel)
    }
    
    override func setConstraints() {
        waitingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).inset(80)
            make.height.equalTo(30)
        }
    }

}
