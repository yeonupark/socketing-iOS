//
//  MainViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/02.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view.self = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewModel.getEvents()
    }
    
    private func bind() {
        viewModel.events
            .bind(to: mainView.tableView.rx.items(cellIdentifier: "EventsTableViewCell", cellType: EventsTableViewCell.self)) { (_, element, cell) in
//                cell.thumbnail.image. = element.thumbnail
                cell.titleLabel.text = element.title
                cell.dateLabel.text = element.eventDates[0].date
                cell.placeLabel.text = element.place
            }
            .disposed(by: disposeBag)
    }


}


