//
//  OptionsTripView.swift
//  FakeDriver
//
//  Created by Vitor Costa on 11/12/24.
//

import UIKit
import MapKit
import SnapKit

protocol OptionsTripViewDisplaying: UIView {
    func showRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D)
    func showCenteredMapOn(_ location: CLLocation?)
}

final class OptionsTripView: UIView {
    private var mapView: MapView = MapView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - OptionsTripViewDisplaying
extension OptionsTripView: OptionsTripViewDisplaying {
    func showRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        mapView.drawRoute(from: source, to: destination)
    }
    
    func showCenteredMapOn(_ location: CLLocation?) {
        mapView.centerMapOn(location)
    }
}

extension OptionsTripView: CodableView {
    func buildViewHierarchy() {
        addSubview(mapView)
    }
    
    func setupConstraints() {
        mapView.snp.makeConstraints {
            $0.height.equalTo(250)
            $0.leading.topMargin.trailing.equalToSuperview().inset(10)
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .white
    }
}
