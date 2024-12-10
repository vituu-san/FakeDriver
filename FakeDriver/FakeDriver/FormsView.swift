//
//  FormsView.swift
//  FakeDriver
//
//  Created by Vitor Costa on 10/12/24.
//

import UIKit
import SnapKit

final class FormsView: UIView {
    private var userID: UITextField = {
        let icon = UIImage(systemName: "person.fill")
        let textField = CustomTextField(leftIcon: icon ?? UIImage())
        textField.placeholder = "Digite o ID do usuário"
        textField.font = .systemFont(ofSize: 18)
        return textField
    }()
    
    private var sourceAddress: UITextField = {
        let icon = UIImage(systemName: "record.circle.fill")
        let textField = CustomTextField(leftIcon: icon ?? UIImage())
        textField.placeholder = "Digite o endereço de origem"
        textField.font = .systemFont(ofSize: 18)
        return textField
    }()
    
    private var destinationAddress: UITextField = {
        let icon = UIImage(systemName: "dot.square.fill")
        let textField = CustomTextField(leftIcon: icon ?? UIImage())
        textField.placeholder = "Digite o endereço de destino"
        textField.font = .systemFont(ofSize: 18)
        return textField
    }()
    
    private lazy var formsContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userID, sourceAddress, destinationAddress])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private var backView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        backView.layer.cornerRadius = 8.0
        backView.layer.borderWidth = 2.0
        backView.layer.borderColor = UIColor.gray.cgColor
        backView.layer.masksToBounds = true
    }
}

extension FormsView: CodableView {
    func buildViewHierarchy() {
        backView.addSubview(formsContainer)
        addSubview(backView)
    }
    
    func setupConstraints() {
        formsContainer.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func setupAdditionalConfiguration() {
        translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .white
    }
}
