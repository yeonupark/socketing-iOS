//
//  ReservationView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/09.
//

import UIKit
import WebKit

enum SeatStatus {
    case isReserved
    case isSelected
    case isSelectedByMe
    case isFree
}

class SeatView: UIView {
    var seatId: String?
    
    var seatStatus: SeatStatus = .isFree {
        didSet {
            updateBackgroundColor()
        }
    }
    
    init(frame: CGRect, seatId: String?, isReserved: Bool) {
        self.seatId = seatId
        super.init(frame: frame)
        
        self.layer.cornerRadius = frame.width / 2
        self.backgroundColor = isReserved ? .gray : .white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateBackgroundColor() {
        switch seatStatus {
        case .isReserved:
            self.backgroundColor = .gray
        case .isSelected:
            self.backgroundColor = .systemYellow
        case .isSelectedByMe:
            self.backgroundColor = .systemPink
        case .isFree:
            self.backgroundColor = .white
        }
    }
}

class ReservationView: UIView {
    
    let infoView = EventInfoView()
    
    let bookButton = {
        let view = UIButton()
        view.setTitle("선택 좌석 예매하기", for: .normal)
        view.backgroundColor = .systemPink
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    var webView: WKWebView!
    
    lazy var seatView: (SeatData) -> SeatView = { seat in
        
        let svgWidth: CGFloat = 1000
        let svgHeight: CGFloat = 1000
        let viewWidth = self.webView.bounds.width
        let viewHeight = self.webView.scrollView.contentSize.height
        
        let scaleX = viewWidth / svgWidth
        let scaleY = viewHeight / svgHeight
        
        let screenX = seat.cx * scaleX
        let screenY = (seat.cy * scaleY) - self.webView.scrollView.contentOffset.y
        
        let seatSize: CGFloat = 7
        
        let frame = CGRect(x: screenX - seatSize / 2, y: screenY - seatSize / 2, width: seatSize, height: seatSize)
        return SeatView(frame: frame, seatId: seat.id, isReserved: seat.reservedUserId != nil)
    }
    
    let seatsInfoTableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
        view.backgroundColor = .white
        
        return view
    }()
    
    init(configuration: WKWebViewConfiguration) {
        super.init(frame: .zero)
        
        initializeWebView(configuration: configuration)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeWebView(configuration: WKWebViewConfiguration) {
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView.scrollView.isScrollEnabled = false
//        webView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure() {
        backgroundColor = .white
        
        addSubview(infoView)
        addSubview(bookButton)
        addSubview(webView)
        addSubview(seatsInfoTableView)
    }
    
    func setConstraints() {
        infoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        bookButton.snp.makeConstraints { make in
            make.bottom.equalTo(infoView).inset(45)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        seatsInfoTableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(140)
        }
    }

}
