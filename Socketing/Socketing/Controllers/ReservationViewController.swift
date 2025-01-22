//
//  ReservationViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/09.
//

import UIKit
import RxSwift
import WebKit

class ReservationViewController: BaseViewController {

    var mainView: ReservationView!
    let socketViewModel = SocketViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "svgHandler")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        self.mainView = ReservationView(configuration: config)
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
        
        socketViewModel.currentAreaId
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { areaId in
                if areaId != "" {
                    self.socketViewModel.emitJoinArea()
                }
            })
            .disposed(by: disposeBag)
        
        socketViewModel.seatsData
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { seats in
                self.mainView.seatOverlayView.subviews.forEach { $0.removeFromSuperview() }
                for seat in seats {
                    let createdSeatView = self.mainView.seatView(seat)
                    self.mainView.seatOverlayView.addSubview(createdSeatView)
                }
            })
            .disposed(by: disposeBag)
    }

}

extension ReservationViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
     
        if message.name == "svgHandler", let areaId = message.body as? String {
            if socketViewModel.currentAreaId.value != "" {
                socketViewModel.emitExitArea()
            }
            socketViewModel.currentAreaId.accept(areaId)
        }
    }
}
