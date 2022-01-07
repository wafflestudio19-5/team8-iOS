//
//  MypageImageButtonCell.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/07.
//

import Foundation
import UIKit
import RxSwift
class MypageImageButtonCell: UITableViewCell {
    static let identifier = "MypageImageButtonCell"
    let button = UIButton(type: .system)
    let iconImageView = UIImageView()
    let disposeBag = DisposeBag()
    var onClick: (()->Void)?
    var item: MypageViewModelItem? {
        didSet {
            guard let item = item as? MypageViewModelImageButtonItem else { return }
            button.setTitle(item.title, for: .normal)
            iconImageView.image = item.image
            iconImageView.tintColor = .orange
            onClick = item.onClick
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        button.setTitleColor(.black, for: .normal)
        button.addSubview(iconImageView)
        button.rx.tap.bind{
            self.onClick?()
        }.disposed(by: disposeBag)
        iconImageView.isUserInteractionEnabled = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        iconImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        iconImageView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.7).isActive = true
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .black
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
