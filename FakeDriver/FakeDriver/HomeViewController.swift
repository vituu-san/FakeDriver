//
//  HomeViewController.swift
//  FakeDriver
//
//  Created by Vitor Costa on 08/12/24.
//

import UIKit

final class HomeViewController: UIViewController {
    private var homeView: HomeView = HomeView()
    
    override func loadView() {
        super.loadView()
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
