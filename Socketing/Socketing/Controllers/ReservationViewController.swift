//
//  ReservationViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/09.
//

import UIKit

class ReservationViewController: UIViewController {

    let mainView = ReservationView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(false, forKey: "enter")
    }

}
