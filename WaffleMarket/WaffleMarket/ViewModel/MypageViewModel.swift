//
//  MypageViewModel.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/07.
//

import Foundation
import UIKit

enum MypageViewModelItemType {
    case profile
    case imageButton
}
protocol MypageViewModelItem {
    var type: MypageViewModelItemType { get }
    
}
class MypageViewModel: NSObject {
    var items = [MypageViewModelItem]()
    func setItems(_ items: [MypageViewModelItem]){
        self.items = items
    }
}
extension MypageViewModel: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        switch item.type {
        case .imageButton:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MypageImageButtonCell.identifier, for: indexPath) as? MypageImageButtonCell {
                cell.item = item
                return cell
            }
        case .profile:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MypageProfileCell.identifier, for: indexPath) as? MypageProfileCell {
                cell.item = item
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        switch item.type {
        case .imageButton:
            return 50
        case .profile:
            return 300
        }
    }
}

class MypageViewModelImageButtonItem: MypageViewModelItem {
    let image: UIImage
    let title: String
    let onClick: (()->Void)
    var type: MypageViewModelItemType {
        return .imageButton
    }
    init(image: UIImage, title: String, onClick:@escaping (()->Void)){
        self.image = image
        self.title = title
        self.onClick = onClick
    }
}

class MypageViewModelProfileItem: MypageViewModelItem {
    var type: MypageViewModelItemType {
        return .profile
    }
}
