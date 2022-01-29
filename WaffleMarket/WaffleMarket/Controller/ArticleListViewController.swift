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

class ArticleListViewController: UIViewController, UITableViewDelegate {

    var listName: String?
    let articleListView = ArticleListView()
    let imageLoader = CachedImageLoader()
    let disposeBag = DisposeBag()
    var viewModel: ArticleListViewModel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        viewModel.presenting = self
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
            cell.setData(model)
            
            
        }.disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        tableView.rx.itemSelected.bind { indexPath in
                print("asdf")
            
            self.articleListView.articleTableView.deselectRow(at: indexPath, animated: true)
            self.viewModel.didSelect(indexPath)
            
        }.disposed(by: disposeBag)

        viewModel.getArticleList(page: viewModel.page)
        
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
