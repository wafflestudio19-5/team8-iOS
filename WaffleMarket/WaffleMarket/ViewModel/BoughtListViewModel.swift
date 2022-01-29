//
//  BoughtListViewModel.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/29.
//

import Foundation
import UIKit

class BoughtListViewModel: ArticleListViewModel {
    override func getArticleList(page: Int, category: String? = nil, keyword: String? = nil, append: Bool = false) {
        let prevPage = page - 1
        // 백엔드와 연결시 API 호출
        isLoadingMoreData = true
        UserAPI.getBought().subscribe { response in
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
    override func didSelect(_ index: IndexPath) {
//        let alert = UIAlertController(title: "리뷰 남기기", message: nil, preferredStyle: .alert)
//        alert.addTextField { textField in
//            
//        }
//        let reviewAction = UIAlertAction(title: "확인", style: .default) { _ in
//            ReviewAPI.reviewAsBuyer(articleId: self.getArticleAt(index)!.id, review: alert.textFields![0].text ?? "").subscribe { response in
//                print(String(decoding: response.data, as: UTF8.self))
//                if response.statusCode / 100 == 2 {
//                    alert.dismiss(animated:true)
//                }
//            } onFailure: { error in
//                
//            } onDisposed: {
//                
//            }.disposed(by: self.disposeBag)
//
//        }
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
//            alert.dismiss(animated: true)
//        }
//        alert.addAction(reviewAction)
//        alert.addAction(cancelAction)
//        presenting!.present(alert, animated: true)
    }
}
