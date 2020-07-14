//
//  DataHeaderFooterViewModel.swift
//  SwiftDataTables
//
//  Created by Pavan Kataria on 22/02/2017.
//  Copyright © 2017 Pavan Kataria. All rights reserved.
//

import Foundation
import UIKit


public class DataHeaderFooterViewModel: DataTableSortable {

    //MARK: - Properties
    enum Properties {
        static let labelHorizontalMargin: CGFloat = 15
        static let labelVerticalMargin: CGFloat = 5
        static let separator: CGFloat = 5
        static let imageViewHorizontalMargin: CGFloat = 5
        static let labelWidthConstant: CGFloat = 40
        static let imageViewWidthConstant: CGFloat = 20
        static let imageViewAspectRatio: CGFloat = 0.75
    }
    
    let data: String
    var indexPath: IndexPath! // Questionable
    var dataTable: SwiftDataTable!
    
    var font: UIFont = UIFont.systemFont(ofSize: 17, weight: .bold)
    var fontColor: UIColor = UIColor.black
    
    public var sortType: DataTableSortType
    
    var imageStringForSortingElement: String? {
        switch self.sortType {
        case .hidden:
            return nil
        case .unspecified:
            return "column-sort-unspecified"
        case .ascending:
            return "column-sort-ascending"
        case .descending:
            return "column-sort-descending"
        }
    }
    var imageForSortingElement: UIImage? {
        guard let imageName = self.imageStringForSortingElement else {
            return nil
        }
        let bundle = Bundle(for: DataHeaderFooter.self)
        guard
            let url = bundle.url(forResource: "SwiftDataTables", withExtension: "bundle"),
            let imageBundle = Bundle(url: url),
            let imagePath = imageBundle.path(forResource: imageName, ofType: "png"),
            let image = UIImage(contentsOfFile: imagePath)?.withRenderingMode(.alwaysTemplate)
            else {
            return nil
        }
        return image
    }
    var tintColorForSortingElement: UIColor? {
        return (dataTable != nil && sortType != .unspecified) ? dataTable.options.sortArrowTintColor : UIColor.gray
    }
    
    //MARK: - Events
    
    //MARK: - Lifecycle
    init(data: String, sortType: DataTableSortType){
        self.data = data
        self.sortType = sortType
    }
    
    public func configure(dataTable: SwiftDataTable, columnIndex: Int){
        self.dataTable = dataTable
        self.indexPath = IndexPath(index: columnIndex)
    }
}

//MARK: - Header View Representable
extension DataHeaderFooterViewModel: CollectionViewSupplementaryElementRepresentable {
    static func registerHeaderFooterViews(collectionView: UICollectionView) {
        let identifier = String(describing: DataHeaderFooter.self)
        let headerNib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(headerNib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, for indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = String(describing: DataHeaderFooter.self)
        guard
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? DataHeaderFooter
            else {
                return UICollectionReusableView()
        }
        
        headerView.configure(viewModel: self)
        switch kind {
        case SwiftDataTable.SupplementaryViewType.columnHeader.rawValue:
            headerView.didTapEvent = { [weak self] in
                self?.headerViewDidTap()
            }
        case SwiftDataTable.SupplementaryViewType.footerHeader.rawValue:
            break
        default:
            break
        }
        return headerView
    }
    
    //MARK: - Events
    func headerViewDidTap(){
        self.dataTable.didTapColumn(index: self.indexPath)
    }
}

extension DataHeaderFooterViewModel {
    
    public func widthForModel(cellsWidth: CGFloat) -> CGFloat {

        var finalWidth: CGFloat = 40.0
        let words =  data.split { !$0.isLetter }
        if words.count < 2 {
            finalWidth = max(finalWidth, stringBoundingRect(data).width)
        } else if words.count > 1, let maxWord = words.max(by: { $1.count > $0.count }) {
            let wmw = stringBoundingRect(String(maxWord)).width
            var other = words
            other.removeAll(where: { $0 == maxWord })
            let wwd = stringBoundingRect(other.joined(separator: " "), width: cellsWidth).width
            finalWidth = max(wmw, wwd)
        } else {
            finalWidth = stringBoundingRect(data).width
        }
        return finalWidth
            + Properties.labelHorizontalMargin
            + Properties.imageViewHorizontalMargin
            + Properties.imageViewWidthConstant
            + Properties.separator
    }
    
    func stringBoundingRect(_ str: String, width: CGFloat = .greatestFiniteMagnitude) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let height = sortType != .hidden ? dataTable.heightForSectionHeader() : 0.0
        let size = CGSize(width: width, height: height)
        return (str as NSString).boundingRect(with: size,
                                              options: .usesLineFragmentOrigin,
                                              attributes: attributes,
                                              context: nil)
    }
    
}
