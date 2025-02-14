//
//  BaseViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/09.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
    }
    
}
