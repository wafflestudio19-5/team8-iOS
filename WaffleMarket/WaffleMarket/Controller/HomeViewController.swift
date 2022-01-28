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
    var page = 1
    var articles = [Article]()
    let articleList = BehaviorRelay<[Article]>(value: [])
    let disposeBag = DisposeBag()
    var isLoadingMoreData = false
    func getArticleList(page:Int, category: String? = nil, keyword: String? = nil, append: Bool = false) {
        let prevPage = page - 1
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
                if append {
                    self.articleList.accept(self.articleList.value + articles)
                } else {
                    self.articleList.accept(articles)
                }
            } else if let decoded = try? decoder.decode(NonFieldErrorsResponse.self, from: response.data){
                if decoded.non_field_errors.count>0 && decoded.non_field_errors[0] == "페이지 번호가 범위를 벗어났습니다." {
                    self.page = prevPage
                    if !append{
                        self.articleList.accept([])
                    }
                }
                
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

private let reuseIdentifier = "Cell"

class HomeViewController: UIViewController, UITableViewDelegate {
    

    var prevSearchText = ""
//    var signOutBtn = UIButton(type:.system) // MARK: this is for test. remove later
    let textSize: CGFloat = 16
    let writePostBtn = UIButton(type:.custom)
    let articleListView = ArticleListView()
    let searchField = UISearchTextField()
    let categoryBtn = UIButton()
    var selectedCategory: String?
    let imageLoader = CachedImageLoader()
    let disposeBag = DisposeBag()
    let viewModel = ArticleViewModel()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(categoryBtn)
        self.view.addSubview(searchField)
        self.view.addSubview(articleListView)
        self.view.addSubview(writePostBtn)
        
        setCategoryBtn()
        setSearchField()
        setArticleListView()
        setWritePostBtn()

        self.viewModel.getArticleList(page: viewModel.page, category: selectedCategory, keyword: self.searchField.text)
        
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
            vc.includeAll = true
            weak var didSelect = vc.didSelect
            didSelect?.bind(onNext: { value in
                if value == "전체" {
                    self.selectedCategory = nil
                } else {
                    self.selectedCategory = value
                }
                self.categoryBtn.setTitle(value, for: .normal)
                self.viewModel.page = 1
                self.viewModel.articleList.accept([])
                self.viewModel.getArticleList(page: self.viewModel.page, category: self.selectedCategory, keyword: self.searchField.text)
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
        searchField.rx.text.orEmpty.throttle(.milliseconds(800),latest: true ,scheduler: MainScheduler.instance).skip(1).distinctUntilChanged().bind{ value in
            
            if self.prevSearchText != value {
                print("search")
                self.viewModel.page = 1
                self.viewModel.getArticleList(page: self.viewModel.page, category: self.selectedCategory, keyword: value)
            }

            self.prevSearchText = value
        }.disposed(by: disposeBag)
    }
    
    private func setArticleListView() {
        
        articleListView.translatesAutoresizingMaskIntoConstraints = false
        articleListView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        articleListView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        articleListView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor ,constant: 70).isActive = true
        articleListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        articleListView.heightAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.heightAnchor, constant: -70).isActive = true
        articleListView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        bindTableArticleData()
        
    }
    
    private func pagination() {
        print("page: \(viewModel.page)")
        viewModel.page += 1
        viewModel.getArticleList(page: viewModel.page, append: true)
    }
    
    private func bindTableArticleData() {
        
        let tableView = articleListView.articleTableView
        
        tableView.rx.didScroll.bind{
            let offset = tableView.contentOffset.y + tableView.frame.height
            let height = tableView.contentSize.height
            if offset > height-10 && !self.viewModel.isLoadingMoreData {
                self.pagination()
            }
        }.disposed(by: disposeBag)
        
        viewModel.articleList.bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: ArticleCell.self)) { row, model, cell in
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
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        tableView.rx.itemSelected.bind { indexPath in
                print("asdf")
            
            self.articleListView.articleTableView.deselectRow(at: indexPath, animated: true)
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
