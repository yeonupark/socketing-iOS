//
//  EventDetailView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/06.
//

import UIKit
import SnapKit

class EventDetailView: BaseView {

    let infoView = {
        let view = UIView()
        
        return view
    }()
    
    let thumbnail = {
        let view = UIImageView()
        view.image = UIImage(systemName: "hourglass.circle.fill")
        view.tintColor = .black
        
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.text = "공연 제목"
        view.font = .boldSystemFont(ofSize: 16)
        view.textAlignment = .center
        
        return view
    }()
    
    let dateLabel = {
        let view = UILabel()
        view.text = "일시: "
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .darkGray
        view.textAlignment = .center
        
        return view
    }()
    
    let placeLabel = {
        let view = UILabel()
        view.text = "장소: "
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .darkGray
        view.textAlignment = .center
        
        return view
    }()
    
    let castLabel = {
        let view = UILabel()
        view.text = "출연: "
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .darkGray
        view.textAlignment = .center
        
        return view
    }()
    
    let friendRegistrationButton = {
        let view = UIButton()
        view.setTitle("함께할 친구 등록 (0명)", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        view.titleLabel?.textColor = .white
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    let togetherBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("함께 예매하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()

    let bookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        
        return button
    }()

    private let actionButtonsContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    override func configure() {
        super.configure()
        
        for item in [infoView, friendRegistrationButton, actionButtonsContainer] {
            addSubview(item)
        }
        for item in [thumbnail, titleLabel, dateLabel, placeLabel, castLabel] {
            infoView.addSubview(item)
        }
        for item in [togetherBookingButton, bookingButton] {
            actionButtonsContainer.addSubview(item)
        }
    }
    
    override func setConstraints() {
        infoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        thumbnail.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(12)
            make.width.equalTo(160)
            make.height.equalTo(200)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnail).inset(50)
            make.left.equalTo(thumbnail.snp.right).offset(12)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
        friendRegistrationButton.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        actionButtonsContainer.snp.makeConstraints { make in
            make.top.equalTo(friendRegistrationButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        togetherBookingButton.snp.makeConstraints { make in
            make.leading.equalTo(actionButtonsContainer.snp.leading).offset(12)
            make.centerY.equalTo(actionButtonsContainer)
            make.height.equalTo(40)
            make.width.equalTo(actionButtonsContainer).multipliedBy(0.45)
        }
        
        bookingButton.snp.makeConstraints { make in
            make.trailing.equalTo(actionButtonsContainer.snp.trailing).offset(-12)
            make.centerY.equalTo(actionButtonsContainer)
            make.height.equalTo(40)
            make.width.equalTo(actionButtonsContainer).multipliedBy(0.45)
        }
    }

}
