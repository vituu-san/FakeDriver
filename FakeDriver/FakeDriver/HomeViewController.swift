//
//  HomeViewController.swift
//  FakeDriver
//
//  Created by Vitor Costa on 08/12/24.
//

import UIKit
import MapKit

final class HomeViewController: UIViewController {
    var currentLocation: CLLocation?
    var locationManager: CLLocationManager = CLLocationManager()
    var homeView: HomeViewDisplaying = HomeView()
    
    override func loadView() {
        super.loadView()
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationServices()
        
        // Simulação de uma rota com base em latitude e longitude:
        let sourceCoordinate = CLLocationCoordinate2D(latitude: -27.5521413, longitude: -48.6213535)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: -27.5962788, longitude: -48.551487)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.homeView.showRoute(from: sourceCoordinate, to: destinationCoordinate)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homeView.showCenteredMapOn(currentLocation)
    }
    
    func configureLocationServices() {
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            debugPrint("Permissão negada ou restrita.")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            debugPrint("Status de permissão desconhecido.")
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            debugPrint("Não foi possível determinar a localização atual.")
            return
        }
        
        currentLocation = lastLocation
    }
}
