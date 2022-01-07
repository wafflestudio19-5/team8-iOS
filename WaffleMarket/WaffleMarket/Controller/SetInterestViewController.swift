//
//  SetInterestViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/07.
//

import Foundation
import UIKit
import RxSwift
class SetInterestViewController: UIViewController {
    let items = CategoryConstants.categories
    var initialSelectedItems: [String] = []
    let disposeBag = DisposeBag()
    let collectionView: UICollectionView  = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        UserAPI.getCategory().subscribe { response in
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(GetCategoryResponse.self, from: response.data) {
                self.initialSelectedItems = decoded.categories
                self.setCollectionView()
            }
        } onFailure: { error in
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

        
    }
    
    private func setCollectionView(){
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        collectionView.register(SetInterestCollectionViewCell.self, forCellWithReuseIdentifier: SetInterestCollectionViewCell.identifier)
        
        Observable.just(items).bind(to: collectionView.rx.items(cellIdentifier: SetInterestCollectionViewCell.identifier, cellType: SetInterestCollectionViewCell.self)) { index, item, cell in
            cell.setCategoryName(item)
            cell.setInitialChecked(self.initialSelectedItems.contains(item))
            
        }.disposed(by: disposeBag)
        
    }
}

extension SetInterestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2 - 60, height: 40)
    }
}

class SetInterestCollectionViewCell: UICollectionViewCell {
    static let identifier = "SetInterestCollectionViewCell"
    let checkBoxView = CheckBoxView()
    let disposeBag = DisposeBag()
    var categoryName: String!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(checkBoxView)
        checkBoxView.translatesAutoresizingMaskIntoConstraints = false
        checkBoxView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        checkBoxView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        checkBoxView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        checkBoxView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        checkBoxView.checkLabel.font = .systemFont(ofSize: 14)
        checkBoxView.changeOnTap = false
        
        checkBoxView.didTap.bind{
            let nextChecked = !self.checkBoxView.isChecked
            UserAPI.setCategory(category: self.categoryName, enabled: nextChecked).subscribe { response in
                if response.statusCode/100 == 2 {
                    self.checkBoxView.setChecked(nextChecked)
                }
            } onFailure: { error in
                
            } onDisposed: {
                
            }.disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setCategoryName(_ value: String){
        categoryName = value
        checkBoxView.setText(value)
    }
    func setInitialChecked(_ value: Bool){
        checkBoxView.setChecked(value)

    }
}
