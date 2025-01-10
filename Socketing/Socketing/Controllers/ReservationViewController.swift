//
//  ReservationViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/09.
//

import UIKit

class ReservationViewController: BaseViewController {

    let mainView = ReservationView()
    let socketViewModel = SocketViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(false, forKey: "enter")
        
        socketViewModel.connectSocket()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        socketViewModel.disconnectSocket()
    }

}
