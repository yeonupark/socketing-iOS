//
//  WaitingViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/07.
//

import UIKit
import RxSwift

class WaitingViewController: BaseViewController {
    
    let mainView = WaitingView()
    let queueViewModel = QueueViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !UserDefaults.standard.bool(forKey: "enter") {
            navigationController?.popViewController(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        queueViewModel.connectSocket()
        
        mainView.infoView.configureWithViewModel(eventData: queueViewModel.eventData)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        queueViewModel.disconnectSocket()
    }
    
    private func bind() {
        queueViewModel.isTurn.asDriver(onErrorJustReturn: false)
            .drive(onNext: { isTurn in
                if isTurn {
                    let vc = ReservationViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(queueViewModel.totalWaiting, queueViewModel.myPosition)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] total, position in
                guard let self = self else { return }
                if total == 0 {
                    self.mainView.queueNumLabel.isHidden = true
                    self.mainView.positionLabel.isHidden = true
                }
                let progress = 1.0 - (Double(position) / Double(total))
                self.mainView.progressView.setProgress(Float(progress), animated: true)
                self.mainView.positionLabel.text = "현재 순서: \(position)"
                self.mainView.queueNumLabel.text = "\(total - position)명이 뒤에 대기중입니다."
            })
            .disposed(by: disposeBag)
        
        queueViewModel.isLogouted.asDriver(onErrorJustReturn: false)
            .drive(onNext: { isLogouted in
                if isLogouted {
                    let vc1 = MainViewController()
                    let vc2 = EventDetailViewController()
                    let vc3 = LoginViewController()
                    vc3.viewModel.logouted = true
                    self.navigationController?.setViewControllers([vc1, vc2, vc3], animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        queueViewModel.isNeverLogined.asDriver(onErrorJustReturn: false)
            .drive(onNext: { isNeverLogined in
                if isNeverLogined {
                    let vc1 = MainViewController()
                    let vc2 = EventDetailViewController()
                    let vc3 = LoginViewController()
                    vc3.viewModel.firstLogined = true
                    self.navigationController?.setViewControllers([vc1, vc2, vc3], animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

}
