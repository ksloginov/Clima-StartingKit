//
//  WeatherViewModel.swift
//  Clima
//
//  Created by Konstantin Loginov on 23.09.2021.
//

import Foundation
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var searchQuery: String = ""
    @Published var favoriteCities: [String] = [] {
        didSet {
            UserDefaults.standard.set(favoriteCities, forKey: "cities")
        }
    }
    
    
    @Published var weatherCondition: WeatherCondition?
    
    private var dataService: DataService = DataService()
    private var locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
   
        favoriteCities = (UserDefaults.standard.array(forKey: "cities") as? [String]) ?? []
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            loadLocalWeather(latitude: location.coordinate.latitude,
                             longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func isFavoriteCity() -> Bool {
        if favoriteCities.map({$0.lowercased()}).contains(searchQuery.lowercased()) {
            return true
        }
        
        return false
    }
    
    func loadWeatherBySearchQuery(_ query: String) {
        if query.count < 2 {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if self?.searchQuery == query {
                self?.dataService.loadWeather(for: query) { [weak self] result in
                    self?.handleWeather(result: result)
                }
            }
        }
    }
    
    func loadLocalWeather(latitude: Double?, longitude: Double?) {
        guard let latitude = latitude, let longitude = longitude else { return }
        
        dataService.loadLocalWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            self?.handleWeather(result: result)
        }
    }
    
    private func handleWeather(result: Result<WeatherCondition?, Error>) {
        switch result {
        case .success(let condition):
            DispatchQueue.main.async { [weak self] in
                self?.weatherCondition = condition
            }
        case .failure(let error):
            print(error)
        }
    }
}
