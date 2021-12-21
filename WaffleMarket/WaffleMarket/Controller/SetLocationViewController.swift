//
//  SetLocationViewController.swift
//  WaffleMarket
//
//  Created by 안재우 on 2021/12/22.
//

import Foundation
import UIKit
import RxSwift
import CoreLocation
class SetLocationViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let searchBar = UISearchBar()
    let findNearbyBtn = UIButton(type:.system)
    let searchResultTableView = UITableView()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(searchBar)
        self.view.addSubview(findNearbyBtn)
        self.view.addSubview(searchResultTableView)
        setSearchBar()
        setFindNearbyBtn()
        setSearchResultTableView()
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                break
            case .restricted, .notDetermined:
                locationManager.requestWhenInUseAuthorization()
        case .denied:
            break
        @unknown default:
            print("default")
                return
        }
    }
    
    private func setSearchBar(){
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.placeholder = "Search by neighborhood"
        
        searchBar.rx.text.orEmpty.throttle(.milliseconds(800), latest: true, scheduler: MainScheduler.instance).subscribe { changedText in
            print(changedText)
            NaverMapAPI.geocode(query: changedText).subscribe { response in
                let decoder = JSONDecoder()
            
                if let decoded = try? decoder.decode(GeocodeResponse.self, from: response.data) {
                    let addresses = decoded.addresses
                    if addresses.isEmpty {
                        print("empty")
                    }
                    for address in addresses {
                        print(address.roadAddress)
                    }
                    print("")
                }
            } onFailure: { error in
                
            } onDisposed: {
                
            }.disposed(by: self.disposeBag)

        } onError: { error in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

    }
    
    private func setFindNearbyBtn(){
        findNearbyBtn.translatesAutoresizingMaskIntoConstraints = false
        findNearbyBtn.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        findNearbyBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        findNearbyBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        findNearbyBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        findNearbyBtn.backgroundColor = .orange
        findNearbyBtn.setTitle("Find nearby neighborhoods", for: .normal)
        findNearbyBtn.setTitleColor(.white, for: .normal)
        findNearbyBtn.layer.cornerRadius = 10
        
        findNearbyBtn.rx.tap.bind{
            
        }.disposed(by: disposeBag)
    }
    
    private func setSearchResultTableView(){
        searchResultTableView.translatesAutoresizingMaskIntoConstraints = false
        searchResultTableView.topAnchor.constraint(equalTo: findNearbyBtn.bottomAnchor, constant: 10).isActive = true
        searchResultTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchResultTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("change")
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            
            
        }
        
        
    }
}
