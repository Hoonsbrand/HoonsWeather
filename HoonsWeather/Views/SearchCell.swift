//
//  SearchCell.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import UIKit
import SnapKit

final class SearchCell: UITableViewCell {
    
    // MARK: - Properties
    
    // 도시이름 label
    lazy var cityName: UILabel = {
        return self.makeLabel(font: .boldSystemFont(ofSize: 18))
    }()

    // 나라이름 label
    lazy var countryName: UILabel = {
        return self.makeLabel(font: .systemFont(ofSize: 14))
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
//        self.backgroundColor = #colorLiteral(red: 0.4146796465, green: 0.5725354552, blue: 0.7671923041, alpha: 1)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        let stack = UIStackView(arrangedSubviews: [cityName, countryName])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        
        self.addSubview(stack)
        stack.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.left.equalTo(self).offset(20)
        }
    }
    
    private func makeLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = .white
        return label
    }
}

// MARK: - ReuseIdentifier

extension SearchCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

