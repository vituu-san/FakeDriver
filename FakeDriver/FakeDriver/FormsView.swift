//
//  FormsView.swift
//  FakeDriver
//
//  Created by Vitor Costa on 10/12/24.
//

import UIKit
import SnapKit

final class FormsView: UIView {
    weak var delegate: UITextFieldDelegate?
    
    private lazy var userID: UITextField = {
        let icon = UIImage(systemName: "person.fill")
        let textField = CustomTextField(leftIcon: icon ?? UIImage())
        textField.placeholder = "Digite o ID do usuário"
        textField.font = .systemFont(ofSize: 18)
        textField.returnKeyType = .next
        textField.delegate = self
        return textField
    }()
    
    private lazy var sourceAddress: UITextField = {
        let icon = UIImage(named: "a")?.withTintColor(.orange, renderingMode: .alwaysTemplate)
        let textField = CustomTextField(leftIcon: icon ?? UIImage())
        textField.placeholder = "Digite o endereço de origem"
        textField.font = .systemFont(ofSize: 18)
        textField.returnKeyType = .next
        textField.delegate = self
        return textField
    }()
    
    private lazy var destinationAddress: UITextField = {
        let icon = UIImage(named: "b")?.withTintColor(.orange, renderingMode: .alwaysTemplate)
        let textField = CustomTextField(leftIcon: icon ?? UIImage())
        textField.placeholder = "Digite o endereço de destino"
        textField.font = .systemFont(ofSize: 18)
        textField.returnKeyType = .done
        textField.delegate = self
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
        backView.layer.cornerRadius = 10
        backView.layer.borderWidth = 2.0
        backView.layer.borderColor = UIColor.orange.cgColor
        backView.layer.masksToBounds = true
        backView.clipsToBounds = true
    }
}

extension FormsView: CodableView {
    func buildViewHierarchy() {
        backView.addSubview(formsContainer)
        addSubview(backView)
    }
    
    func setupConstraints() {
        formsContainer.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.trailing.equalToSuperview().inset(10)
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupAdditionalConfiguration() {
        translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .white
    }
}

extension FormsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        delegate?.textFieldShouldReturn?(textField) ?? false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
