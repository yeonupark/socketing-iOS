//
//  MainView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/05.
//

import UIKit

class MainView: BaseView {
    
    let titleLabel = {
        let view = UILabel()
        view.text = "예매 진행중인 공연"
        view.font = .boldSystemFont(ofSize: 24)
        view.textAlignment = .center
        return view
    }()
    
    let tableView = {
        let view = UITableView()
        view.register(EventsTableViewCell.self, forCellReuseIdentifier: "EventsTableViewCell")
        view.backgroundColor = .clear
        view.rowHeight = 208 /*+ UIScreen.main.bounds.width*/
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        addSubview(titleLabel)
        addSubview(tableView)
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(32)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
    }

}
