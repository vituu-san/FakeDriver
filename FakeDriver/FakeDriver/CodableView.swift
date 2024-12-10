//
//  CodableView.swift
//  FakeDriver
//
//  Created by Vitor Costa on 08/12/24.
//

import Foundation

protocol CodableView {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
}

extension CodableView {
    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}
