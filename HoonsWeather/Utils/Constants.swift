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
    
    static func getURL(lat: Double, lon: Double) -> String {
        return "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&lang=kr&appid=\(API.CLIENT_ID)&units=metric"
    }
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

//https://api.openweathermap.org/data/2.5/forecast?q=Gorkhā&appid=5b1ea9cdb850fd6e64033474744e8eb7&units=metric
//https://api.openweathermap.org/data/2.5/forecast?q=Gorkhā&appid=5b1ea9cdb850fd6e64033474744e8eb7&units=metric
