//
//  RootViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/11/25.
//

import UIKit
import RxSwift

class ArticleViewModel: ObservableObject {
    
    var articles = [Article]()
    let articleList = BehaviorSubject<[Article]>(value: [])
    
    func getArticleList(page:Int) {
        // 백엔드와 연결시 API 호출
    }
    
    func getCategoryList(category: String, page: Int) {
        // categorypicker로 카테고리 선택시 호출
    }
}

class ArticleCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("오류가 발생했습니다")
    }
    
    var titleLabel: UILabel = UILabel()
    var productImage: UIImageView = UIImageView()
    var priceLabel: UILabel = UILabel()
    
    let viewModel = ArticleViewModel()
    let disposeBag = DisposeBag()
    
    private func setupCell() {
        backgroundColor = .white
        addSubview(titleLabel)
        setTitleLabel()
        addSubview(productImage)
        setProductImage()
        addSubview(priceLabel)
        setPriceLabel()
    }
    
    private func setTitleLabel() {
        
    }
    
    private func setProductImage() {
        
    }
    
    private func setPriceLabel() {
        
    }
    
}

private let reuseIdentifier = "Cell"

class HomeViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {

//    var signOutBtn = UIButton(type:.system) // MARK: this is for test. remove later
    let textSize: CGFloat = 16
    let scrollView = UIScrollView()
    let writePostBtn = UIButton(type:.custom)
    let articleCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    let searchField = UISearchTextField()
    let categoryBtn = UIButton()
    var selectedCategory: String?
    
    let disposeBag = DisposeBag()
    let viewModel = ArticleViewModel()
    
    var page = 1
    var fetchMore = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        setScrollView()

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if articleCollectionView.contentOffset.y > (articleCollectionView.contentSize.height - articleCollectionView.bounds.size.height) {
            if !fetchMore {
                pagination()
            }
        }
    }
    
    private func pagination() {
        fetchMore = true
        page += 1
        viewModel.getArticleList(page: page)
        articleCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let cellWidth = (width - 30) / 2
        return CGSize(width: cellWidth, height: cellWidth * 1.2)
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
        
        scrollView.addSubview(writePostBtn)
        scrollView.addSubview(categoryBtn)
        scrollView.addSubview(searchField)
        scrollView.addSubview(articleCollectionView)
        
        setWritePostBtn()
        setCategoryBtn()
        setSearchField()
        setArticleCollectionView()
        
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
        searchField.placeholder = "🔍"
        searchField.autocapitalizationType = .none
        searchField.autocorrectionType = .no
    }
    
    private func setArticleCollectionView() {
        
        articleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        articleCollectionView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        articleCollectionView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        articleCollectionView.topAnchor.constraint(equalTo: self.searchField.bottomAnchor, constant: 10).isActive = true
        articleCollectionView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        
        articleCollectionView.backgroundColor = .separator
        self.articleCollectionView.register(ArticleCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        articleCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        bindCollectionArticleData()
        
    }
    
    private func bindCollectionArticleData() {
        
        viewModel.articleList.bind(to: articleCollectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: ArticleCell.self)) { row,  model, cell in
            cell.titleLabel.text = model.title
            cell.priceLabel.text = String(model.title)
            cell.productImage.image = self.getArticleImage(urlString: model.productImageUrl)
        }.disposed(by: disposeBag)
        
//        articleCollectionView.rx.modelSelected(Article.self).bind{_ in
//            self.present(UINavigationController(rootViewController: ArticleViewController()), animated: true)
//        }.disposed(by: disposeBag)
        
        articleCollectionView.rx.modelSelected(Article.self).subscribe(onNext: { (article) in
            
            let identifier = "Cell"
            guard let controller = self.storyboard?.instantiateViewController(identifier: identifier) as? ArticleViewController else {return}
            
            controller.articleSelected = Article(title: article.title, category: article.category, price: article.price, content: article.content, productImageUrl: article.productImageUrl)
                
            self.navigationController?.pushViewController(controller, animated: true)
            
        }).disposed(by: disposeBag)
        
        viewModel.getArticleList(page: page)
        
    }
    
    private func getArticleImage(urlString: String) -> UIImage {
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
