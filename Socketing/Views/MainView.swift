//
//  MainView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/05.
//

import UIKit

class MainView: BaseView {
    
    let tableView = {
        let view = UITableView()
        view.register(EventsTableViewCell.self, forCellReuseIdentifier: "EventsTableViewCell")
        view.backgroundColor = .clear
        view.rowHeight = 258 
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }

}
