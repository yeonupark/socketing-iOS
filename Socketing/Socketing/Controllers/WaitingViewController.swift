//
//  WaitingViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/07.
//

import UIKit

class WaitingViewController: UIViewController {
    
    let mainView = WaitingView()
    let queueViewModel = QueueViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        queueViewModel.connectSocket()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        queueViewModel.disconnectSocket()
    }

}
