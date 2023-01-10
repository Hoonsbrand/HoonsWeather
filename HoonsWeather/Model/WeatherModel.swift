//
//  WeatherModel.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import UIKit

struct SomeDataModel {
    enum DataModelType: String {
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
    }
    
    let type: DataModelType
    
    var name: String {
        return type.rawValue
    }
    
    var iamge: UIImage {
        switch type {
        case .one: return UIImage(named: "01d")!
        case .two: return UIImage(named: "02d")!
        case .three: return UIImage(named: "03d")!
        case .four: return UIImage(named: "04d")!
        case .five: return UIImage(named: "09d")!
        case .six: return UIImage(named: "10d")!
        case .seven: return UIImage(named: "11d")!
        case .eight: return UIImage(named: "13d")!
        case .nine: return UIImage(named: "50d")!
        }
    }
    
}

struct Mocks {
    static func getDataSource() -> [SomeDataModel] {
        return [SomeDataModel(type: .one),
                SomeDataModel(type: .two),
                SomeDataModel(type: .three),
                SomeDataModel(type: .four),
                SomeDataModel(type: .five),
                SomeDataModel(type: .six)]
    }
}
