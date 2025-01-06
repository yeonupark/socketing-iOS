//
//  WaitingViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/07.
//

import UIKit

class WaitingViewController: UIViewController {
    
    let mainView = WaitingView()
//    let viewModel = EventDetailViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
