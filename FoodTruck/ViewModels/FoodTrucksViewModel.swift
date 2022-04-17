//
//  FoodTrucksViewModel.swift
//  FoodTruck
//
//  Created by Chilly Bean on 4/15/22.
//

import Foundation
import UIKit
import Combine

final class FoodTrucksViewModel: ObservableObject {
    //MARK: - Class Properties
    private let foodTrucksService: APIServiceType
    private let filter: FilterTrucks = .openNow
    private let defaultPath: String = "jjew-r69b.json"
    
    //MARK: - Published Properties
    @Published var trucks: [FoodTruck] = [FoodTruck]()
    
    //MARK: - Initializers
    init(foodTruckService: APIServiceType = FoodTrucksAPIService()) {
        self.foodTrucksService = foodTruckService
    }
    
    //MARK: - Fetch Trucks
    public func fetchTrucks(with queryItems: [URLQueryItem]?, completion: @escaping ([FoodTruck])-> Void ) {
        let endPoint = FoodTruckListRequest(path: defaultPath, queryItems: queryItems)
        foodTrucksService.fetchTrucks(from: endPoint) { [weak self] result in
            switch result {
            case .success(let foodTrucks):
                switch self?.filter {
                case .openNow:
                    if let currentlyOpenFoodTrucks = self?.processFoodTruck(trucks: foodTrucks) {
                        self?.trucks = currentlyOpenFoodTrucks
                        completion(currentlyOpenFoodTrucks)
                    } else {
                        completion([])
                    }
                case .all:
                    self?.trucks = foodTrucks
                    completion(foodTrucks)
                case .none:
                    completion([])
                }

            case .failure(let error):
                print("Error - \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    //MARK: - Helper Functions
    /// Helper Function to Process the Food Trucks to filter the ones Opened Now
    private func processFoodTruck(trucks: [FoodTruck]) -> [FoodTruck] {
        //MARK: - Filter by Current Time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current

        /// Filter opened within last hour
        var temp: [FoodTruck] = []
        let _ = trucks.map({ truck -> [FoodTruck] in
            let todayDateFormatter = DateFormatter()
            todayDateFormatter.dateFormat = "yyyy-MM-dd"
            todayDateFormatter.locale = Locale.current
            todayDateFormatter.timeZone = TimeZone.current
            let todayString = todayDateFormatter.string(from: Date())
            
            let openingTime = truck.end24 ?? "6:00"
            let fullTodaysDateString = "\(todayString) \(openingTime)"
            
            let finalFormatter = DateFormatter()
            finalFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            finalFormatter.locale = Locale.current
            finalFormatter.timeZone = TimeZone.current
            
            let foodTruckOpeningTime = finalFormatter.date(from: fullTodaysDateString)
            var tempTruck = truck
            tempTruck.date = foodTruckOpeningTime
            
            let now = Date.now
            let tomorrow = Date.now.addingTimeInterval(86400)
            let range = now...tomorrow
            
            if let availableTime = foodTruckOpeningTime {
                if range.contains(availableTime) {
                    temp.append(tempTruck)
                }
            }
            return temp
        })
        return temp
    }
}

//MARK: - Filtering Enum
enum FilterTrucks: Int {
    case openNow
    case all
}
