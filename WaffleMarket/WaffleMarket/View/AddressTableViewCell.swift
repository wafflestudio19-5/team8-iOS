//
//  AddressTableViewCell.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/23.
//

import Foundation
import UIKit
class AddressTableViewCell: UITableViewCell {
    private let addressLabel = UILabel()
    private var address: Address?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("cellinit")
        
        self.contentView.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        addressLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setData(address: Address){
        self.address = address
        addressLabel.text = address.name;
    }
}
