//
//  ChatroomListTableViewCell.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/22.
//

import Foundation
import UIKit
class ChatroomListTableViewCell: UITableViewCell {
    static let identifier = "ChatroomListTableViewCell"
    let hstack = UIStackView()
    let profileImageView = UIImageView()
    let userNameLabel = UILabel()
    let lastChatLabel = UILabel()
    let vstack = UIStackView()
    let productImageView = UIImageView()
    let profileImageLoader = CachedImageLoader()
    let productImageLoader = CachedImageLoader()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        productImageView.image = nil
        
        
        profileImageLoader.cancel()
        productImageLoader.cancel()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        self.contentView.addSubview(hstack)

        hstack.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastChatLabel.translatesAutoresizingMaskIntoConstraints = false
        vstack.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        hstack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        hstack.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        hstack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        hstack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        hstack.axis = .horizontal
        hstack.alignment = .fill
        hstack.distribution = .fillProportionally
        hstack.addArrangedSubview(profileImageView)
        profileImageView.widthAnchor.constraint(equalToConstant: self.contentView.frame.height).isActive = true
        profileImageView.layer.cornerRadius = self.contentView.frame.height/2
        profileImageView.clipsToBounds = true
        hstack.spacing = 10
        hstack.addArrangedSubview(vstack)
        
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.distribution = .fillProportionally
        userNameLabel.font = .boldSystemFont(ofSize: 14)
        
        lastChatLabel.font = .systemFont(ofSize: 12)
        vstack.addArrangedSubview(userNameLabel)
        vstack.addArrangedSubview(lastChatLabel)
        
        hstack.addArrangedSubview(productImageView)
        productImageView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setData(userName: String, profileImageUrl: String?, lastChat: String, productImageUrl: String) {
        userNameLabel.text = userName
        if let profileImageUrl = profileImageUrl {
            profileImageLoader.load(path: profileImageUrl, putOn: profileImageView)
        } else {
            profileImageView.image = UIImage(named: "defaultProfileImage")
        }
        
        productImageLoader.load(path: productImageUrl, putOn: productImageView)
        lastChatLabel.text = lastChat
        
    }
}
