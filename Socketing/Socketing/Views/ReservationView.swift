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
    
    init(configuration: WKWebViewConfiguration) {
        super.init(frame: .zero)
        
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeWebView(configuration: WKWebViewConfiguration) {
            webView = WKWebView(frame: .zero, configuration: configuration)
            webView.translatesAutoresizingMaskIntoConstraints = false
        }
    
    func configure() {
        backgroundColor = .white
        
        addSubview(infoView)
        addSubview(webView)
    }
    
    func setConstraints() {
        infoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

}
