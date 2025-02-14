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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) { [weak self] in
            let vc = MainViewController()
            self?.navigationController?.setViewControllers([vc], animated: true)
        }
        
        startCountdown()
    }
    
    private func startCountdown() {
        viewModel.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            viewModel.countdownValue -= 1
            mainView.countdownLabel.text = "\(viewModel.countdownValue)초 후 자동으로 첫 화면으로 이동합니다."
            
            if viewModel.countdownValue <= 0 {
                timer.invalidate()
            }
        }
    }
}
