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
    
    let seatTimer = SeatTimerView()
    
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
        addSubview(seatTimer)
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
        seatTimer.snp.makeConstraints { make in
            make.top.equalTo(webView).inset(20)
            make.trailing.equalTo(webView).inset(40)
            make.size.equalTo(40)
        }
    }

}

class SeatTimerView: UIView {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black // ✅ 배경 색상 적용
        return view
    }()
    
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private let label = UILabel()
    
    var percentage: Int = 0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(backgroundView) // ✅ 배경 뷰 추가
        backgroundView.layer.cornerRadius = bounds.width / 2
        backgroundView.clipsToBounds = true // ✅ 원형 모양 유지
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                        radius: bounds.width / 2,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 1.5 * CGFloat.pi,
                                        clockwise: true)
        
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundLayer.lineWidth = 10
        backgroundLayer.fillColor = UIColor.clear.cgColor // ✅ 원 내부를 채우지 않음 (UIView로 대체)
        layer.addSublayer(backgroundLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.lineWidth = 10
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        
        gradientLayer.colors = [UIColor.systemPink.cgColor, UIColor.red.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.mask = progressLayer
        layer.addSublayer(gradientLayer)
        
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = min(bounds.width, bounds.height)
        
        backgroundView.frame = bounds
        backgroundView.layer.cornerRadius = size / 2
        
        backgroundLayer.frame = bounds
        progressLayer.frame = bounds
        gradientLayer.frame = bounds
        
        label.frame = CGRect(x: 0, y: 0, width: size, height: size)
        label.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func updateProgress() {
        let normalizedPercentage = max(0, min(percentage, 100)) / 100
        progressLayer.strokeEnd = CGFloat(normalizedPercentage)
        label.text = "\(percentage)"
    }
}

