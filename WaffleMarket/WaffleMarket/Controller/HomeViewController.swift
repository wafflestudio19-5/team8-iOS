//
//  RootViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class HomeListViewModel: ArticleListViewModel {
    override func getArticleList(page:Int, category: String? = nil, keyword: String? = nil, append: Bool = false) {
        let prevPage = page - 1
        // 백엔드와 연결시 API 호출
        isLoadingMoreData = true
        ArticleAPI.list(page: page, category: category, keyword: keyword).subscribe { response in
            print(String(decoding: response.data, as: UTF8.self))
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Article].self, from: response.data){
                var articles: [Article] = []
                
                for articleResponse in decoded {
                    var thumbnail: String? = nil
                    if articleResponse.product_images.count > 0 {
                        thumbnail = articleResponse.product_images[0].thumbnail_url
                    }
                    
                    
                    articles.append(articleResponse)
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
    let viewModel = HomeListViewModel()
    
    
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

            cell.setData(model)
            
            
            
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
