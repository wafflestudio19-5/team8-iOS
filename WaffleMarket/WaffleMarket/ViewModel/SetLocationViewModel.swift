//
//  SetLocationViewModel.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/23.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation
import Moya
import RxCocoa

class SetLocationViewModel {
    let disposeBag: DisposeBag
    
    let addressRelay: BehaviorRelay<[Address]> = BehaviorRelay(value: [
    ])
    
    var longitude: CLLocationDegrees = 0
    var latitude: CLLocationDegrees = 0
    
    init(disposeBag: DisposeBag){
        self.disposeBag = disposeBag
    }
    
    func getAddressAt(_ index: Event<ControlEvent<IndexPath>.Element>) -> Address?{
        guard let item = index.element?.item else {return nil}
        let address = self.addressRelay.value[item]
        return address
    }
    
    private func fetchNearbyAddresses(code: String){
        print(AccountManager.token)
        LocationAPI.findNearbyNeighborhoods(code: code).subscribe { response in
            print(String(decoding: response.data, as: UTF8.self))
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(NeighborhoodResponse.self, from: response.data) {
                    var addresses: [Address] = []
                    for loc in decoded.neighborhoods {
                        let address = Address(loc.code, loc.place_name)
                        addresses.append(address)
                    }
                    self.addressRelay.accept(addresses)
                }
            } else {
                print("fetchNearbyAddresses Failed!", response.statusCode)
            }
        } onFailure: { error in
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

        
    }
    
    func test_fetchDummyData(){
        addressRelay.accept([
            Address("111111", "서울특별시 관악구"),
            Address("222222", "서울특별시 도봉구"),
            Address("333333", "서울특별시 노원구")
        ])
    }
    
    func filterByQuery(query: Observable<String>) -> Observable<[Address]> {
        Observable.combineLatest(self.addressRelay, query){ (items, query) -> [Address] in
            return items.filter { address in
                
                if query.isEmpty {
                    return true
                }
                return address.name.decomposeHangul().filter{!$0.isWhitespace}
                    .contains(query.decomposeHangul().filter{!$0.isWhitespace})
            }
        }
    }
   
    func fetchNeighborhoodByLocation(longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        NaverMapAPI.reverseGeocode(longitude: longitude, latitude: latitude)
            .subscribe { response in
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(ReverseGeocodeResponse.self, from: response.data) {
                    self.fetchNearbyAddresses(code: decoded.results[0].id)
                }
            } onFailure: { error in
                
            }.disposed(by: self.disposeBag)
    }

}
