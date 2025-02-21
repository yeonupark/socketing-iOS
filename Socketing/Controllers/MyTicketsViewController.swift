//
//  MyTicketsViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/18.
//

import UIKit
import RxSwift

class MyTicketsViewController: BaseViewController {

    let mainView = MyTicketsView()
    let viewModel = MyTicketsViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getMyOrders()
    }
    
    private func bind() {
        
        mainView.segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.viewModel.filterOrders(by: index)
            })
            .disposed(by: disposeBag)
        
        viewModel.filteredOrderDatas.bind(to: mainView.tableView.rx.items(cellIdentifier: "MyTicketsTableViewCell", cellType: MyTicketsTableViewCell.self)) { (_, element, cell) in
            
            cell.configureData(thumbnailUrl: element.eventThumbnail, title: element.eventTitle, booking: element.orderCreatedAt, schedule: element.eventDate, place: element.eventPlace, cast: element.eventCast)
            
            cell.infoButton.rx.tap.subscribe { _ in
                let vc = MyTicketDetailViewController()
                vc.mainView.configureWithViewModel(with: element)
                vc.viewModel.orderId = element.orderId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
    }
}
