//
//  ConfirmationView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/01.
//

import UIKit

class ConfirmationView: BaseView {
    
    private let completionLabel: UILabel = {
        let label = UILabel()
        label.text = "예매가 완료되었습니다."
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    let countdownLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .red
        label.textAlignment = .center
        label.text = "5초 후 자동으로 첫 화면으로 이동합니다."
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
        view.layer.cornerRadius = 12
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
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "공연 당일 예매내역을 확인할 수 있는 신분증을 지참해주세요."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
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
    
    override func configure() {
        super.configure()
        
        addSubview(completionLabel)
        addSubview(countdownLabel)
        addSubview(cardView)
        cardView.addSubview(posterImageView)
        cardView.addSubview(contentStackView)
        cardView.addSubview(infoStackView)
        cardView.addSubview(seatLabel)
        addSubview(noticeLabel)
    }
    
    func configureWithViewModel(with data: ReservationData) {
        
        CommonUtils.loadThumbnailImage(from: data.eventThumbnail, into: posterImageView)
        titleLabel.text = data.eventTitle
        castLabel.text = data.eventCast
        
        userEmailLabel.setText("👤  \(data.userEmail)")
        dateLabel.setText("📅  \(CommonUtils.formatDateString(data.eventDate) ?? "")")
        locationLabel.setText("📍  \(data.eventPlace)")
        let seatInfoText = data.reservations.map {
            "\($0.seatAreaLabel)구역 \($0.seatRow)열 \($0.seatNumber)번 (\($0.seatPrice)원)"
        }.joined(separator: "\n")
        seatLabel.setText(seatInfoText)
    }
    
    override func setConstraints() {
        completionLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        countdownLabel.snp.makeConstraints { make in
            make.top.equalTo(completionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(countdownLabel.snp.bottom).offset(20)
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
        
        noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
}

class InfoLabel: UIView {
    
    let label: UILabel
    
    init(text: String) {
        
        label = UILabel()
        
        label.text = text
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        
        super.init(frame: .zero)
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        label.text = text
    }
}
