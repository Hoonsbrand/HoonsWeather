//
//  TimeService.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/12.
//

import Foundation

struct TimeService {
    static let shared = TimeService()
    
    func getOnlyNowAndFuture(dateString: String) -> Bool {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.timeZone = TimeZone(identifier: "KST")

        let startTime = format.date(from: Date().toString())
        let endTime = format.date(from: dateString)

        let useTime = Int(endTime!.timeIntervalSince(startTime!))

        if useTime >= -3600 && useTime < 172800 {
            return true
        } else {
            return false
        }
    }
    
    func getKoreaTime(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "a hh시"
        myDateFormatter.locale = Locale(identifier: "ko_KR")
        let convertStr = myDateFormatter.string(from: date)
        
        return convertStr
    }
}
