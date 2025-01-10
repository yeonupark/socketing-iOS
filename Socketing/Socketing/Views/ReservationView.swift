//
//  ReservationView.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/09.
//

import UIKit
import WebKit

class ReservationView: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 24)
        view.textAlignment = .center
        view.text = "예매페이지"
        
        return view
    }()
    
    let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func configure() {
        super.configure()
        
        addSubview(titleLabel)
        addSubview(webView)
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).inset(80)
            make.height.equalTo(30)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

}
