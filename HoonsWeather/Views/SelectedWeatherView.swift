//
//  CurrentLocationWeatherView.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import UIKit
import SnapKit
import Alamofire

final class SelectedWeatherView: UIView {
    
    // MARK: - Properties
    
    // 도시 label
    lazy var cityLabel: UILabel = {
        return self.makeLabel(fontSize: 40, text: "")
    }()
    
    // 온도 label
    lazy var temperatureLabel: UILabel = {
        return self.makeLabel(fontSize: 70, text: "")
    }()
    
    // 날씨 label
    lazy var weatherDescribeLabel: UILabel = {
        return self.makeLabel(fontSize: 30, text: "")
    }()
    
    // 최고, 최저기온 label
    lazy var maximumMinimumTempLabel: UILabel = {
        return self.makeLabel(fontSize: 25, text: "")
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    /// label 만드는 메서드
    private func makeLabel(fontSize: CGFloat, text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.text = text
        label.textColor = .white
        return label
    }
    
    /// StackView 세팅
    private func setStackView() {
        self.backgroundColor = .clear
        let tempStack = UIStackView(arrangedSubviews: [weatherDescribeLabel, maximumMinimumTempLabel])
        tempStack.axis = .vertical
        tempStack.alignment = .center
        tempStack.spacing = 2
        
        let stack = UIStackView(arrangedSubviews: [cityLabel, temperatureLabel, tempStack])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 4
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
}
