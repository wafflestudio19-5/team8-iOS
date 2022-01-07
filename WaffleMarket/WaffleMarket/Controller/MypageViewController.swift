//
//  MypageViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/05.
//

import Foundation
import UIKit
class MypageViewController: UIViewController {
    let tableView = UITableView()
    let viewModel = MypageViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        setTableView()
    }
    
    private func setTableView(){
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(MypageProfileCell.self, forCellReuseIdentifier: MypageProfileCell.identifier)
        tableView.register(MypageImageButtonCell.self, forCellReuseIdentifier: MypageImageButtonCell.identifier)

        var items = [MypageViewModelItem]()
        items.append(MypageViewModelImageButtonItem(image: UIImage(systemName: "slider.horizontal.3")!, title: "관심 카테고리 설정") {
            self.navigationController?.pushViewController(SetInterestViewController(), animated: true)
        })
        viewModel.setItems(items)
        tableView.reloadData()
    }
    
    
    
}
