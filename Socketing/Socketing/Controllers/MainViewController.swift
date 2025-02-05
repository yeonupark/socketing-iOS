//
//  MainViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/02.
//

import UIKit
import RxSwift

class MainViewController: BaseViewController {
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        bind()
        viewModel.getEvents()
        
        checkTokenExpiration()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "예매 진행중인 공연"
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(myPageButtonClicked)), animated: true)
    }
    
    private func checkTokenExpiration() {
        let isExpired = viewModel.isTokenExpired()
        if isExpired {
            print("토큰 만료됨")
            let vc = LoginViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    @objc func myPageButtonClicked() {
        print("mypage button clicked")
        let vc = MyPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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


