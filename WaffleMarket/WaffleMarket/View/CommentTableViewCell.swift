//
//  CommentTableViewCell.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/08.
//

import Foundation
import UIKit

class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"
    let profileImageView = UIImageView()
    let contentLabel = UILabel()
    let usernameLabel = UILabel()
    let timestampLabel = UILabel()
    let containerView = UIView()
    var height: CGFloat {
        get{
            return contentLabel.text?.getEstimatedFrame(with: contentLabel.font).size.height ?? 0
            
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(containerView)
        
        containerView.addSubview(profileImageView)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(timestampLabel)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        usernameLabel.font = .systemFont(ofSize: 18)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 12)
        
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.topAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: 15).isActive = true
        timestampLabel.topAnchor.constraint(greaterThanOrEqualTo: profileImageView.bottomAnchor, constant: 15).isActive = true
        timestampLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        timestampLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        timestampLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        timestampLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timestampLabel.font = .systemFont(ofSize: 10)
        timestampLabel.textColor = .lightGray
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(isReply: Bool, username: String, profile_image: String, content: String, timestamp: String){
        if isReply {
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 40).isActive = true
        } else {
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        }
        if profile_image == "default" {
            profileImageView.image = UIImage(named: "defaultProfileImage")
        } else {
            CachedImageLoader().load(path: profile_image, putOn: profileImageView)
        }
        usernameLabel.text = username
        contentLabel.text = content
        timestampLabel.text = timestamp
        contentLabel.heightAnchor.constraint(equalToConstant: content.getEstimatedFrame(with: contentLabel.font).size.height).isActive = true
        
    }
    
}
