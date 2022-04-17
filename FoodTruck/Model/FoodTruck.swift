//
//  FoodTruck.swift
//  FoodTruck
//
//  Created by Chilly Bean on 4/15/22.
//

import Foundation

/// Food Truck Model
struct FoodTruck: Codable {
    var dayorder: String?
    var dayofweekstr: String?
    var starttime: String?
    var endtime: String?
    var permit: String?
    var location: String?
    var locationdesc: String?
    var optionaltext: String?
    var locationid: String?
    var start24: String?
    var end24: String?
    var cnn: String?
    var addrDateCreate: String?
    var addrDateModified: String?
    var block: String?
    var lot: String?
    var coldtruck: String?
    var applicant: String?
    var x: String?
    var y: String?
    var latitude: String?
    var longitude: String?
    var location2: LocationTwo?
    var date: Date?
    
    enum CodingKeys: String, CodingKey {
        case dayorder
        case dayofweekstr
        case starttime
        case endtime
        case permit
        case location
        case locationdesc
        case optionaltext
        case locationid
        case start24
        case end24
        case cnn
        case addrDateCreate = "addr_date_create"
        case addrDateModified = "addr_date_modified"
        case block
        case lot
        case coldtruck
        case applicant
        case x
        case y
        case latitude
        case longitude
        case location2 = "location_2"
        case date
    }
}

/// Location_2 Model
struct LocationTwo: Codable {
    var latitude: String
    var longitude: String
    var humanAddress: String
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case humanAddress = "human_address"
    }
}

//MARK: - Equatable
extension FoodTruck: Equatable {
    static func ==(lhs: FoodTruck, rhs: FoodTruck) -> Bool {
        return lhs.locationid == rhs.locationid && lhs.cnn == rhs.cnn
    }
}

//MARK: - Hashable
extension FoodTruck: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(locationid)
    }
}

///Reference
/// Source: https://dev.socrata.com/foundry/data.sfgov.org/bbb8-hzi6
/*
"dayorder": "6",
"dayofweekstr": "Saturday",
"starttime": "9AM",
"endtime": "4PM",
"permit": "18MFF-0034",
"location": "560 VALENCIA ST",
"locationdesc": "Cart located between trees south of entrance to 560 Valencia St.",
"optionaltext": "Chai Tea",
"locationid": "1174530",
"start24": "09:00",
"end24": "16:00",
"cnn": "13060000",
"addr_date_create": "2011-06-28T12:25:38.000",
"addr_date_modified": "2011-06-28T12:26:10.000",
"block": "3568",
"lot": "009",
"coldtruck": "N",
"applicant": "CC Acquisition LLC",
"x": "6006163.78837",
"y": "2106331.57764",
"latitude": "37.763933721963348",
"longitude": "-122.42186162805514",
"location_2": {
    "latitude": "37.76393372196335",
    "longitude": "-122.42186162805514",
    "human_address": "{\"address\": \"\", \"city\": \"\", \"state\": \"\", \"zip\": \"\"}"
}
*/
