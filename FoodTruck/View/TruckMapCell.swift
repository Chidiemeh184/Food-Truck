//
//  TruckMapCell.swift
//  FoodTruck
//
//  Created by Chilly Bean on 4/17/22.
//

import UIKit
import MapKit

class TruckMapCell: NSObject, MKAnnotation {
    //MARK: - Class Properties
    static let reuseID = "Annotation"
    /// Adding this as default will remove in production
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.76, -122.42)
    var title: String?
    var subtitle: String?
    
    var truck: FoodTruck?
    var point: MKPointAnnotation?
    
    //MARK: - Initializars
    init(place: FoodTruck) {
        var descriptionString = ""
        descriptionString.append(place.applicant ?? "Unavailable")
        let annotation = MKPointAnnotation()
        annotation.title = descriptionString
        let subtitle = "\(place.starttime ?? "") - \(place.endtime ?? "")"
        annotation.subtitle = subtitle
        
        if let latitude = place.latitude,
           let longitude = place.longitude {
            let coordinate = CLLocationCoordinate2D(
                latitude: Double(latitude) ?? 0.00, longitude: Double(longitude) ?? 0.00)
            self.coordinate = coordinate
            annotation.coordinate = coordinate
            self.point = annotation
            
            self.title = descriptionString
            self.subtitle = subtitle
            self.truck = place
        }
    }

}
