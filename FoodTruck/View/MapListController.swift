//
//  MapListController.swift
//  FoodTruck
//
//  Created by Chilly Bean on 4/16/22.
//

import UIKit
import MapKit
import Combine

class MapListController: UIViewController {
    //MARK: - Class Properties
    var trucks: [FoodTruck] = []
    var viewModel: FoodTrucksViewModel?
    private var cancellableBag = Set<AnyCancellable>()
    
    //MARK: - UI Properties
    let mapList: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        
        return map
    }()
    
    let cell: TruckCell = {
       let truckView = TruckCell()
        truckView.contentView.translatesAutoresizingMaskIntoConstraints = false
        return truckView
    }()
    
    let defaultMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Tap icon for more info and zoom in to see more places"
        label.textAlignment = .left
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    //MARK: - Initializers
    public init(viewModel: FoodTrucksViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
      
        viewModel.$trucks
            .sink { [weak self] newFoodTrucks in
                /// Just getting the new different ones
                self?.trucks.append(contentsOf: newFoodTrucks)
                self?.loadAnnotations(newTrucks: newFoodTrucks)
            }
            .store(in: &cancellableBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    //MARK: - Class functions
    func setUpViews() {
        view.addSubview(mapList)
        mapList.center = view.center
        mapList.delegate = self
        NSLayoutConstraint.activate([
            mapList.topAnchor.constraint(equalTo: view.topAnchor),
            mapList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapList.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        view.addSubview(cell.contentView)
        NSLayoutConstraint.activate([
            cell.contentView.topAnchor.constraint(equalTo: mapList.bottomAnchor, constant:  20),
            cell.contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            cell.contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2),
            cell.contentView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        view.addSubview(defaultMessage)
        NSLayoutConstraint.activate([
            defaultMessage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            defaultMessage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            defaultMessage.topAnchor.constraint(equalTo: mapList.bottomAnchor, constant: 30),
            defaultMessage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    private func addAnnotations(places: [MKPointAnnotation]) {
        mapList.addAnnotations(places)
    }
    
    private func loadAnnotations(newTrucks: [FoodTruck]) {
        var tempList: [MKAnnotation] = []
        for place in newTrucks {
            tempList.append(TruckMapCell(place: place))
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.mapList.showAnnotations(tempList, animated: true)
        }
    }
}

//MARK: - MKMapViewDelegate
extension  MapListController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is TruckMapCell else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: TruckMapCell.reuseID)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: TruckMapCell.reuseID)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let truck = (view.annotation as? TruckMapCell)?.truck {
            self.defaultMessage.isHidden = true
            self.cell.setUp(with: truck)
        }
    }
}
