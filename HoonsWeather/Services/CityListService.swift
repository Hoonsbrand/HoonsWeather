//
//  CityListService.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import Foundation

struct CityListService {
    static let shared = CityListService()
    
    /// 도시 데이터 Fetching
    func fetchCityList(completion: @escaping (CityList) -> Void) {
        guard let path = Bundle.main.path(forResource: "citylist", ofType: "json") else { return }
        
        guard let jsonString = try? String(contentsOfFile: path) else { return }
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        if let data = data,
           let city = try? decoder.decode(CityList.self, from: data) {
            completion(city)
        }
    }
}
