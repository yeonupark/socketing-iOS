//
//  ReservationView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/09.
//

import UIKit
import WebKit

class SeatView: UIView {
    var seatId: String?
    
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
}

class ReservationView: UIView {
    
    let infoView = EventInfoView()
    
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
        addSubview(webView)
    }
    
    func setConstraints() {
        infoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
    }

}
