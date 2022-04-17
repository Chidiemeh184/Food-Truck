//
//  LoadingCell.swift
//  FoodTruck
//
//  Created by Chilly Bean on 4/16/22.
//

import UIKit

class LoadingCell: UITableViewCell {
    //MARK: - Class properties
    static let reuseID = "LoadingCell"
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Class Functions
    public func startAnimating() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    public func stopAnimating() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
