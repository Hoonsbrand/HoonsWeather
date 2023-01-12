//
//  SelectedWeatherViewModel.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/11.
//

import UIKit

struct SelectedWeatherViewModel {
    
    private let weatherData: WeatherData
    
    // 도시이름
    var cityname: String {
        return weatherData.city.name
    }

    // 현재온도
    var temperature: String {
        return "\(weatherData.list[0].main.temp)º"
    }

    // 현재날씨 설명
    var weatherDescription: String {
        return weatherData.list[0].weather[0].description
    }

    // 최고최저 온도
    var minMaxTemp: String {
        return "최고: \(self.maximumTemp)º | 최저: \(self.minimumTemp)º"
    }
    
    // 최고온도
    private var maximumTemp: Double {
        return weatherData.list[0].main.tempMax
    }

    // 최저온도
    private var minimumTemp: Double {
        return weatherData.list[0].main.tempMin
    }
    
    // 최대풍속
    var maxSpeed: Double {
        return weatherData.list[0].wind.speed
    }

    // 3시간 간격 온도
    var threeHourTemp: [String] {
        var tempArr = [String]()
        weatherData.list.forEach {
            tempArr.append(String("\($0.main.temp)º"))
        }

        return tempArr
    }
    
    // 현재 온도에 따른 날씨 상황 -> CollectionView에서 UIImage로 표시
    var conditionName: [String] {
        var conditionIntArr = [Int]()
        var conditionStringResultArr = [String]()
        
        weatherData.list.forEach {
            $0.weather.forEach {
                conditionIntArr.append($0.id)
            }
        }
        
        conditionIntArr.forEach {
            switch $0 {
            case 200...232:
                conditionStringResultArr.append("11d")
            case 300...321:
                conditionStringResultArr.append("09d")
            case 500...531:
                conditionStringResultArr.append("10d")
            case 600...622:
                conditionStringResultArr.append("13d")
            case 701...781:
                conditionStringResultArr.append("5d")
            case 800:
                conditionStringResultArr.append("01d")
            case 801...804:
                conditionStringResultArr.append("02d")
            default:
                conditionStringResultArr.append("03d")
            }
        }
        return conditionStringResultArr
    }
    
    // 3시간 간격 시간
    /// TODO: 시간 계산해서 한국시간으로 3시간 간격으로 보여줘야함
    var weatherTime: [String] {
        var timeArr = [String]()
        
        weatherData.list.forEach {
            timeArr.append($0.dtTxt)
        }
        
        return timeArr
    }

    init(weatherData: WeatherData) {
        self.weatherData = weatherData
    }
}

