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
        
        mainView.infoView.configureWithViewModel(eventData: socketViewModel.eventData)
        
        let areaInfo = socketViewModel.orderData?.area
        let seatsInfo = socketViewModel.orderData?.seats ?? []
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
