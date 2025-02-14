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
        view.font = .boldSystemFont(ofSize: 18)
        view.textAlignment = .center
        view.textColor = .white
        view.text = "현재 입장 대기 중입니다.\n 좌석 선택을 위해 준비해주세요 !"
        
        return view
    }()
    
    private let enterLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        view.textColor = .lightGray
        view.text = "대기열 진입"
        
        return view
    }()
    
    private let exitLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        view.textColor = .lightGray
        view.text = "입장"
        
        return view
    }()
    
    let progressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.trackTintColor = .lightGray
        view.tintColor = .systemPink
        view.progress = 0.0
        
        return view
    }()
    
    let positionLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 20)
        view.textAlignment = .center
        view.textColor = .white
        view.text = "현재 순서: "
        
        return view
    }()
    
    let queueNumLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.textAlignment = .center
        view.textColor = .systemPink
        view.text = "10명이 뒤에 대기중입니다. "
        
        return view
    }()
    
    override func configure() {
        backgroundColor = .black
        
        addSubview(infoView)
        addSubview(waitingLabel)
        addSubview(progressView)
        addSubview(enterLabel)
        addSubview(exitLabel)
        addSubview(positionLabel)
        addSubview(queueNumLabel)
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
        progressView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(waitingLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        enterLabel.snp.makeConstraints { make in
            make.leading.equalTo(progressView.snp.leading).inset(10)
            make.top.equalTo(waitingLabel.snp.bottom).offset(20)
        }
        exitLabel.snp.makeConstraints { make in
            make.trailing.equalTo(progressView.snp.trailing).inset(10)
            make.top.equalTo(waitingLabel.snp.bottom).offset(20)
        }
        positionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(progressView.snp.bottom).offset(20)
        }
        queueNumLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(positionLabel.snp.bottom).offset(20)
        }
    }

}
