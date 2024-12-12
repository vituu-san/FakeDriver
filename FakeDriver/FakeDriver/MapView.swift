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
    
    private func configurePointAnnotations(from source: CLLocationCoordinate2D,
                                           to destination: CLLocationCoordinate2D) {
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = source
        startAnnotation.title = "Ponto A"
        mapView.addAnnotation(startAnnotation)

        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = destination
        endAnnotation.title = "Ponto B"
        mapView.addAnnotation(endAnnotation)
    }
}

// MARK: - MapViewRenderable
extension MapView: MapViewRenderable {
    func drawRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        configurePointAnnotations(from: source, to: destination)
        
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
        if annotation.title == "Ponto A" {
            annotationView.image = resizeImage(UIImage(named: "a")!,
                                               targetSize: CGSize(width: 20, height: 20))
        } else if annotation.title == "Ponto B" {
            annotationView.image = resizeImage(UIImage(named: "b")!,
                                               targetSize: CGSize(width: 20, height: 20))
        }
        return annotationView
    }
    
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
}
