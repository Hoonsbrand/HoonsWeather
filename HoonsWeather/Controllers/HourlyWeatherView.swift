//
//  HourlyWeatherController.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import UIKit
import SnapKit

final class HourlyWeatherView: UIView {
    
    // MARK: - Properties
    
    var describeLabel: UILabel = {
        let label = UILabel()
        label.text = "돌풍의 풍속은 최대 4m/s입니다."
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.snp.makeConstraints {
            $0.height.equalTo(1.0)
        }
        return view
    }()
    
    lazy var futureTwoDaysWeahter: FutureTwoDaysWeather = {
        let view = FutureTwoDaysWeather()
        return view
    }()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.2996364236, green: 0.4886600375, blue: 0.735879004, alpha: 1)
        insertDataSource()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        let stack = UIStackView(arrangedSubviews: [describeLabel, divider, futureTwoDaysWeahter])
        addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillProportionally
        
        stack.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
    
    private func insertDataSource() {
        futureTwoDaysWeahter.dataSource = Mocks.getDataSource()
    }
    
}






