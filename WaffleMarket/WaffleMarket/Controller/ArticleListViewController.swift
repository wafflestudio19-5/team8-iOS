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

class ArticleListViewModel: ObservableObject {
    var page = 1
    var articles = [Article]()
    let articleList = BehaviorRelay<[Article]>(value: [])
    let disposeBag = DisposeBag()
    var isLoadingMoreData = false
    
    func getArticleAt(_ index: IndexPath) -> Article?{
        
        let article = articleList.value[index.item]
        return article
    }
}


class ArticleListViewController: UIViewController, UITableViewDelegate {

    var listName: String?
    let articleListView = ArticleListView()
    let imageLoader = CachedImageLoader()
    let disposeBag = DisposeBag()
    let viewModel = ArticleListViewModel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(articleListView)
        setArticleListView()
//        self.viewModel.getArticleList(page: viewModel.page, listNmae: listName)
        
    }
    
    private func setArticleListView() {
        
        articleListView.translatesAutoresizingMaskIntoConstraints = false
        articleListView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        articleListView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        articleListView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        articleListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        articleListView.heightAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.heightAnchor).isActive = true
        articleListView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        bindTableArticleData()
    }
    
    private func pagination() {
        print("page: \(viewModel.page)")
        viewModel.page += 1
//        viewModel.getArticleList(page: viewModel.page, append: true)
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
