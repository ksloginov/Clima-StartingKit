//
//  WeatherCondition.swift
//  Clima
//
//  Created by Konstantin Loginov on 22.09.2021.
//

import Foundation

struct WeatherCondition {
    
    let conditionId: Int
    let cityName: String
    let temparature: Double
    
    var temparatureString: String {
        // 11.666666 -> 11.6
        return String(format: "%.1f", temparature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
