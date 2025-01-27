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
        
        socketViewModel.bookButtonEnabled
            .drive(mainView.bookButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        socketViewModel.bookButtonColor
            .drive(mainView.bookButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        socketViewModel.htmlContent
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { html in
                self.mainView.webView.loadHTMLString(html, baseURL: nil)
            })
            .disposed(by: disposeBag)
        
        socketViewModel.seatsDataRelay
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { seats in
                
                self.mainView.webView.subviews
                    .filter { $0 is SeatView }
                    .forEach { $0.removeFromSuperview() }
                
                for seat in seats {
                    
                    let createdSeatView = self.mainView.seatView(seat)
                    let seatStatus: SeatStatus = {
                        if seat.reservedUserId != nil {
                            return .isReserved
                        }
                        switch seat.selectedBy {
                        case self.socketViewModel.socketId:
                            return .isSelectedByMe
                        case nil:
                            return .isFree
                        default:
                            return .isSelected
                        }
                    }()
                    createdSeatView.seatStatus = seatStatus
                    self.mainView.webView.addSubview(createdSeatView)
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.seatTapped(sender: )))
                    if seatStatus == .isFree {
                        createdSeatView.addGestureRecognizer(tapGesture)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        socketViewModel.selectedSeats
            .bind(to: mainView.seatsInfoTableView.rx.items(cellIdentifier: "BasicCell", cellType: UITableViewCell.self)) { (_, element, cell) in
                let currentArea = self.socketViewModel.areaInfo[self.socketViewModel.currentAreaId.value] ?? "A"
                cell.textLabel?.text = "\(currentArea)구역 \(element.row)열 \(element.number)번"
                cell.textLabel?.font = .boldSystemFont(ofSize: 14)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func seatTapped(sender: UITapGestureRecognizer) {
        guard let seatView = sender.view as? SeatView else {
            print("Tapped view is not SeatView")
            return
        }
        
        guard let seatId = seatView.seatId else {
            print("Seat ID not found in SeatView")
            return
        }
        socketViewModel.emitSelectSeats(seatId: seatId)
    }

}

extension ReservationViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
     
        if message.name == "svgHandler", let areaId = message.body as? String {
            if socketViewModel.currentAreaId.value == areaId {
                return
            }
            if socketViewModel.currentAreaId.value != "" {
                socketViewModel.emitExitArea()
            }
            socketViewModel.currentAreaId.accept(areaId)
        }
    }
}
