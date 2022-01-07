//
//  MypageProfileCell.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/07.
//

import Foundation
import UIKit
class MypageProfileCell: UITableViewCell {
    static let identifier = "MypageProfileCell"
    var item: MypageViewModelItem? {
        didSet {
            guard let item = item as? MypageViewModelProfileItem else { return }
            
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
