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
    let addressTableView = UITableView()
    let disposeBag = DisposeBag()
    var viewModel: SetLocationViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        viewModel = SetLocationViewModel(disposeBag: disposeBag)
        self.view.addSubview(searchBar)
        self.view.addSubview(findNearbyBtn)
        self.view.addSubview(addressTableView)
        setSearchBar()
        setFindNearbyBtn()
        setAddressTableView()
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

    private func sendLocation(code: String){
        
        WaffleAPI.postLocation(code: code).subscribe { response in
            if response.statusCode == 200 {
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                sceneDelegate?.changeRootViewController(MainTabBarController())
            } else {
                print("postLocation:", response)
            }
        } onFailure: { error in
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)

    }
    
    private func setSearchBar(){
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.placeholder = "Search by neighborhood"
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
            guard let location = self.locationManager.location else {return}
            self.viewModel.findNearbyBtnClicked(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        }.disposed(by: disposeBag)
    }
    
    private func setAddressTableView(){
        addressTableView.translatesAutoresizingMaskIntoConstraints = false
        addressTableView.topAnchor.constraint(equalTo: findNearbyBtn.bottomAnchor, constant: 10).isActive = true
        addressTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        addressTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        addressTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        addressTableView.register(AddressTableViewCell.self, forCellReuseIdentifier: "addressCell")
        addressTableView.rx.setDelegate(self).disposed(by: disposeBag)
    
        
        addressTableView.rx.itemSelected.subscribe { indexPath in
            guard let address = self.viewModel.getAddressAt(indexPath) else {return}
            self.sendLocation(code: address.code)
        }.disposed(by: disposeBag)
        
        
        let query = searchBar.rx.text.orEmpty.throttle(.milliseconds(800), latest: true, scheduler: MainScheduler.instance).distinctUntilChanged()
        
        self.viewModel
            .filterByQuery(query: query)
            .bind(to: self.addressTableView.rx.items(cellIdentifier: "addressCell", cellType: AddressTableViewCell.self)) {
                index, element, cell in
                cell.setData(address: element)
            }.disposed(by: disposeBag)
        
        
        self.viewModel.test_fetchDummyData()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            
            
        }
    }
}

extension SetLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
