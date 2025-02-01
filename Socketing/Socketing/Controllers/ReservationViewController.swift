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
        mainView.infoView.configureWithViewModel(eventData: socketViewModel.eventData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        socketViewModel.orderData = nil
        socketViewModel.currentAreaId.accept("")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if socketViewModel.orderData == nil {
            socketViewModel.disconnectSocket()
        }
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
                cell.textLabel?.font = .boldSystemFont(ofSize: 16)
            }
            .disposed(by: disposeBag)
        
        mainView.bookButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.socketViewModel.emitReserveSeats()
                self.socketViewModel.selectedSeats.accept([])
                self.showAlert()
            })
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
    
    private func showAlert() {
        
        let alert = UIAlertController(title: "좌석 예매 알림",
                                       message: "결제페이지로 이동합니다.\n1분 내에 결제를 완료해주세요.",
                                       preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.socketViewModel.emitExitRoom()
            let vc = PaymentViewController()
            vc.socketViewModel = self.socketViewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
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
