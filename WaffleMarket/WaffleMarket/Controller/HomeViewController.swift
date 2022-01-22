//
//  RootViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa
class ArticleViewModel: ObservableObject {
    
    var articles = [Article]()
    let articleList = BehaviorRelay<[Article]>(value: [])
    let disposeBag = DisposeBag()
    var isLoadingMoreData = false
    func getArticleList(page:Int, category: String? = nil, keyword: String? = nil) {
        // 백엔드와 연결시 API 호출
        isLoadingMoreData = true
        ArticleAPI.list(page: page, category: category, keyword: keyword).subscribe { response in
            print(String(decoding: response.data, as: UTF8.self))
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ArticleResponse].self, from: response.data){
                var articles: [Article] = []
                
                for articleResponse in decoded {
                    var thumbnail: String? = nil
                    if articleResponse.product_images.count > 0 {
                        thumbnail = articleResponse.product_images[0].thumbnail_url
                    }
                    
                    let article = Article(
                        id: articleResponse.id,
                        title: articleResponse.title,
                        seller: Profile(phoneNumber: nil, userName: articleResponse.seller.username, profileImage: nil, profileImageUrl: articleResponse.seller.profile_image, location: nil),
                        category: articleResponse.category,
                        price: articleResponse.price,
                        content: articleResponse.content,
                        productImages: articleResponse.product_images.map({ it in
                            it.image_url
                        }),
                        thumbnailImage: thumbnail,
                        isSold: (articleResponse.buyer != nil)
                        
                    )
                    articles.append(article)
                }
                print("articles count:", articles.count)
                self.articleList.accept(self.articleList.value + articles)
            } else {
                print("decoding failure")
            }
            self.isLoadingMoreData = false
        } onFailure: { error in
            self.isLoadingMoreData = false
            print(error)
        } onDisposed: {
            
        }.disposed(by: disposeBag)
    }
    
    func getCategoryList(category: String, page: Int) {
        // categorypicker로 카테고리 선택시 호출
    }
    
    func getArticleAt(_ index: IndexPath) -> Article?{
        
        let article = articleList.value[index.item]
        return article
    }
    
    func test_fetchDummyData(){
        print("fetchDummyData")
        let articles = [
            Article(id: 1, title: "맥북 에어 미개봉", category: "디지털기기", price: 1000000, content: "맥북 에어 미개봉 팝니다", productImages: ["https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/macbook-air-space-gray-select-201810?wid=904&hei=840&fmt=jpeg&qlt=80&.v=1633027804000"], thumbnailImage: "https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/macbook-air-space-gray-select-201810?wid=904&hei=840&fmt=jpeg&qlt=80&.v=1633027804000", isSold: false),
            Article(id: 2, title: "아이폰 13", category: "디지털기기", price: 700000, content: "아이폰 13입니다. 사용감 거의 없습니다!", productImages: ["https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/iphone-13-family-select-2021?wid=940&hei=1112&fmt=jpeg&qlt=80&.v=1629842667000"], thumbnailImage: "https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/macbook-air-space-gray-select-201810?wid=904&hei=840&fmt=jpeg&qlt=80&.v=1633027804000", isSold: false)
        
        ]
        articleList.accept(articles)
    }
}

class ArticleCell: UITableViewCell {
    
    var titleLabel: UILabel = UILabel()
    var imageUrl: String?
    var productImage: UIImageView = UIImageView()
    var priceLabel: UILabel = UILabel()
    var commentLikeLabel: UILabel = UILabel()
    let imageLoader = CachedImageLoader()
    let viewModel = ArticleViewModel()
    let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        commentLikeLabel.text = nil
        imageLoader.cancel()
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

        self.contentView.addSubview(productImage)
        setProductImage()
        self.contentView.addSubview(titleLabel)
        setTitleLabel()
        self.contentView.addSubview(priceLabel)
        setPriceLabel()
        self.contentView.addSubview(commentLikeLabel)
        setCommentLikeLabel()
        
    }
    func loadImage(){
        if imageUrl == nil {
            productImage.image = UIImage(named: "defaultProfileImage")
        } else {
            imageLoader.load(path: imageUrl!, putOn: productImage)
        }
    }
    
    private func setProductImage() {
        
        productImage.contentMode = .scaleAspectFit
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        productImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        productImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        productImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    private func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: productImage.topAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setPriceLabel() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setCommentLikeLabel() {
        commentLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLikeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        commentLikeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    
}

private let reuseIdentifier = "Cell"

class HomeViewController: UIViewController, UITableViewDelegate {
    

//    var signOutBtn = UIButton(type:.system) // MARK: this is for test. remove later
    let textSize: CGFloat = 16
    let writePostBtn = UIButton(type:.custom)
    let articleTableView: UITableView = UITableView()
    let searchField = UISearchTextField()
    let categoryBtn = UIButton()
    var selectedCategory: String?
    let imageLoader = CachedImageLoader()
    let disposeBag = DisposeBag()
    let viewModel = ArticleViewModel()
    
    var page = 1
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.articleList.accept([])
        self.viewModel.getArticleList(page: page, category: selectedCategory, keyword: self.searchField.text)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(categoryBtn)
        self.view.addSubview(searchField)
        self.view.addSubview(articleTableView)
        self.view.addSubview(writePostBtn)
        
        setCategoryBtn()
        setSearchField()
        setArticleTableView()
        setWritePostBtn()

        articleTableView.register(ArticleCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    private func pagination() {
        page += 1
        viewModel.getArticleList(page: page, category: selectedCategory, keyword: self.searchField.text)
        // articleCollectionView.reloadData()
    }
    
//    private func setSignOutBtn(){
//        signOutBtn.setTitle("Test sign out", for: .normal)
//        signOutBtn.translatesAutoresizingMaskIntoConstraints = false
//        signOutBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        signOutBtn.topAnchor.constraint(equalTo: self.helloWorldLabel.bottomAnchor).isActive = true
//        signOutBtn.rx.tap.bind{
//            GoogleSignInAuthenticator.sharedInstance.signOut()
//            AccountManager.logout()
//            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
//            sceneDelegate?.changeRootViewController(LoginViewController())
//            print("signed out!")
//        }.disposed(by: disposeBag)
//    }
    
    private func setWritePostBtn(){
        let size:CGFloat = 60
        writePostBtn.translatesAutoresizingMaskIntoConstraints = false
        writePostBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        writePostBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        writePostBtn.heightAnchor.constraint(equalToConstant: size).isActive = true
        writePostBtn.widthAnchor.constraint(equalToConstant: size).isActive = true
        writePostBtn.backgroundColor = .orange
        writePostBtn.layer.cornerRadius = 0.5 * size;
        writePostBtn.clipsToBounds = true
        
        writePostBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        writePostBtn.setImage(UIImage(systemName: "plus"), for: .highlighted)
        writePostBtn.tintColor = .white
        
        writePostBtn.rx.tap.bind{
            self.navigationController?.pushViewController(WritePostViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func setCategoryBtn() {
        
        categoryBtn.translatesAutoresizingMaskIntoConstraints = false
        categoryBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        categoryBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 90).isActive = true
        categoryBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        categoryBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true

        if let titleLabel = categoryBtn.titleLabel {
            titleLabel.font = UIFont.systemFont(ofSize: textSize)
        }
        categoryBtn.backgroundColor = .orange
        categoryBtn.setTitleColor(.white, for: .normal)
        categoryBtn.setTitle("카테고리", for: .normal)
        categoryBtn.layer.cornerRadius = 10
        
        categoryBtn.rx.tap.bind{
            let vc = CategoryPickerModalViewController()
            vc.includeAll = true
            weak var didSelect = vc.didSelect
            didSelect?.bind(onNext: { value in
                if value == "전체" {
                    self.selectedCategory = nil
                } else {
                    self.selectedCategory = value
                }
                self.categoryBtn.setTitle(value, for: .normal)
                self.page = 1
                self.viewModel.articleList.accept([])
                self.viewModel.getArticleList(page: self.page, category: self.selectedCategory, keyword: self.searchField.text)
            }).disposed(by: self.disposeBag)
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
    
    private func setSearchField() {
        
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.leadingAnchor.constraint(equalTo: self.categoryBtn.trailingAnchor, constant: 10).isActive = true
        searchField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        searchField.topAnchor.constraint(equalTo: self.categoryBtn.topAnchor).isActive = true
        searchField.bottomAnchor.constraint(equalTo: self.categoryBtn.bottomAnchor).isActive = true
        
        searchField.backgroundColor = .white
        searchField.placeholder = "검색"
        searchField.autocapitalizationType = .none
        searchField.autocorrectionType = .no
        searchField.rx.text.orEmpty.throttle(.milliseconds(800),latest: true ,scheduler: MainScheduler.instance).bind { value in
            self.viewModel.articleList.accept([])
            self.page = 1
            self.viewModel.getArticleList(page: self.page, category: self.selectedCategory, keyword: value)
        }.disposed(by: disposeBag)
    }
    
    private func setArticleTableView() {
        
        articleTableView.translatesAutoresizingMaskIntoConstraints = false
        articleTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        articleTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        articleTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor ,constant: 70).isActive = true
        articleTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        articleTableView.heightAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.heightAnchor, constant: -70).isActive = true
        articleTableView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        

        bindTableArticleData()
        
    }
    
    private func bindTableArticleData() {
        
        articleTableView.rx.didScroll.bind{
            let offset = self.articleTableView.contentOffset.y + self.articleTableView.frame.height
            let height = self.articleTableView.contentSize.height
            if offset > height-10 && !self.viewModel.isLoadingMoreData {
                self.pagination()
            }
        }.disposed(by: disposeBag)
        
        viewModel.articleList.bind(to: articleTableView.rx.items(cellIdentifier: reuseIdentifier, cellType: ArticleCell.self)) { row, model, cell in
            print(model)
            cell.titleLabel.text = model.title
            let comment = model.commentNum ?? 0
            let like = model.likeNum ?? 0
            cell.commentLikeLabel.text = "💬 " + String(comment) + "🧡 " + String(like)
            let price = model.price!
            cell.priceLabel.text = "₩ " + String(price)
            if model.isSold {
                cell.priceLabel.text = "판매완료"
            }
            cell.imageUrl = model.thumbnailImage
            cell.loadImage()
            
            
        }.disposed(by: disposeBag)
        articleTableView.rx.setDelegate(self).disposed(by: disposeBag)
//        articleCollectionView.rx.modelSelected(Article.self).bind{_ in
//            self.present(UINavigationController(rootViewController: ArticleViewController()), animated: true)
//        }.disposed(by: disposeBag)
        articleTableView.rx.itemSelected.bind { indexPath in
                print("asdf")
            
            self.articleTableView.deselectRow(at: indexPath, animated: true)
                guard let article = self.viewModel.getArticleAt(indexPath) else { return }
                self.sendArticle(article: article)
            
        }.disposed(by: disposeBag)

        
        //viewModel.getArticleList(page: page)
        
    }
    
    private func sendArticle(article: Article) {
        print("sendArticle")
        let controller = ArticleViewController()
        controller.articleId = article.id
        controller.articleSelected = article
            
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func getArticleImage(urlString: String) -> UIImage {
        let url = URL(string: urlString)
        guard let data = try? Data(contentsOf: url!) else {return UIImage(named: "noImageAvailable") ?? UIImage(named: "noImageAvailable")!}
        return UIImage(data: data) ?? UIImage(named: "noImageAvailable")!
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
