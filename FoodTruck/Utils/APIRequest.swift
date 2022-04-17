//
//  APIRequest.swift
//  FoodTruck
//
//  Created by Chilly Bean on 4/15/22.
//

import Foundation

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

protocol APIRequestType {
    associatedtype ModelType: Decodable
    var path: String {get}
    var method: RequestMethod {get}
    var headers: [String: String]? {get}
    var queryItems: [URLQueryItem]? {get}
    func body() throws -> Data?
}

extension APIRequestType {
    func buildRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIServiceError.invalidURL
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}

struct FoodTruckListRequest: APIRequestType {
    typealias ModelType = [FoodTruck]
    
    var path: String
    var method: RequestMethod { return .get }
    var headers: [String: String]? { return ["Content-Type": "application/json"] }
    var queryItems: [URLQueryItem]?
    func body() throws -> Data? {
        return Data()
    }
}
