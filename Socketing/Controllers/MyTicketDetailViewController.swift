//
//  MyTicketDetailViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/18.
//

import UIKit

class MyTicketDetailViewController: UIViewController {

    let mainView = MyTicketDetailView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
