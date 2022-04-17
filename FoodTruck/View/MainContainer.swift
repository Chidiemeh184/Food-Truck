//
//  MainContainer.swift
//  FoodTruck
//
//  Created by Chilly Bean on 4/16/22.
//

import UIKit

class MainContainer: UIViewController {
    //MARK: - Properties
    var isListShown = true
    let trucksViewModel = FoodTrucksViewModel()

    //MARK: - UI Properties
    let mainTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "Food Trucks"
        label.textAlignment = .center
    
        return label
    }()
    
    let switchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Map", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
        
        return button
    }()
    
    let mainVisibleArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    var listView: UIViewController = {
        let list = UIViewController()
        list.view.backgroundColor = .white

        return list
    }()
    
    var mapView: UIViewController = {
        let map = UIViewController()
        map.view.backgroundColor = .white
        
        return map
    }()
    
    //MARK: - UI Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    //MARK: - Class Functions
    func setUpViews() {
        /// Main View
        view.backgroundColor = .systemGray6
        
        /// Title
        view.addSubview(mainTitle)
        NSLayoutConstraint.activate([
            mainTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            mainTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            mainTitle.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        /// Button
        view.addSubview(switchButton)
        NSLayoutConstraint.activate([
            switchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            switchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            switchButton.widthAnchor.constraint(equalToConstant: 40),
            switchButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        /// Main Visible Area
        view.addSubview(mainVisibleArea)
        NSLayoutConstraint.activate([
            mainVisibleArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 82),
            mainVisibleArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainVisibleArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainVisibleArea.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        /// Setup Child ViewControllers
        self.mapView = MapListController(viewModel: trucksViewModel)
        self.listView = TrucksListController(viewModel: trucksViewModel)
        self.add(childViewController: mapView, to: mainVisibleArea)
        self.add(childViewController: listView, to: mainVisibleArea)
        handleSwitch()
    }
    
    @objc func handleSwitch() {
        isListShown = !isListShown
        if isListShown {
            showList()
        } else {
           showMap()
        }
    }
    
    private func showList() {
        switchButton.setTitle("Map", for: .normal)
        setView(view: mapView.view, hidden: false)
        setView(view: listView.view, hidden: true)
    }
    
    private func showMap() {
        switchButton.setTitle("List", for: .normal)
        setView(view: mapView.view, hidden: true)
        setView(view: listView.view, hidden: false)
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 1.2, options: .curveEaseOut, animations: {
            view.isHidden = hidden
        })
    }
}
