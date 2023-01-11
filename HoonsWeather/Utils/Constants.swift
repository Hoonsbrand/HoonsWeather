//
//  Constants.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/11.
//

import Foundation

enum API {
    // api key 은닉화
    static let CLIENT_ID: String = Bundle.main.OPENWEATHER_API_KEY
}

extension Bundle {
    var OPENWEATHER_API_KEY: String {
        guard let file = self.path(forResource: "OpenWeatherInfo", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["OPENWEATHER_API_KEY"] as? String else {
            fatalError("OPENWEATHER_API_KEY error")
        }
        return key
    }
}
