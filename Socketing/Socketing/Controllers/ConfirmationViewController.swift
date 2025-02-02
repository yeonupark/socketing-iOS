//
//  ConfirmationViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/01.
//

import UIKit

class ConfirmationViewController: UIViewController {

    let mainView = ConfirmationView()
    let viewModel = ConfirmationViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let reservationData = viewModel.reservationData {
            mainView.configureWithViewModel(with: reservationData)
        }
        
        navigationItem.hidesBackButton = true
    }
    

}
