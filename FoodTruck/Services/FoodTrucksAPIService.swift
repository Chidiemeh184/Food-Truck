//
//  FoodTrucksAPIService.swift
//  FoodTruck
//
//  Created by Chilly Bean on 4/15/22.
//

import Foundation

final class FoodTrucksAPIService: APIServiceType {
    //MARK: - Class Properties
    var baseURL: String
    var session: URLSession = URLSession.shared
    var bgQueue: DispatchQueue = DispatchQueue.main
    
    //MARK: - Initializers
    init(baseURL: String = "https://data.sfgov.org/resource/") {
        self.baseURL = baseURL
    }
    
    //MARK: - Class Functions
    func fetchTrucks<T>(from endpoint: T, completion: @escaping (Result<T.ModelType, Error>) -> Void) where T : APIRequestType {
        do  {
            let request = try endpoint.buildRequest(baseURL: baseURL)
            session.dataTask(with: request) { data, response, error in
                /// Error
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                /// Response
                guard let code = (response as? HTTPURLResponse)?.statusCode else {
                    completion(.failure(APIServiceError.unexpectedResponse))
                    return
                }
                guard HTTPCodes.success.contains(code) else {
                    completion(.failure(APIServiceError.httpError(code)))
                    return
                }
                
                /// Data
                guard let data = data else {
                    completion(.failure(APIServiceError.unexpectedResponse))
                    return
                }
                
                do {
                    /// Parse the JSON data
                    let resultFetch = try JSONDecoder().decode(T.ModelType.self, from: data)
                    completion(.success(resultFetch))
                } catch let error {
                    print("Parsing Error - \(error)")
                    completion(.failure(APIServiceError.parseError))
                }
            }.resume()
        } catch let error {
            completion(.failure(error))
        }
    }
}
