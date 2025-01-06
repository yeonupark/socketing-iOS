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
        
        navigationItem.title = "예매 진행중인 공연"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
        
        bind()
        viewModel.getEvents()
    }
    
    private func bind() {
        viewModel.events
            .bind(to: mainView.tableView.rx.items(cellIdentifier: "EventsTableViewCell", cellType: EventsTableViewCell.self)) { (_, element, cell) in
                
                cell.titleLabel.text = element.title
                cell.placeLabel.text = element.place
                
                CommonUtils.loadThumbnailImage(from: element.thumbnail, into: cell.thumbnail)
                if let dateString = CommonUtils.formatDateString(element.eventDates[0].date) {
                    cell.dateLabel.text = dateString
                }
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(EventData.self)
            .subscribe(onNext: { event in
                let vc = EventDetailViewController()
                vc.viewModel.event.accept(event)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

}


