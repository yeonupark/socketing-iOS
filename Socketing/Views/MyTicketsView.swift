//
//  MyTicketsView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/18.
//

import UIKit

class MyTicketsView: BaseView {

    let tableView = {
        let view = UITableView()
        view.register(MyTicketsTableViewCell.self, forCellReuseIdentifier: "MyTicketsTableViewCell")
        view.backgroundColor = .white
//        view.rowHeight = 100
        return view
    }()
    
    override func configure() {
        super.configure()
        
        addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
