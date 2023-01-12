//
//  AlamofireManager.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/11.
//

import Foundation
import Alamofire

struct AlamofireManger {
    static let shared = AlamofireManger()
    
    /// 위도와 경도를 이용해 날씨 데이터를 넘겨주는 메서드 (기본값은 대한민국의 Asan)
    func fetchCurrentTempWithLatAndLon(inputLat: Double? = nil, inputLon: Double? = nil, completion: @escaping (WeatherData) -> Void) {
        var lat, lon: Double?
        
        if inputLat == nil { lat = 36.783611 } else { lat = inputLat! }
        if inputLon == nil { lon = 127.004173 } else { lon = inputLon! }

        let url = API.getURL(lat: lat!, lon: lon!)
        let request = AF.request(url)
        request.validate().responseDecodable(of: WeatherData.self) { response in
            switch response.result {
            case .success(let weather): completion(weather)
            case .failure(let error): print("DEBUG: ERROR: \(error)")
            }
        }
    }
}

