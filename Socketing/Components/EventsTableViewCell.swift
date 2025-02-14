//
//  EventsTableViewCell.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/05.
//

import UIKit
import SnapKit

class EventsTableViewCell: UITableViewCell {
    
    let thumbnail = {
        let view = UIImageView()
        view.image = UIImage(systemName: "hourglass.circle.fill")
        view.tintColor = .black
        
        view.layer.cornerRadius = 5
        view.contentMode = .scaleAspectFill
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
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .darkGray
        view.textAlignment = .center
        
        return view
    }()
    
    let placeLabel = {
        let view = UILabel()
        view.text = "장소: "
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .darkGray
        view.textAlignment = .center
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        self.selectionStyle = .none
        
        for item in [ thumbnail, titleLabel, dateLabel, placeLabel] {
            contentView.addSubview(item)
        }
    }
    
    func setConstraints() {
        thumbnail.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(12)
            make.height.equalTo(160)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnail.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(thumbnail)
            make.height.equalTo(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(thumbnail)
            make.height.equalTo(20)
        }
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(thumbnail)
            make.height.equalTo(20)
        }
    }
}
