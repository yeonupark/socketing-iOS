//
//  MainViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/02.
//

import UIKit
import RxSwift
import Toast

class MainViewController: BaseViewController {
    
    private let mainView = MainView()
    let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        bind()
        viewModel.getEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.logined {
            guard let email = UserDefaults.standard.string(forKey: "email") else {
                return
            }
            
            if let username = email.split(separator: "@").first {
                var style = ToastStyle()
                style.backgroundColor = .systemPink
                self.view.makeToast("환영합니다, \(username)님!", duration: 2.0, position: .top, style: style)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.logined = false
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "예매 진행중인 공연"
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(myPageButtonClicked)), animated: true)
    }
    
    @objc func myPageButtonClicked() {
        if UserDefaults.standard.string(forKey: "authToken") != nil {
            let vc = MyPageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func bind() {
        viewModel.events
            .map { events in
                events.sorted {
                    guard let date1 = CommonUtils.formatDateString($0.eventDates[0].date),
                          let date2 = CommonUtils.formatDateString($1.eventDates[0].date) else { return false }
                    return date1 < date2
                }
            }
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


