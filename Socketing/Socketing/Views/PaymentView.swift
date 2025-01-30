//
//  PaymentView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/30.
//

import UIKit

class PaymentView: BaseView {

    let infoView = EventInfoView()
    
    let seatsInfoLabel = {
        let view = UILabel()
        view.text = "좌석 정보"
        view.font = .boldSystemFont(ofSize: 18)
        view.textColor = .darkGray
        
        return view
    }()
    
    let seatsInfoView = {
        let view = UILabel()
        view.text = "O구역 O열 O번  100000원"
        view.font = .boldSystemFont(ofSize: 18)
        view.numberOfLines = 0
        
        return view
    }()
    
    let totalPriceLabel = {
        let view = UILabel()
        view.text = "최종 결제 금액"
        view.font = .boldSystemFont(ofSize: 18)
        view.textColor = .darkGray
        
        return view
    }()
    
    let totalPriceView = {
        let view = UILabel()
        view.text = "300000원"
        view.font = .boldSystemFont(ofSize: 18)
        
        return view
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
        
        for view in [infoView, seatsInfoLabel, seatsInfoView, totalPriceLabel, totalPriceView, payButton] {
            addSubview(view)
        }
    }
    
    override func setConstraints() {
        
        infoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
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
        
        payButton.snp.makeConstraints { make in
            make.top.equalTo(totalPriceView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
    }

}
