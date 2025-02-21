//
//  MyTicketsView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/18.
//

import UIKit

class MyTicketsView: BaseView {
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [TicketsMenu.UpComing.rawValue, TicketsMenu.Past.rawValue, TicketsMenu.Cancelled.rawValue])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .white
        control.selectedSegmentTintColor = .clear
        control.setTitleTextAttributes([.foregroundColor: UIColor.systemPink, .font: UIFont.boldSystemFont(ofSize: 16)], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.darkGray, .font: UIFont.systemFont(ofSize: 14)], for: .normal)
        return control
    }()

    let tableView = {
        let view = UITableView()
        view.register(MyTicketsTableViewCell.self, forCellReuseIdentifier: "MyTicketsTableViewCell")
        view.backgroundColor = .white
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        addSubview(segmentedControl)
        addSubview(tableView)
    }
    
    override func setConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
