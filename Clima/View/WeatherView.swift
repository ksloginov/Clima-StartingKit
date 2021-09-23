//
//  ContentView.swift
//  Clima
//
//  Created by Konstantin Loginov on 22.09.2021.
//

import SwiftUI


// https://api.openweathermap.org/data/2.5/weather?q=Oslo&appid=9067ea08c6a8b9bce1efaf060de4246c&units=metric
struct WeatherView: View {
    
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack(alignment: .trailing) {
            header
            
            if let weatherCondition = viewModel.weatherCondition {
                VStack(alignment: .trailing) {
                    Image(systemName: weatherCondition.conditionName)
                        .resizable()
                        .frame(width: 120.0, height: 120.0)
                    HStack {
                        Text(weatherCondition.temparatureString)
                            .font(.system(size: 64.0, weight: .heavy, design: .rounded))
                        Text("°C")
                            .font(.system(size: 64.0, weight: .medium, design: .rounded))
                    }
                    Text(weatherCondition.cityName)
                        .font(.title)
                }
                .padding(.top, 15.0)
            }
            
            Spacer()
            
            ForEach(viewModel.favoriteCities, id: \.self) { city in
                Button {
                    viewModel.searchQuery = city
                } label: {
                    Text(city)
                        .font(.system(size: 32.0, weight: .heavy, design: .rounded))
                }

            }
        }
        .padding()
        .foregroundColor(Color("textColor"))
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        
        )
    }
    
    var header: some View {
        HStack(spacing: 15.0) {
            Button {
                viewModel.requestLocation()
            } label: {
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .frame(width: 48.0, height: 48.0)
            }

            TextField("Search for city", text: $viewModel.searchQuery)
                .font(.title2)
                .onChange(of: viewModel.searchQuery) { newValue in
                    viewModel.loadWeatherBySearchQuery(newValue)
                }

            if viewModel.searchQuery.count >= 2 {
                Button {
                    if let index = viewModel.favoriteCities.firstIndex(where: {
                        $0.lowercased() == viewModel.searchQuery.lowercased()
                    }) {
                        viewModel.favoriteCities.remove(at: index)
                    } else {
                        viewModel.favoriteCities.append(viewModel.searchQuery)
                    }
                } label: {
                    Image(systemName: viewModel.isFavoriteCity() ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 48.0, height: 48.0)
                }
            }
        }
    }
}
