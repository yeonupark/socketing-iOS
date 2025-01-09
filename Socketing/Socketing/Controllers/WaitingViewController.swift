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
    }

}
