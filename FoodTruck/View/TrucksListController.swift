//
//  ViewController.swift
//  FoodTruck
//
//  Created by Chilly Bean on 4/14/22.
//

import UIKit

class TrucksListController: UIViewController {
    //MARK: - Properties 
    var viewModel: FoodTrucksViewModel?
    let limit = 20
    var offset = 0
    var trucks: [FoodTruck] = []
    var isLoading = false
    
    weak var delegate: ItemSelectedDelegate? = nil
    
    //MARK: - UI Properties
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false

        return table
    }()
    
    //MARK: - Initializers
    public init(viewModel: FoodTrucksViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    public func setDelegate(delegate: ItemSelectedDelegate) {
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadData()
    }
    
    //MARK: - Class Functions
    func setUpViews() {
        /// TableView
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 40
        tableView.register(TruckCell.self, forCellReuseIdentifier: TruckCell.reuseID)
        tableView.register(UINib(nibName: LoadingCell.reuseID, bundle: nil), forCellReuseIdentifier: LoadingCell.reuseID)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func fetchTruck() {
        offset = offset + limit
        loadData()
    }

    //MARK: - Load With Query
    func loadData() {
        /// Hard Coded San Fransico but could possibly use an enum for location choice
        let withinLocation = URLQueryItem(name: "$where", value: "within_circle(location_2, 37.7749, -122.4194, 100000)")
        let limit = URLQueryItem(name: "$limit", value: "\(limit)")
        let dayOfWeek = URLQueryItem(name: FoodTruck.CodingKeys.dayofweekstr.rawValue, value: DayOfWeek.sunday.rawValue)
        let offset = URLQueryItem(name: "$offset", value: "\(offset)")
        let query = [limit, offset, dayOfWeek, withinLocation]
        
        ///Uncomment to Query Defaults
        /*
        let dayOfWeek = URLQueryItem(name: FoodTruck.CodingKeys.dayofweekstr.rawValue, value: DayOfWeek.saturday.rawValue)
        let limit = URLQueryItem(name: "$limit", value: "\(limit)")
        let offset = URLQueryItem(name: "$offset", value: "\(offset)")
        let query = [limit, offset, dayOfWeek]
         */
        
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async { [weak self] in
                sleep(2)
                self?.viewModel?.fetchTrucks(with: query) { [weak self] trucks in
                    DispatchQueue.main.async {
                        let newUniques = trucks.unique
                        self?.trucks.append(contentsOf: newUniques)
                        self?.tableView.reloadData()
                        self?.isLoading = false
                    }
                }
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension TrucksListController: UITableViewDelegate {
    // MARK: - Infinite Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && !isLoading {
           fetchTruck()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = trucks[indexPath.row]
        delegate?.didSelect(item: selectedItem)
    }
}

//MARK: - UITableViewDatasource
extension TrucksListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = TruckListSection(rawValue: section) else { return 0 }
       
        switch section {
        case .truckList:
            return trucks.count
        case .loader:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TruckListSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .truckList:
            let cell = tableView.dequeueReusableCell(withIdentifier: TruckCell.reuseID, for: indexPath) as! TruckCell
            cell.selectionStyle = .none
            cell.setUp(with: trucks[indexPath.row])
            return cell
        case .loader:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseID, for: indexPath) as! LoadingCell
            cell.startAnimating()
            cell.selectionStyle = .none
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                cell.stopAnimating()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = TruckListSection(rawValue: indexPath.section) else { return .leastNormalMagnitude }
        
        switch section {
        case .truckList: return UITableView.automaticDimension
        case .loader: return 44
        }
    }
}


//MARK: - Truck List Sections
enum TruckListSection: Int {
    case truckList
    case loader
}

enum DayOfWeek: String {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
}

