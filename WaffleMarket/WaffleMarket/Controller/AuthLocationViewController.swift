//
//  SetLocationViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2021/12/19.
//

import UIKit
import NMapsMap
import CoreLocation
import RxSwift
import RxCoreLocation
class AuthLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: implement authorize button
    let disposeBag = DisposeBag()
    let locationManager = CLLocationManager()
    var naverMapView: NMFNaverMapView!
    let searchBox = UIView()
    let addressField = UITextField()
    let mapViewContainer = UIView()
    let marker = NMFMarker()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
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
        mapViewContainer.frame = self.view.frame
        self.view.addSubview(mapViewContainer)
        
        self.view.addSubview(searchBox)

        setSearchBox()


        
        // Do any additional setup after loading the view.
    }
    private func setSearchBox(){
        searchBox.translatesAutoresizingMaskIntoConstraints = false
        searchBox.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        searchBox.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        searchBox.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        searchBox.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        searchBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBox.layer.cornerRadius = 8
        searchBox.layer.borderWidth = 0.25
        searchBox.layer.borderColor = UIColor.white.cgColor
        //addressField.bounds = addressField.frame.insetBy(dx: 10.0, dy: 10.0)
        searchBox.backgroundColor = .white
        searchBox.dropShadow()
        
        searchBox.addSubview(addressField)
        setAddressField()
    }
    private func setAddressField(){
        addressField.translatesAutoresizingMaskIntoConstraints = false
        addressField.topAnchor.constraint(equalTo: searchBox.topAnchor, constant: 0).isActive = true
        addressField.leadingAnchor.constraint(equalTo: searchBox.leadingAnchor, constant: 10).isActive = true
        addressField.trailingAnchor.constraint(equalTo: searchBox.trailingAnchor, constant: -10).isActive = true
        addressField.heightAnchor.constraint(equalTo: searchBox.heightAnchor).isActive = true
        addressField.autocorrectionType = .no
        addressField.autocapitalizationType = .none
        addressField.placeholder = "주소를 입력하세요"
        addressField.rx.text.orEmpty.throttle(.milliseconds(1000), latest: true, scheduler: MainScheduler.instance).bind{ changedText in
            
            
            guard let naverMapView = self.naverMapView else {return}
            print(changedText)
            if changedText.isEmpty {
                print("empty")
                return
            }
            NaverMapAPI.geocode(query: changedText, longitude: naverMapView.mapView.longitude, latitude: naverMapView.mapView.latitude)
                .subscribe { response in
                
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode(GeocodeResponse.self, from: response.data) {
                        let addresses = decoded.addresses
                        if addresses.isEmpty {
                            print("No result")
                        }
                        for address in addresses {
                            print(address.roadAddress)
                        }
                        print("")
                    }
                    
                } onFailure: { error in
                    
                } onDisposed: {
                    
                }.disposed(by: self.disposeBag)

        }.disposed(by: disposeBag)
    }
    
    
    private func setNaverMap(){
        naverMapView = NMFNaverMapView(frame: mapViewContainer.frame)
        naverMapView.mapView.addCameraDelegate(delegate: self)
        naverMapView.positionMode = .direction
        naverMapView.showLocationButton = true
        naverMapView.showZoomControls = true
        naverMapView.showCompass = true
        naverMapView.showScaleBar = true
    
        locationManager.rx.location.subscribe (onNext:{ location in
            guard let location = location else {return}

            self.marker.position = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            
        }).disposed(by: disposeBag)

        marker.mapView = self.naverMapView.mapView
        
        
//        NaverMapAPI.reverseGeocode(longitude: locationManager.location!.coordinate.longitude, latitude: locationManager.location!.coordinate.latitude).subscribe { response in
//            let decoder = JSONDecoder()
//            if let decoded = try? decoder.decode(ReverseGeocodeResponse.self, from: response.data) {
//                print(decoded.results[0].id)
//            }
//        } onFailure: { error in
//
//        } onDisposed: {
//
//        }.disposed(by: disposeBag)
        mapViewContainer.addSubview(naverMapView)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("change")
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
            
        }
        setNaverMap()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
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
extension AuthLocationViewController: NMFMapViewCameraDelegate{
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if reason == NMFMapChangedByLocation {

        }
    }
}
