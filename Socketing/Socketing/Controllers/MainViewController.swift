//
//  MainViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/02.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view.self = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewModel.getEvents()
    }
    
    private func bind() {
        viewModel.events
            .bind(to: mainView.tableView.rx.items(cellIdentifier: "EventsTableViewCell", cellType: EventsTableViewCell.self)) { (_, element, cell) in
                
                cell.titleLabel.text = element.title
                cell.placeLabel.text = element.place
                
                self.loadThumbnailImage(from: element.thumbnail, into: cell.thumbnail)
                if let dateString = self.formatDateString(element.eventDates[0].date) {
                    cell.dateLabel.text = dateString
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func formatDateString(_ dateString: String) -> String? {
        
        guard dateString.count >= 10 else {
            return nil
        }
        
        let dateSubstring = dateString.prefix(10)
        
        let formattedDate = dateSubstring.replacingOccurrences(of: "-", with: ".")
        
        return formattedDate
    }
    
    private func loadThumbnailImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to decode image")
                return
            }

            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }

}


