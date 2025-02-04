//
//  PaymentView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/30.
//

import UIKit

class PaymentView: BaseView {

    let infoView = EventInfoView()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
        
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let seatsInfoLabel = {
        let view = UILabel()
        view.text = "🎫  좌석 정보"
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .darkGray
        
        return view
    }()
    
    let seatsInfoView = {
        let view = UILabel()
        view.text = "O구역 O열 O번  100000원"
        view.font = .boldSystemFont(ofSize: 16)
        view.numberOfLines = 0
        
        return view
    }()
    
    private let totalPriceLabel = {
        let view = UILabel()
        view.text = "💸  최종 결제 금액"
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .darkGray
        
        return view
    }()
    
    let totalPriceView = {
        let view = UILabel()
        view.text = "300000원"
        view.font = .boldSystemFont(ofSize: 16)
        
        return view
    }()
    
    let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.tintColor = .systemPink
        
        return button
    }()
        
    private let checkboxLabel: UILabel = {
        let label = UILabel()
        label.text = "구매조건 확인 및 결제 진행에 동의"
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    let payButton = {
        let view = UIButton()
        view.setTitle("결제하기", for: .normal)
        view.backgroundColor = .systemPink
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        for view in [infoView, containerView, seatsInfoLabel, seatsInfoView, totalPriceLabel, totalPriceView, checkboxButton, checkboxLabel, payButton] {
            addSubview(view)
        }
        
        containerView.addSubview(timerLabel)
    }
    
    override func setConstraints() {
        
        infoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.trailing.equalToSuperview().inset(32)
            make.height.equalTo(32)
            make.width.equalTo(120)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let views  = [infoView, seatsInfoLabel, seatsInfoView, totalPriceLabel, totalPriceView]
        
        for (index, view) in views.enumerated() {
            
            if index == 0 {
                continue
            }
            
            view.snp.makeConstraints { make in
                make.top.equalTo(views[index-1].snp.bottom).offset(16)
                make.leading.equalToSuperview().inset(16)
            }
        }
        
        checkboxButton.snp.makeConstraints { make in
            make.top.equalTo(totalPriceView.snp.bottom).offset(24)
            make.leading.equalTo(totalPriceView)
            make.size.equalTo(20)
        }
        
        checkboxLabel.snp.makeConstraints { make in
            make.top.equalTo(checkboxButton)
            make.left.equalTo(checkboxButton.snp.right).offset(2)
            make.height.equalTo(20)
        }
        
        payButton.snp.makeConstraints { make in
            make.top.equalTo(checkboxLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
    }

}
