//
//  WaitingView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/07.
//

import UIKit
import SnapKit

class WaitingView: BaseView {
    
    let infoView = EventInfoView()

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
        
        addSubview(infoView)
        addSubview(waitingLabel)
    }
    
    override func setConstraints() {
        infoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        waitingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoView.snp.bottom).offset(30)
            make.height.equalTo(30)
        }
    }

}
