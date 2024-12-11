//
//  HomeView.swift
//  FakeDriver
//
//  Created by Vitor Costa on 09/12/24.
//

import UIKit
import SnapKit

protocol HomeViewInteracting: AnyObject {
    var didTapEstimateTrip: (() -> Void)? { get set }
}

final class HomeView: UIView, HomeViewInteracting {
    var didTapEstimateTrip: (() -> Void)?
    
    private var formsView: FormsView = FormsView()
    
    private var icon: UIImageView = {
        let image = UIImage(named: "taxi")
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var title: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.textColor = .orange
        label.text = "Fake Drive"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var logoContainer = UIView()
    
    private lazy var estimateTripButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.tintColor = .black
        button.setTitle("Calcular corrida", for: .normal)
        button.addTarget(self, action: #selector(tapEstimateTrip), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private var bottomConstraint: Constraint?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupKeyboardObservers()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        estimateTripButton.layer.cornerRadius = 10
        estimateTripButton.layer.masksToBounds = true
        estimateTripButton.clipsToBounds = true
    }
    
    @objc
    private func tapEstimateTrip() {
        didTapEstimateTrip?()
    }
    
    // MARK: Keyboard
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            bottomConstraint?.update(offset: -keyboardHeight - 10)
            animateKeyboardTransition()
        }
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        bottomConstraint?.update(offset: -10)
        animateKeyboardTransition()
    }
    
    private func animateKeyboardTransition() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
}


// MARK: - CodableView
extension HomeView: CodableView {
    func buildViewHierarchy() {
        logoContainer.addSubview(icon)
        logoContainer.addSubview(title)
        contentContainer.addArrangedSubview(logoContainer)
        contentContainer.addArrangedSubview(formsView)
        contentContainer.addArrangedSubview(estimateTripButton)
        addSubview(contentContainer)
    }
    
    func setupConstraints() {
        icon.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.center.equalToSuperview().priority(.medium)
        }
        title.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom)
            $0.center.equalToSuperview().priority(.high)
        }
        estimateTripButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        contentContainer.snp.makeConstraints {
            $0.topMargin.leading.trailing.equalToSuperview().inset(10)
            self.bottomConstraint = $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(10).constraint
        }
    }
    
    func setupAdditionalConfiguration() {
        formsView.delegate = self
        backgroundColor = .white
    }
}

// MARK: - UITextFieldDelegate
extension HomeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
