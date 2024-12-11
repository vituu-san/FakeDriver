//
//  MapView.swift
//  FakeDriver
//
//  Created by Vitor Costa on 08/12/24.
//

import UIKit
import MapKit
import SnapKit

protocol MapViewRenderable: UIView {
    func drawRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D)
    func centerMapOn(_ location: CLLocation?)
}

final class MapView: UIView {
    private var mapView: MKMapView
    
    override init(frame: CGRect) {
        mapView = MKMapView()
        super.init(frame: frame)
        
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        mapView.layer.cornerRadius = 10
        mapView.layer.borderWidth = 2.0
        mapView.layer.borderColor = UIColor.orange.cgColor
        mapView.layer.masksToBounds = true
        mapView.clipsToBounds = true
    }
}

// MARK: - MapViewRenderable
extension MapView: MapViewRenderable {
    func drawRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error in
            guard let response, let route = response.routes.first else {
                if let error {
                    debugPrint(error.localizedDescription)
                }
                return
            }
            
            self?.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let mapRect = route.polyline.boundingMapRect
            let edgePadding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            self?.mapView.setVisibleMapRect(mapRect, edgePadding: edgePadding, animated: true)
        }
    }
    
    func centerMapOn(_ location: CLLocation?) {
        if let location {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        } else {
            debugPrint("A localização atual não foi encontrada.")
        }
    }
}

// MARK: - CodableView
extension MapView: CodableView {
    func buildViewHierarchy() {
        addSubview(mapView)
    }
    
    func setupConstraints() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupAdditionalConfiguration() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
    }
}

// MARK: - MKMapViewDelegate
extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .orange
            renderer.lineWidth = 6.0
            return renderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
}
