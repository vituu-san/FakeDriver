//
//  CustomTextField.swift
//  FakeDriver
//
//  Created by Vitor Costa on 10/12/24.
//

import UIKit

final class CustomTextField: UITextField {
    private var leftIcon: UIImage
    private var textInsets = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 10)
    
    init(leftIcon: UIImage) {
        self.leftIcon = leftIcon
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        configureLeftIcon()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = .clear
    }
    
    func configureLeftIcon() {
        let leftImageView = UIImageView(image: leftIcon)
        leftImageView.tintColor = .gray
        
        let verticalLine = UIView()
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.backgroundColor = .gray
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        
        container.addSubview(leftImageView)
        container.addSubview(verticalLine)
        
        container.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        leftImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.center.equalToSuperview()
        }
        verticalLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.top.bottom.equalToSuperview().inset(2)
            $0.trailing.equalToSuperview()
        }
        
        leftView = container
        leftViewMode = .always
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
}
