//
//  APIService.swift
//  FoodTruck
//
//  Created by Chilly Bean on 4/15/22.
//

import Foundation

protocol APIServiceType {
    var session: URLSession {get}
    var baseURL: String {get}
    var bgQueue: DispatchQueue {get}
    func fetchTrucks<T: APIRequestType>(from endpoint: T, completion: @escaping (Result<T.ModelType, Error>) -> Void)
}

