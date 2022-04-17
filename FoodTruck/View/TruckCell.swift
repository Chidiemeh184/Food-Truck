//
//  TruckCell.swift
//  FoodTruck
//
//  Created by Chilly Bean on 4/16/22.
//

import UIKit

class TruckCell: UITableViewCell {
    
    //MARK: - Class Properties
    static let reuseID = "TruckCell"
    private var truck: FoodTruck?
    
    //MARK: - UI Properties
    let mainTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = " "
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()

    let address: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = " "
        label.textAlignment = .left
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    let bodyText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = " "
        label.textAlignment = .left
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    let time: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = " "
        label.textAlignment = .center
        label.textColor = .label
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Class functions
    public func setUp(with truck: FoodTruck) {
        mainTitle.text = truck.applicant ?? "Unknown"
        address.text = truck.location ?? "Location unavailable"
        bodyText.text = truck.locationdesc ?? "Description unavailable"
        time.text = "\(truck.starttime ?? "") - \(truck.endtime ?? "")"
    }
    
    private func setUpViews() {
        ///VStack
        let vStack1 = UIStackView()
        vStack1.translatesAutoresizingMaskIntoConstraints = false
        vStack1.axis = .vertical
        vStack1.distribution = .fillProportionally
        vStack1.spacing = 5
        vStack1.alignment = .leading
        
        vStack1.addArrangedSubview(mainTitle)
        vStack1.addArrangedSubview(address)
        vStack1.addArrangedSubview(bodyText)
        
        contentView.addSubview(vStack1)
        NSLayoutConstraint.activate([
            vStack1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            vStack1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            vStack1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            vStack1.widthAnchor.constraint(equalToConstant: 268),
            bodyText.widthAnchor.constraint(equalToConstant: 268)
        ])
        
        let vStack2 = UIStackView()
        vStack2.translatesAutoresizingMaskIntoConstraints = false
        vStack2.axis = .vertical
        vStack2.distribution = .fill
        vStack2.alignment = .center
        
        vStack2.addArrangedSubview(time)
        
        contentView.addSubview(vStack2)
        NSLayoutConstraint.activate([
            vStack2.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStack2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            vStack2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vStack2.leadingAnchor.constraint(equalTo: vStack1.trailingAnchor)
        ])
    }
}
