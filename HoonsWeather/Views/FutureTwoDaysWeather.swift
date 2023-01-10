//
//  BaseScrollView.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import UIKit

class FutureTwoDaysWeather: UIScrollView {
    
    var dataSource: [SomeDataModel]? {
        didSet { bind() }
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16.0
        view.backgroundColor = .separator
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        showsHorizontalScrollIndicator = false
        bounces = false
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview() /// 이 값이 없으면 scroll 안되는 것 주의
            make.top.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        dataSource?.forEach { data in
            let button = UIButton()
            button.setTitleColor(.blue, for: .normal)
            button.setTitle(data.name, for: .normal)
            button.setImage(data.iamge, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -4.0, bottom: 0.0, right: 0.0)
            
            stackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(42)
            }
        }
    }
}
