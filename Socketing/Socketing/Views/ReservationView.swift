//
//  ReservationView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/09.
//

import UIKit
import WebKit

class ReservationView: UIView {
    
    let infoView = EventInfoView()
    
    var webView: WKWebView!

    let seatOverlayView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var seatView: (SeatData) -> UIView = { seat in
        
        let svgWidth: CGFloat = 1350
        let svgHeight: CGFloat = 1350
        let viewWidth = self.webView.bounds.width
        let viewHeight = self.webView.scrollView.contentSize.height
        
        let scaleX = viewWidth / svgWidth
        let scaleY = viewHeight / svgHeight
        
        let screenX = seat.cx * scaleX
        let screenY = (seat.cy * scaleY) - self.webView.scrollView.contentOffset.y

        let seatSize: CGFloat = 7
        
        let view = UIView(frame: CGRect(x: screenX - seatSize / 2, y: screenY - seatSize / 2, width: seatSize, height: seatSize))
        
        view.layer.cornerRadius = seatSize / 2
        view.backgroundColor = seat.reservedUserId == nil ? .white : .gray
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.white.cgColor
        
        return view
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
        addSubview(seatOverlayView)
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
        seatOverlayView.snp.makeConstraints { make in
            make.edges.equalTo(webView)
        }
    }

}
