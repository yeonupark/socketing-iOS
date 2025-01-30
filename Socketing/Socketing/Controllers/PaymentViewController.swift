//
//  PaymentViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/30.
//

import UIKit

class PaymentViewController: BaseViewController {

    let mainView = PaymentView()
    var socketViewModel: SocketViewModel?
    
    override func loadView() {
        view.self = mainView
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
        
        mainView.infoView.configureWithViewModel(eventData: socketViewModel.eventData)
        
        let areaInfo = socketViewModel.orderData?.area
        let seatsInfo = socketViewModel.orderData?.seats ?? []
        let seatText = seatsInfo.map { "\(areaInfo?.label ?? "A")구역 \($0.row)열 \($0.number)번" }.joined(separator: "\n")

        mainView.seatsInfoView.text = seatText

        
        mainView.totalPriceView.text = "\((areaInfo?.price ?? 100000) * seatsInfo.count)원"
        
    }

}
