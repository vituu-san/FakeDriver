//
//  DriversCell.swift
//  FakeDriver
//
//  Created by Vitor Costa on 12/12/24.
//

import UIKit
import SnapKit

final class DriversCell: UITableViewCell {
    private lazy var name: UILabel = makeLabel(of: 20, isBold: true)
    private lazy var introduction: UILabel = makeLabel(of: 16)
    private lazy var vehicle: UILabel = makeLabel(of: 16)
    private lazy var rating: UILabel = makeLabel(of: 16, isBold: true)
    private lazy var value: UILabel = makeLabel(of: 18, isBold: true)
    
    private var star: UIImageView = {
        let image = UIImage(systemName: "star.fill")
        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var chooseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitle("Escolher", for: .normal)
        return button
    }()
    
    private var contentContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.orange.cgColor
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        
        chooseButton.layer.cornerRadius = 10
        chooseButton.layer.masksToBounds = true
        chooseButton.clipsToBounds = true
    }
    
    private func makeHorizontalStack(with views: [UIView], spacing: CGFloat) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.spacing = spacing
        return stack
    }
    
    private func makeLabel(of size: CGFloat, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.font = isBold ? .boldSystemFont(ofSize: size) : .systemFont(ofSize: size)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    func setup(name: String?, introduction: String?, vehicle: String?, rating: String?, value: String?) {
        self.name.text = name ?? ""
        self.introduction.text = introduction ?? ""
        self.vehicle.text = vehicle ?? ""
        self.rating.text = rating ?? ""
        self.value.text = value ?? ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.name.text = nil
        self.introduction.text = nil
        self.vehicle.text = nil
        self.rating.text = nil
        self.value.text = nil
    }
}

extension DriversCell: CodableView {
    func buildViewHierarchy() {
        let ratingContainer = makeHorizontalStack(with: [star, rating], spacing: 4)
        ratingContainer.alignment = .trailing
        let driverInfoContainer = makeHorizontalStack(with: [name, ratingContainer], spacing: 8)
        driverInfoContainer.alignment = .leading
        contentContainer.addArrangedSubview(driverInfoContainer)
        contentContainer.addArrangedSubview(introduction)
        let valueContainer = makeHorizontalStack(with: [value, chooseButton], spacing: 8)
        contentContainer.addArrangedSubview(valueContainer)
        contentView.addSubview(contentContainer)
    }
    
    func setupConstraints() {
        rating.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(20)
        }
        star.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        chooseButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(100)
        }
        contentContainer.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func setupAdditionalConfiguration() {
        name.setContentHuggingPriority(.required, for: .vertical)
        introduction.setContentHuggingPriority(.required, for: .vertical)
        vehicle.setContentHuggingPriority(.required, for: .vertical)
    }
}
