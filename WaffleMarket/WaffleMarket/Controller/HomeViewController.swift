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
    
    func getArticleList(page:Int) {
        // 백엔드와 연결시 API 호출
    }
    
    func getCategoryList(category: String, page: Int) {
        // categorypicker로 카테고리 선택시 호출
    }
    
    func getArticleAt(_ index: Event<ControlEvent<IndexPath>.Element>) -> Article?{
        guard let item = index.element?.item else {return nil}
        let article = articleList.value[item]
        return article
    }
    
    func test_fetchDummyData(){
        print("fetchDummyData")
        let articles = [
            Article(title: "맥북 에어 미개봉", category: "디지털기기", price: 1000000, content: "맥북 에어 미개봉 팝니다", productImageUrl: "https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/macbook-air-space-gray-select-201810?wid=904&hei=840&fmt=jpeg&qlt=80&.v=1633027804000"),
            Article(title: "아이폰 13", category: "디지털기기", price: 700000, content: "아이폰 13입니다. 사용감 거의 없습니다!", productImageUrl: "https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/iphone-13-family-select-2021?wid=940&hei=1112&fmt=jpeg&qlt=80&.v=1629842667000")
        
        ]
        articleList.accept(articles)
    }
}

class ArticleCell: UITableViewCell {
    
    var titleLabel: UILabel = UILabel()
    var productImage: UIImageView = UIImageView()
    var priceLabel: UILabel = UILabel()
    
    let viewModel = ArticleViewModel()
    let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
}

private let reuseIdentifier = "Cell"

class HomeViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate {
    

//    var signOutBtn = UIButton(type:.system) // MARK: this is for test. remove later
    let textSize: CGFloat = 16
    let scrollView = UIScrollView()
    let writePostBtn = UIButton(type:.custom)
    let articleTableView: UITableView = UITableView()
    let searchField = UISearchTextField()
    let categoryBtn = UIButton()
    var selectedCategory: String?
    
    let disposeBag = DisposeBag()
    let viewModel = ArticleViewModel()
    
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        setScrollView()

        articleTableView.register(ArticleCell.self, forCellReuseIdentifier: "Cell")
        
        viewModel.test_fetchDummyData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if articleTableView.contentOffset.y > (articleTableView.contentSize.height - articleTableView.bounds.size.height) {
            pagination()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    private func pagination() {
        page += 1
        viewModel.getArticleList(page: page)
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
    
    private func setScrollView() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        scrollView.addSubview(categoryBtn)
        scrollView.addSubview(searchField)
        scrollView.addSubview(articleTableView)
        scrollView.addSubview(writePostBtn)
        
        setCategoryBtn()
        setSearchField()
        setArticleTableView()
        setWritePostBtn()
    }
    
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
            weak var didSelect = vc.didSelect
            didSelect?.bind(onNext: { value in
                self.selectedCategory = value
                self.categoryBtn.setTitle(value, for: .normal)
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
    }
    
    private func setArticleTableView() {
        
        articleTableView.translatesAutoresizingMaskIntoConstraints = false
        articleTableView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        articleTableView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        articleTableView.topAnchor.constraint(equalTo: self.searchField.bottomAnchor, constant: 10).isActive = true
        articleTableView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        articleTableView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
        articleTableView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        articleTableView.backgroundColor = .separator

        bindTableArticleData()
        
    }
    
    private func bindTableArticleData() {
        
        viewModel.articleList.bind(to: articleTableView.rx.items(cellIdentifier: reuseIdentifier, cellType: ArticleCell.self)) { row, model, cell in
            print(model)
            cell.titleLabel.text = model.title
            let price = model.price!
            cell.priceLabel.text = "₩ " + String(price)
            cell.productImage.image = self.getArticleImage(urlString: model.productImageUrl)
        }.disposed(by: disposeBag)
        articleTableView.rx.setDelegate(self).disposed(by: disposeBag)
//        articleCollectionView.rx.modelSelected(Article.self).bind{_ in
//            self.present(UINavigationController(rootViewController: ArticleViewController()), animated: true)
//        }.disposed(by: disposeBag)
        articleTableView.rx.itemSelected.subscribe { indexPath in
                print("asdf")
                guard let article = self.viewModel.getArticleAt(indexPath) else { return }
                self.sendArticle(article: article)
            
        }.disposed(by: disposeBag)
        
        viewModel.getArticleList(page: page)
        
    }
    
    private func sendArticle(article: Article) {
        print("sendArticle")
        let controller = ArticleViewController()
            
        controller.articleSelected = Article(title: article.title, category: article.category, price: article.price, content: article.content, productImageUrl: article.productImageUrl)
            
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
