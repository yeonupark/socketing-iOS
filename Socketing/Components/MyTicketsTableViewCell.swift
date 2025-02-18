//
//  MyTicketsTableViewCell.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/18.
//

import UIKit
import RxSwift

class MyTicketsTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    let thumbnail: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 5
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "공연 제목"
        view.font = .boldSystemFont(ofSize: 18)
        view.textColor = .black
        return view
    }()
    
    let bookingLabel = makeInfoLabel(title: "예매")
    let scheduleLabel = makeInfoLabel(title: "일정")
    let placeLabel = makeInfoLabel(title: "장소")
    let castLabel = makeInfoLabel(title: "출연")

    let infoButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매 정보 보기", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure() {
        self.selectionStyle = .none
        contentView.addSubview(thumbnail)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bookingLabel)
        contentView.addSubview(scheduleLabel)
        contentView.addSubview(placeLabel)
        contentView.addSubview(castLabel)
        contentView.addSubview(infoButton)
    }
    
    func setConstraints() {
        thumbnail.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(80)
            make.height.equalTo(110)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnail.snp.top)
            make.left.equalTo(thumbnail.snp.right).offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        bookingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        scheduleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookingLabel.snp.bottom).offset(4)
            make.left.right.equalTo(bookingLabel)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(scheduleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(bookingLabel)
        }
        
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom).offset(4)
            make.left.right.equalTo(bookingLabel)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        infoButton.snp.makeConstraints { make in
            make.bottom.equalTo(castLabel.snp.bottom)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(110)
            make.height.equalTo(32)
        }
    }
    
    static func makeInfoLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = "\(title) "
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }
    
    func configureData(thumbnailUrl: String, title: String, booking: String, schedule: String, place: String, cast: String) {
        CommonUtils.loadThumbnailImage(from: thumbnailUrl, into: thumbnail)
        titleLabel.text = title
        bookingLabel.text = "예매  \(CommonUtils.formatDateString(booking) ?? "")"
        scheduleLabel.text = "일정  \(CommonUtils.formatDateString(schedule) ?? "")"
        placeLabel.text = "장소  \(place)"
        castLabel.text = "출연  \(cast)"
    }
}
