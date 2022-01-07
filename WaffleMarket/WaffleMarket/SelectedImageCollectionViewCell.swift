//
//  SelectedPhotoCollectionViewCell.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/03.
//

import Foundation
import UIKit
import RxSwift

class SelectedImageCollectionViewCell: UICollectionViewCell{
    var imageView = UIImageView()
    var removeBtn = UIButton(type:.custom)
    let disposeBag = DisposeBag()
    var didPressDelete: PublishSubject<Int>!
    var index: Int!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(removeBtn)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = self.contentView.frame
        imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        imageView.contentMode = .scaleToFill
        removeBtn.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeBtn.tintColor = .black
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        removeBtn.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        removeBtn.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        
        removeBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        removeBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        removeBtn.rx.tap.bind{
            self.didPressDelete.onNext(self.index)
        }.disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setData(image: UIImage, index: Int){
        self.index = index
        imageView.image = image
        self.didPressDelete = PublishSubject<Int>()
    }
}
