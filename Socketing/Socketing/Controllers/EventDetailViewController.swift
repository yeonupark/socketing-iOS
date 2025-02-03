//
//  EventDetailViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/06.
//

import UIKit
import RxSwift

class EventDetailViewController: BaseViewController {

    let mainView = EventDetailView()
    let viewModel = EventDetailViewModel.shared
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.event.value.title
        
        bind()
    }
    
    private func bind() {
        
        viewModel.event
            .asDriver(onErrorJustReturn: EventData(id: "", title: "", eventDates: [], thumbnail: "", place: "", cast: "", ticketingStartTime: ""))
            .drive(onNext: { event in
                
                CommonUtils.loadThumbnailImage(from: event.thumbnail, into: self.mainView.thumbnail)
                self.mainView.titleLabel.text = event.title
                self.mainView.dateLabel.text = "일시 | \( CommonUtils.formatDateString(event.eventDates[0].date) ?? "2025.12.20")"
                self.mainView.placeLabel.text = "장소 | \(event.place)"
                self.mainView.castLabel.text = "출연 | \(event.cast)" 
            })
            .disposed(by: disposeBag)
        
        viewModel.numberOfFriends
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { number in
                self.mainView.friendRegistrationButton.setTitle("함께할 친구 등록 (\(number)명)", for: .normal)
            })
            .disposed(by: disposeBag)
        
        mainView.bookingButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.viewModel.numberOfFriends.accept(0)
                UserDefaults.standard.setValue(true, forKey: "enter")
                let vc = WaitingViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.togetherBookingButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                if self?.viewModel.numberOfFriends.value == 0 {
                    self?.togetherButtonDisabled()
                    return
                }
                UserDefaults.standard.setValue(true, forKey: "enter")
                let vc = WaitingViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.friendRegistrationButton.addTarget(self, action: #selector(showNameInputModal), for: .touchUpInside)
        
    }
    
    @objc func showNameInputModal() {
        let alert = UIAlertController(title: "함께할 친구 등록하기",
                                      message: "친구의 이름을 입력해주세요",
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "이름을 입력하세요"
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                let numberOfTickets = self.viewModel.numberOfFriends.value + 1
                self.viewModel.numberOfFriends.accept(numberOfTickets)
            } else {
                print("이름이 입력되지 않았습니다")
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            print("입력 취소")
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func togetherButtonDisabled() {
        let alert = UIAlertController(title: "함께할 친구를 등록해주세요", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
        
    }

}
