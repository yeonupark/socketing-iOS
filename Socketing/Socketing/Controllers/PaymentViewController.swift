//
//  PaymentViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/30.
//

import UIKit
import RxSwift

class PaymentViewController: BaseViewController {

    let mainView = PaymentView()
    var socketViewModel: SocketViewModel?
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        bind()
        
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "결제하기"
    }
    
    private func bind() {
        
        guard let socketViewModel else {
            return
        }
        
        socketViewModel.payButtonColor
            .drive(mainView.payButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        socketViewModel.payButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isEnabled in
                self.mainView.checkboxButton.setImage(isEnabled ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square"), for: .normal)
                self.mainView.payButton.rx.isEnabled.onNext(isEnabled)
            })
            .disposed(by: disposeBag)
        
        socketViewModel.reservationData
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { data in
                if data == nil {
                    return
                }
                
                socketViewModel.disconnectSocket()
                let vc = ConfirmationViewController()
                vc.viewModel.reservationData = data
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        socketViewModel.paymentTimeLeft
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { time in
                self.mainView.timerLabel.text = String(format: "남은 시간 00:%02d", time)
            })
            .disposed(by: disposeBag)
        
        socketViewModel.isPaymentTimeOut
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { value in
                if value == true {
                    socketViewModel.orderData.accept(nil)
                    self.socketViewModel?.disconnectSocket()
                    let vc1 = MainViewController()
                    let vc2 = EventDetailViewController()
                    vc1.navigationItem.backButtonTitle = ""
                    self.navigationController?.setViewControllers([vc1, vc2], animated: true)
                }
            })
            .disposed(by: disposeBag)

        mainView.infoView.configureWithViewModel(eventData: socketViewModel.eventData)
        
        let areaInfo = socketViewModel.orderData.value?.area
        let seatsInfo = socketViewModel.orderData.value?.seats ?? []
        let seatText = seatsInfo.map { "\(areaInfo?.label ?? "A")구역 \($0.row)열 \($0.number)번  |  \(areaInfo?.price ?? 100000)원" }.joined(separator: "\n")

        mainView.seatsInfoView.text = seatText

        mainView.totalPriceView.text = "\((areaInfo?.price ?? 100000) * seatsInfo.count)원"
        
        mainView.payButton.addTarget(self, action: #selector(payButtonClicked), for: .touchUpInside)
        
        mainView.checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
    }
    
    @objc private func toggleCheckbox() {
        socketViewModel?.payButtonEnabled.accept(!(socketViewModel?.payButtonEnabled.value ?? false))
    }
    
    @objc private func payButtonClicked() {
        socketViewModel?.emitRequestOrder()
    }

}
