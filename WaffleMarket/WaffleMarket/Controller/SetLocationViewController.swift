//
//  SetLocationViewController.swift
//  WaffleMarket
//
//  Created by Chaemin Lee on 2021/12/19.
//

import UIKit
import NMapsMap
import CoreLocation
class SetLocationViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var mapView: NMFNaverMapView!
    let addressField = UITextField()
    let mapViewContainer = UIView()
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
        self.view.addSubview(addressField)
        
        setAddressField()

        
        // Do any additional setup after loading the view.
    }
    private func setAddressField(){
        addressField.translatesAutoresizingMaskIntoConstraints = false
        addressField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        addressField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        addressField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        addressField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        addressField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addressField.borderStyle = .none
        addressField.layer.cornerRadius = 8
        addressField.layer.borderWidth = 0.25
        addressField.layer.borderColor = UIColor.white.cgColor
        //addressField.bounds = addressField.frame.insetBy(dx: 10.0, dy: 10.0)
        addressField.backgroundColor = .white
        addressField.dropShadow()
        
    }
    
    
    private func setNaverMap(){
        mapView = NMFNaverMapView(frame: mapViewContainer.frame)
        mapView.positionMode = .direction
        mapView.showLocationButton = true
        mapView.showZoomControls = true
        mapView.showCompass = true
        mapView.showScaleBar = true
        mapViewContainer.addSubview(mapView)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("change")
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            setNaverMap()
        }
        
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
