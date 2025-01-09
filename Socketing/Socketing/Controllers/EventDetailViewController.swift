//
//  EventDetailViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/06.
//

import UIKit
import RxSwift

class EventDetailViewController: BaseViewController {

    let mainView = EventDetailView()
    let viewModel = EventDetailViewModel.shared
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.event.value.title
        
        bind()
    }
    
    private func bind() {
        
        viewModel.event
            .asDriver(onErrorJustReturn: EventData(id: "", title: "", eventDates: [], thumbnail: "", place: "", cast: "", ticketingStartTime: ""))
            .drive(onNext: { event in
                
                CommonUtils.loadThumbnailImage(from: event.thumbnail, into: self.mainView.thumbnail)
                self.mainView.titleLabel.text = event.title
                self.mainView.dateLabel.text = "일시: \( CommonUtils.formatDateString(event.eventDates[0].date) ?? "2025.12.20")"
                self.mainView.placeLabel.text = "장소: \(event.place)"
                self.mainView.castLabel.text = "출연: \(event.cast)" 
            })
            .disposed(by: disposeBag)
        
        mainView.bookingButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                UserDefaults.standard.setValue(true, forKey: "enter")
                let vc = WaitingViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
    }

}
