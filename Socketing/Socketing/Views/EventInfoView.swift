//
//  EventInfoView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/10.
//

import UIKit

class EventInfoView: BaseView {
    
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
        view.font = .boldSystemFont(ofSize: 16)
        view.textAlignment = .center
        
        return view
    }()
    
    let dateLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .darkGray
        view.textAlignment = .center
        
        return view
    }()
    
    let placeLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .darkGray
        view.textAlignment = .center
        
        return view
    }()
    
    let castLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .darkGray
        view.textAlignment = .center
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        [thumbnail, titleLabel, dateLabel, placeLabel, castLabel].forEach { addSubview($0) }
    }
    
    func configureWithViewModel(eventData: EventData) {
        
        titleLabel.text = eventData.title
        dateLabel.text = "일시: \(CommonUtils.formatDateString(eventData.eventDates[0].date) ?? "")"
        placeLabel.text = "장소: \(eventData.place)"
        castLabel.text = "출연: \(eventData.cast)"
        
        CommonUtils.loadThumbnailImage(from: eventData.thumbnail, into: thumbnail)
    }
    
    override func setConstraints() {
        thumbnail.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(12)
            make.width.equalTo(180)
            make.height.equalTo(240).priority(.required)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(80)
            make.left.equalTo(thumbnail.snp.right).offset(30)
            make.right.lessThanOrEqualToSuperview().inset(12)
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
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }
    }

}
