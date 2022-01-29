//
//  SoldListViewModel.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/29.
//

import Foundation
import UIKit
class SoldListViewModel: ArticleListViewModel {
    override func getArticleList(page: Int, category: String? = nil, keyword: String? = nil, append: Bool = false) {
        let prevPage = page - 1
        // 백엔드와 연결시 API 호출
        isLoadingMoreData = true
        UserAPI.getSold().subscribe { response in
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
        guard let article = getArticleAt(index) else {return}
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            ArticleAPI.delete(articleId: article.id).subscribe { response in
                print(String(decoding: response.data, as: UTF8.self))
                if response.statusCode / 100 == 2 {
                    alert.dismiss(animated:true)
                    self.page = 1
                    self.getArticleList(page: 1)
                }
            } onFailure: { error in
                
            } onDisposed: {
                
            }.disposed(by: self.disposeBag)

        }
        let soldAction = UIAlertAction(title: "판매 완료", style: .default) { _ in
            var candidates: [String] = []
            for (key, value) in ChatCommunicator.shared.hasRoom {
                if key.contains("_\(article.id)") && value {
                    candidates.append(key)
                }
            }
            if candidates.count > 0 {
                let vc = ChatroomListViewController()
                vc.buyerChooserMode = true
                vc.buyerCandidates = candidates
                vc.delegate = self
                self.presenting!.present(vc, animated: true)
            } else {
                self.presenting?.toast("채팅을 통해 이야기한 상대가 없어요", y: 50)
            }
            alert.dismiss(animated: true)
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(deleteAction)
        alert.addAction(soldAction)
        alert.addAction(cancelAction)
        presenting!.present(alert, animated: true)
        
    }
}

extension SoldListViewModel: BuyerChooserDelegate {
    func setBuyer(articleId: Int, userId: Int) {
        ArticleAPI.registerBuyer(articleId: articleId, buyer_id: userId).subscribe { response in
            print(String(decoding: response.data, as: UTF8.self))
            
        } onFailure: { error in
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

    }
}
