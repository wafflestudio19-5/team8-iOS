//
//  SetLocationViewModel.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/23.
//

import Foundation
import RxSwift
import RxRelay
class SetLocationViewModel {
    let addressDataSubject: BehaviorRelay<[Address]> = BehaviorRelay(value: [
    ])
    
    func fetchNearbyAddresses(){
        
    }
    
    func test_fetchDummyData(){
        addressDataSubject.accept([
            Address(111111, "서울특별시 관악구"),
            Address(222222, "서울특별시 도봉구"),
            Address(333333, "서울특별시 노원구")
        ])
    }
    
    func filterByQuery(query: Observable<String>) -> Observable<[Address]> {
        Observable.combineLatest(self.addressDataSubject, query){ (items, query) -> [Address] in
            return items.filter { address in
                
                if query.isEmpty {
                    return true
                }
                return address.name.decomposeHangul().filter{!$0.isWhitespace}
                    .contains(query.decomposeHangul().filter{!$0.isWhitespace})
            }
        }
    }

}
