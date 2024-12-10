//
//  HomeView.swift
//  FakeDriver
//
//  Created by Vitor Costa on 09/12/24.
//

import UIKit
import MapKit
import SnapKit

protocol HomeViewDisplaying: UIView {
    func showRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D)
    func showCenteredMapOn(_ location: CLLocation?)
}

final class HomeView: UIView {
    private var mapView: MapView
    private var formsView: FormsView
    
    override init(frame: CGRect) {
        mapView = MapView()
        formsView = FormsView()
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: HomeViewDisplaying {
    func showRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        mapView.drawRoute(from: source, to: destination)
    }
    
    func showCenteredMapOn(_ location: CLLocation?) {
        mapView.centerMapOn(location)
    }
}

extension HomeView: CodableView {
    func buildViewHierarchy() {
        mapView.addSubview(formsView)
        addSubview(mapView)
    }
    
    func setupConstraints() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        formsView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupAdditionalConfiguration() { }
}

