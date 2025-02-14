//
//  MyPageView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/29.
//

import UIKit

class MyPageView: BaseView {

    let tableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
        view.backgroundColor = .white
        
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
