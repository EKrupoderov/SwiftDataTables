//
//  DataHeaderFooter.swift
//  SwiftDataTables
//
//  Created by Pavan Kataria on 22/02/2017.
//  Copyright © 2017 Pavan Kataria. All rights reserved.
//

import UIKit

class DataHeaderFooter: UICollectionReusableView {
    
    let titleLabel = UILabel()
    let sortingImageView = UIImageView()


    //MARK: - Events
    var didTapEvent: (() -> Void)? = nil

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.clipsToBounds = false
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        addSubview(titleLabel)
        addSubview(sortingImageView)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(DataHeaderFooter.didTapView))
        addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sortingImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: DataHeaderFooterViewModel.Properties.labelVerticalMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DataHeaderFooterViewModel.Properties.labelHorizontalMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DataHeaderFooterViewModel.Properties.labelVerticalMargin),
            sortingImageView.widthAnchor.constraint(equalToConstant: DataHeaderFooterViewModel.Properties.imageViewWidthConstant),
            sortingImageView.widthAnchor.constraint(equalTo: sortingImageView.heightAnchor, multiplier: DataHeaderFooterViewModel.Properties.imageViewAspectRatio),
            sortingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            sortingImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DataHeaderFooterViewModel.Properties.imageViewHorizontalMargin),
            sortingImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: DataHeaderFooterViewModel.Properties.separator),
        ])
    }
    
    func configure(viewModel: DataHeaderFooterViewModel) {
        self.titleLabel.text = viewModel.data
        self.titleLabel.font = viewModel.font
        self.titleLabel.textColor = viewModel.fontColor
        self.sortingImageView.image = viewModel.imageForSortingElement
        self.sortingImageView.tintColor = viewModel.tintColorForSortingElement
    }
    @objc func didTapView(){
        self.didTapEvent?()
    }
}
