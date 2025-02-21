//
//  MyTicketDetailViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/18.
//

import UIKit

class MyTicketDetailViewController: UIViewController {

    let mainView = MyTicketDetailView()
    let viewModel = MyTicketDetailViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    }
    
    @objc
    func cancelButtonClicked() {
        let alert = UIAlertController(title: "예매를 취소하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
        alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: { _ in
            self.viewModel.cancelOrder { done in
                DispatchQueue.main.async {
                    if done {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let failedAlert = UIAlertController(title: "문제가 발생하여 예매 취소에 실패하였습니다.", message: nil, preferredStyle: .alert)
                        failedAlert.addAction(UIAlertAction(title: "확인", style: .default))
                        self.present(failedAlert, animated: true)
                    }
                }
            }
        }))
        self.present(alert, animated: true)
    }
}
