//
//  MyTicketDetailView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/18.
//

import UIKit

class MyTicketDetailView: BaseView {
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(systemName: "star")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let castLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private let userEmailLabel = InfoLabel(text: "")
    private let dateLabel = InfoLabel(text: "")
    private let locationLabel = InfoLabel(text: "")
    private let seatLogo = InfoLabel(text: "🎫  좌석 정보")
    private let seatLabel = InfoLabel(text: "")
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, castLabel])
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userEmailLabel, dateLabel, locationLabel, seatLogo])
        stack.axis = .vertical
        stack.spacing = 28
        return stack
    }()
    
    let cancelButton = {
        let view = UIButton()
        view.setTitle("예매 취소", for: .normal)
        
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        view.backgroundColor = .systemPink
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        addSubview(cardView)
        cardView.addSubview(posterImageView)
        cardView.addSubview(contentStackView)
        cardView.addSubview(infoStackView)
        cardView.addSubview(seatLabel)
        addSubview(cancelButton)
    }
    
    func configureWithViewModel(with data: MyOrderData) {
        
        CommonUtils.loadThumbnailImage(from: data.eventThumbnail, into: posterImageView)
        titleLabel.text = data.eventTitle
        castLabel.text = data.eventCast
        
        userEmailLabel.setText("👤  \(UserDefaults.standard.string(forKey: "email") ?? "")")
        dateLabel.setText("📅  \(CommonUtils.formatDateString(data.eventDate) ?? "")")
        locationLabel.setText("📍  \(data.eventPlace)")
        let seatInfoText = data.reservations.map {
            "\($0.seatAreaLabel)구역 \($0.seatRow)열 \($0.seatNumber)번 (\($0.seatAreaPrice)원)"
        }.joined(separator: "\n")
        seatLabel.setText(seatInfoText)
    }
    
    override func setConstraints() {
        cardView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(cardView).offset(16)
            make.width.equalTo(80)
            make.height.equalTo(100)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.centerY.equalTo(posterImageView)
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalTo(cardView).offset(-16)
        }

        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).offset(60)
            make.leading.trailing.equalTo(cardView).inset(16)
        }
        
        seatLabel.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(4)
            make.leading.equalTo(cardView).inset(48)
            make.bottom.equalTo(cardView).offset(-16)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
    }

}
