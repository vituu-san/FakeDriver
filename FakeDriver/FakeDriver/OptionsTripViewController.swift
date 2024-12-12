//
//  OptionsTripViewController.swift
//  FakeDriver
//
//  Created by Vitor Costa on 11/12/24.
//

import UIKit
import MapKit

final class OptionsTripViewController: UIViewController {
    private var currentLocation: CLLocation?
    private var locationManager: CLLocationManager = CLLocationManager()
    private var optionsTripView = OptionsTripView()
    
    override func loadView() {
        super.loadView()
        view = optionsTripView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationServices()
        optionsTripView.tableView.delegate = self
        optionsTripView.tableView.dataSource = self
        
        // Simulação de uma rota com base em latitude e longitude:
        let sourceCoordinate = CLLocationCoordinate2D(latitude: -27.5521413, longitude: -48.6213535)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: -27.5962788, longitude: -48.551487)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.optionsTripView.showRoute(from: sourceCoordinate, to: destinationCoordinate)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        optionsTripView.showCenteredMapOn(currentLocation)
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
extension OptionsTripViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            debugPrint("Não foi possível determinar a localização atual.")
            return
        }
        
        currentLocation = lastLocation
    }
}

extension OptionsTripViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DriversCell", for: indexPath) as? DriversCell {
            cell.setup(name: "Homer Simpson",
                       introduction: "Olá! Sou o Homer, seu motorista camarada! Relaxe e aproveite o passeio, com direito a rosquinhas e boas risadas (e talvez alguns desvios).",
                       vehicle: "Plymouth Valiant 1973 rosa e enferrujado",
                       rating: "2",
                       value: "R$ 50.05")
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
