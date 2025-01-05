//
//  MainViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/03.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    let events = BehaviorRelay<[EventData]>(value: [])
    
    private let disposeBag = DisposeBag()

    func fetchEvents() {
        print("fetch events")
        getEvents()
            .subscribe(onNext: { [weak self] newEvents in
                print(newEvents)
                self?.events.accept(newEvents)
            }, onError: { error in
                print("Error fetching events: \(error)")
            })
            .disposed(by: disposeBag)
    }

    private func getEvents() -> Observable<[EventData]> {
        print("get events")
        // 네트워크 요청 수행
        return Observable.create { observer in
            // Mock 데이터
            let mockData = [
                EventData(id: "1", title: "투바투 콘서트", eventDates: [EventDate(id: "00", date: "2025.02.12")], thumbnail: "test", place: "상암경기장", cast: "투모로우바이투게더", ticketingStartTime: "2024.12.31"),
                EventData(id: "2", title: "뉴진스 콘서트", eventDates: [EventDate(id: "00", date: "2025.03.03")], thumbnail: "test", place: "올림픽주경기장", cast: "newJeans", ticketingStartTime: "2024.12.31")
            ]
            observer.onNext(mockData)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
