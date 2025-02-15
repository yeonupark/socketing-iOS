//
//  EventDetailViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/06.
//

import UIKit
import RxSwift
import Toast

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
        viewModel.numberOfFriends.accept(0)
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
        
        mainView.bookingButton.addTarget(self, action: #selector(bookButtonClicked), for: .touchUpInside)
        
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
    
    @objc func bookButtonClicked() {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        self.viewModel.numberOfFriends.accept(0)
        UserDefaults.standard.setValue(true, forKey: "enter")
        let vc = WaitingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showNameInputModal() {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let alert = UIAlertController(title: "함께할 친구 등록하기",
                                      message: "친구의 이름을 입력해주세요",
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "이름을 입력하세요"
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                if name+"@jungle.com" == UserDefaults.standard.string(forKey: "email") {
                    self.view.makeToast("다른 사용자의 닉네임을 입력해주세요.", duration: 2.0, position: .top)
                    return
                }
                self.viewModel.searchFriend(nickname: name) { ok in
                    DispatchQueue.main.async {
                        if !ok {
                            self.view.makeToast("가입되지 않은 사용자입니다.", duration: 2.0, position: .top)
                        }
                    }
                }
                
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
