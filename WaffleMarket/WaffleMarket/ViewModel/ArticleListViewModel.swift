//
//  ArticleListViewModel.swift
//  WaffleMarket
//
//  Created by 안재우 on 2022/01/29.
//

import Foundation
import RxSwift
import RxCocoa

class ArticleListViewModel: ObservableObject {
    var page = 1
    var articles = [Article]()
    let articleList = BehaviorRelay<[Article]>(value: [])
    let disposeBag = DisposeBag()
    var isLoadingMoreData = false
    func getArticleList(page:Int, category: String? = nil, keyword: String? = nil, append: Bool = false) {
        
    }
    
    func getCategoryList(category: String, page: Int) {
        // categorypicker로 카테고리 선택시 호출
    }
    
    func getArticleAt(_ index: IndexPath) -> Article?{
        
        let article = articleList.value[index.item]
        return article
    }
    
    func test_fetchDummyData(){
//        print("fetchDummyData")
//        let articles = [
//            Article(id: 1, title: "맥북 에어 미개봉", category: "디지털기기", price: 1000000, content: "맥북 에어 미개봉 팝니다", productImages: ["https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/macbook-air-space-gray-select-201810?wid=904&hei=840&fmt=jpeg&qlt=80&.v=1633027804000"], thumbnailImage: "https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/macbook-air-space-gray-select-201810?wid=904&hei=840&fmt=jpeg&qlt=80&.v=1633027804000", isSold: false),
//            Article(id: 2, title: "아이폰 13", category: "디지털기기", price: 700000, content: "아이폰 13입니다. 사용감 거의 없습니다!", productImages: ["https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/iphone-13-family-select-2021?wid=940&hei=1112&fmt=jpeg&qlt=80&.v=1629842667000"], thumbnailImage: "https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/macbook-air-space-gray-select-201810?wid=904&hei=840&fmt=jpeg&qlt=80&.v=1633027804000", isSold: false)
//
//        ]
//        articleList.accept(articles)
    }
}
