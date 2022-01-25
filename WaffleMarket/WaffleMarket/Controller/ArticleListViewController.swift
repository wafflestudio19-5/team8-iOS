//
//  ArticleListViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2022/01/25.
//

import UIKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "Cell"

// TODO: 백엔드 연결
//class ArticleListViewModel: ObservableObject {
//
//    var page = 1
//    var articles = [Article]()
//    let articleList = BehaviorRelay<[Article]>(value: [])
//    let disposeBag = DisposeBag()
//    var isLoadingMoreData = false
//
//    func getArticleList(page:Int, listName: String? = nil, append: Bool = false) {
//
//        let prevPage = page - 1
//        // 백엔드와 연결시 API 호출
//        isLoadingMoreData = true
//
//        ArticleAPI.privateList(page: page, listName: listName).subscribe { response in
//            print(String(decoding: response.data, as: UTF8.self))
//            let decoder = JSONDecoder()
//            if let decoded = try? decoder.decode([ArticleResponse].self, from: response.data){
//                var articles: [Article] = []
//
//                for articleResponse in decoded {
//                    var thumbnail: String? = nil
//                    if articleResponse.product_images.count > 0 {
//                        thumbnail = articleResponse.product_images[0].thumbnail_url
//                    }
//                    let article = Article(
//                        id: articleResponse.id,
//                        title: articleResponse.title,
//                        category: articleResponse.category,
//                        price: articleResponse.price,
//                        content: articleResponse.content,
//                        productImages: articleResponse.product_images.map({ it in
//                            it.image_url
//                        }),
//                        thumbnailImage: thumbnail,
//                        isSold: (articleResponse.buyer != nil)
//
//                    )
//                    articles.append(article)
//                }
//                print("articles count:", articles.count)
//                if append {
//                    self.articleList.accept(self.articleList.value + articles)
//                } else {
//                    self.articleList.accept(articles)
//                }
//            } else if let decoded = try? decoder.decode(NonFieldErrorsResponse.self, from: response.data){
//                if decoded.non_field_errors.count>0 && decoded.non_field_errors[0] == "페이지 번호가 범위를 벗어났습니다." {
//                    self.page = prevPage
//                    if !append{
//                        self.articleList.accept([])
//                    }
//                }
//
//            } else {
//                print("decoding failure")
//            }
//            self.isLoadingMoreData = false
//        } onFailure: { error in
//            self.isLoadingMoreData = false
//            print(error)
//        } onDisposed: {
//
//        }.disposed(by: disposeBag)
//    }
//
//    func getSelectedList(listName: String, page: Int) {
//        // categorypicker로 카테고리 선택시 호출
//    }
//
//    func getArticleAt(_ index: IndexPath) -> Article?{
//
//        let article = articleList.value[index.item]
//        return article
//    }
//}


class ArticleListViewController: UIViewController, UITableViewDelegate {

    let articleTableView = UITableView()
    let imageLoader = CachedImageLoader()
    let disposeBag = DisposeBag()
    let viewModel = ArticleViewModel()
    var listName: String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(articleTableView)
        setArticleTableView()

        articleTableView.register(ArticleCell.self, forCellReuseIdentifier: "Cell")
//        self.viewModel.getArticleList(page: viewModel.page, listName: listName)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    private func pagination() {
        print("page: \(viewModel.page)")
        viewModel.page += 1
        viewModel.getArticleList(page: viewModel.page, append: true)
    }
    
    private func setArticleTableView() {
        
        articleTableView.translatesAutoresizingMaskIntoConstraints = false
        articleTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        articleTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        articleTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        articleTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        articleTableView.heightAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.heightAnchor).isActive = true
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
        
        articleTableView.rx.itemSelected.bind { indexPath in
                print("asdf")
            
            self.articleTableView.deselectRow(at: indexPath, animated: true)
                guard let article = self.viewModel.getArticleAt(indexPath) else { return }
                self.sendArticle(article: article)
            
        }.disposed(by: disposeBag)                                               
    }
    
    private func sendArticle(article: Article) {
        print("sendArticle")
        let controller = ArticleViewController()
        controller.articleId = article.id
        controller.articleSelected = article
        self.navigationController?.pushViewController(controller, animated: true)
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
