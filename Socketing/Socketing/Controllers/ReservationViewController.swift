//
//  ReservationViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/09.
//

import UIKit
import RxSwift

class ReservationViewController: BaseViewController {

    let mainView = ReservationView()
    let socketViewModel = SocketViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(false, forKey: "enter")
        bind()
        
        socketViewModel.connectSocket()
        
        let eventData = EventDetailViewModel.shared.event.value
        mainView.infoView.configureWithViewModel(eventData: eventData)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        socketViewModel.disconnectSocket()
    }
    
    private func bind() {
        
        socketViewModel.htmlContent
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { html in
                self.mainView.webView.loadHTMLString(html, baseURL: nil)
            })
            .disposed(by: disposeBag)
    }

}
