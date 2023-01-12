//
//  CityListModel.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import Foundation

// MARK: - JSON 파일을 파싱한 모델
struct CityModel: Codable {
    let name, country: String
    let coord: Coordination
}

struct Coordination: Codable {
    let lon, lat: Double
}



typealias CityList = [CityModel]






