//
//  FutureTwoDaysWeatherCell.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/12.
//

import UIKit
import SnapKit

class FutureTwoDaysWeatherCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "지금"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var weatherImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "01d")
        return iv
    }()
    
    var tempLabel: UILabel = {
        let label = UILabel()
        label.text = "-1º"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        let stack = UIStackView(arrangedSubviews: [timeLabel, weatherImage, tempLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 2
        
        self.addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
}

extension FutureTwoDaysWeatherCell: ReusableView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
