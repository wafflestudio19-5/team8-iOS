//
//  ReviewViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/29.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewViewModel: ObservableObject {
    
    var page = 1
    var reviews = [Review]()
    let reviewList = BehaviorRelay<[Review]>(value: [])
    let disposeBag = DisposeBag()
    var isLoadingMoreData = false
    
    func getReviewList(page:Int, seller: Profile) {
    }
    
}

class ReviewCell: UITableViewCell {
    
    let viewModel = ReviewViewModel()
    let imageLoader = CachedImageLoader()
    let disposeBag = DisposeBag()
    var imageUrl: String?
    var profileImage = UIImageView()
    var usernameLabel = UILabel()
    var reviewContent = UILabel()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        usernameLabel.text = nil
        reviewContent.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCell() {
        backgroundColor = .white
        self.heightAnchor.constraint(equalToConstant: 120).isActive = true

        self.contentView.addSubview(profileImage)
        setProfileImage()
        self.contentView.addSubview(usernameLabel)
        setUsernameLabel()
        self.contentView.addSubview(reviewContent)
        setReviewContent()
        
    }
    
    func loadImage(){
        if imageUrl == nil {
            profileImage.image = UIImage(named: "defaultProfileImage")
        } else {
            imageLoader.load(path: imageUrl!, putOn: profileImage)
        }
    }
    
    private func setProfileImage() {
        
        profileImage.contentMode = .scaleAspectFit
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        profileImage.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    private func setUsernameLabel() {
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        
    }
    
    private func setReviewContent() {
        
        reviewContent.translatesAutoresizingMaskIntoConstraints = false
        reviewContent.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
        reviewContent.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor).isActive = true
        reviewContent.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20).isActive = true
        reviewContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
    }
    
}

private let reuseIdentifier = "Cell"

class ReviewViewController: UIViewController, UITableViewDelegate {
    
    let reviewTableView = UITableView()
    let imageLoader = CachedImageLoader()
    let disposeBag = DisposeBag()
    let viewModel = ReviewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(reviewTableView)
        setReviewTableView()
        reviewTableView.register(ReviewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func pagination() {
        print("page: \(viewModel.page)")
        viewModel.page += 1
    }
    
    private func setReviewTableView() {
        
        reviewTableView.translatesAutoresizingMaskIntoConstraints = false
        reviewTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        reviewTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        reviewTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        reviewTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        reviewTableView.heightAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.heightAnchor).isActive = true
        reviewTableView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
    
        bindTableArticleData()
        
    }
    
    private func bindTableArticleData() {
        
        reviewTableView.rx.didScroll.bind{
            let offset = self.reviewTableView.contentOffset.y + self.reviewTableView.frame.height
            let height = self.reviewTableView.contentSize.height
            if offset > height-10 && !self.viewModel.isLoadingMoreData {
                self.pagination()
            }
        }.disposed(by: disposeBag)
        
        viewModel.reviewList.bind(to: reviewTableView.rx.items(cellIdentifier: reuseIdentifier, cellType: ReviewCell.self)) { row, model, cell in
            print(model)
            cell.imageUrl = model.buyer.profileImageUrl
            cell.usernameLabel.text = model.buyer.userName
            cell.reviewContent.text = model.content
            cell.loadImage()
        }.disposed(by: disposeBag)
        
        reviewTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
