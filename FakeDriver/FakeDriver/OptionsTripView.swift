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
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        tableView.register(DriversCell.self, forCellReuseIdentifier: "DriversCell")
        return tableView
    }()
    
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

// MARK: - CodableView
extension OptionsTripView: CodableView {
    func buildViewHierarchy() {
        addSubview(mapView)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        mapView.snp.makeConstraints {
            $0.height.equalTo(250)
            $0.leading.topMargin.trailing.equalToSuperview().inset(10)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .white
    }
}
