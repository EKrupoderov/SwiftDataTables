//
//  DataCell.swift
//  SwiftDataTables
//
//  Created by Pavan Kataria on 22/02/2017.
//  Copyright © 2017 Pavan Kataria. All rights reserved.
//

import UIKit

class DataCell: UICollectionViewCell {
    
    let dataLabel = UILabel()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dataLabel)
        NSLayoutConstraint.activate([
            //dataLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: DataCellViewModel.Properties.widthConstant),
            dataLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DataCellViewModel.Properties.verticalMargin),
            dataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DataCellViewModel.Properties.verticalMargin),
            dataLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DataCellViewModel.Properties.horizontalMargin),
            dataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DataCellViewModel.Properties.horizontalMargin),
        ])
    }
    
    func configure(_ viewModel: DataCellViewModel){
        setup()
        dataLabel.clipsToBounds = false
        dataLabel.text = viewModel.data.stringRepresentation
        dataLabel.font = viewModel.font
        dataLabel.textColor = viewModel.fontColor
    }
}
