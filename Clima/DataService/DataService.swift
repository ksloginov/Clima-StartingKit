//
//  DataService.swift
//  Clima
//
//  Created by Konstantin Loginov on 22.09.2021.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case misformattedUrl
    case dataLoadFailed
}

extension String {
    var encoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? self
    }
}

struct DataService {
    
    private let host = "https://api.openweathermap.org/data/2.5/weather"
    
    func loadWeather(for city: String, complition: @escaping (Result<WeatherCondition?, Error>) -> Void) {
        let query = "?q=\(city.encoded)&appid=9067ea08c6a8b9bce1efaf060de4246c&units=metric"

        guard let url = URL(string: host + query) else {
            complition(.failure(NetworkError.misformattedUrl))
            return
        }
     
        performRequest(url, complition)
    }
    
    func loadLocalWeather(latitude: Double, longitude: Double, complition: @escaping (Result<WeatherCondition?, Error>) -> Void) {
        let query = "?lat=\(latitude)&lon=\(longitude)&appid=9067ea08c6a8b9bce1efaf060de4246c&units=metric"
        
        guard let url = URL(string: host + query) else {
            complition(.failure(NetworkError.misformattedUrl))
            return
        }
        
        performRequest(url, complition)
    }
    
    private func performRequest(_ url: URL, _ complition: @escaping (Result<WeatherCondition?, Error>) -> Void) {
        
        // TODO: change URLSession.shared.dataTask to AF-alamofire
        // Tutorial:  https://www.raywenderlich.com/6587213-alamofire-5-tutorial-for-ios-getting-started
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                complition(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
                    guard let conditionId = decodedData.weather.first?.id else {
                        complition(.failure(NetworkError.dataLoadFailed))
                        return
                    }
                    
                    let result = WeatherCondition(conditionId: conditionId,
                                                  cityName: decodedData.name,
                                                  temparature: decodedData.main.temp)
                    complition(.success(result))
                } catch {
                    complition(.failure(error))
                }
            }
            
            
        }.resume()
    }
    
    // ?q=Oslo&appid=<insertkey>&units=metric
    // ?lat=\(latitude)&lon=\(longitude)&appid=<insertkey>&units=metric
    
}
