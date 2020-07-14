//
//  DataStructureModel.swift
//  SwiftDataTables
//
//  Created by Pavan Kataria on 22/02/2017.
//  Copyright © 2017 Pavan Kataria. All rights reserved.
//

import Foundation


//struct DataTableColumnModel {
//    
//}
public struct DataStructureModel {
    
    //MARK: - Private Properties
    private var shouldFitTitles: Bool = true
    var columnCount: Int {
        return headerTitles.count// ?? 0
    }
    //MARK: - Public Properties
    var data = DataTableContent()
    var headerTitles = [String]()
    var footerTitles = [String]()
    var shouldFootersShowSortingElement: Bool = false
    
    private var columnAverageContentLength = [Float]()
    private var columnMaxContentWidth = [CGFloat]()
    
    //MARK: - Lifecycle
    init() {
        self.init(data: DataTableContent(), headerTitles: [String]())
    }
    
    init(
        data: DataTableContent,
        headerTitles: [String],
        footerTitles: [String] = [],
        shouldMakeTitlesFitInColumn: Bool = true,
        shouldDisplayFooterHeaders: Bool = true
        //sortableColumns: [Int] // This will map onto which column can be sortable
        ) {
        
        
        self.headerTitles = headerTitles
        let unfilteredData = data
        let sanitisedData = unfilteredData.filter({ currentRowData in
            //Trim column count for current row to the number of headers present
            let rowWithPreferredColumnCount = Array(currentRowData.prefix(upTo: self.columnCount))
            return rowWithPreferredColumnCount.count == self.columnCount
        })
        
        self.data = sanitisedData//sanitisedData
        self.shouldFitTitles = shouldMakeTitlesFitInColumn
        self.columnAverageContentLength = self.processColumnDataAverages(data: self.data)
        self.columnMaxContentWidth = self.processColumnDataMaxWidth(data: self.data)
        
        self.footerTitles = shouldDisplayFooterHeaders ? headerTitles : footerTitles

    }
    
    
    public func averageColumnDataLengthTotal() -> Float {
        return Array(0..<self.headerTitles.count).reduce(0){ $0 + self.averageDataLengthForColumn(index: $1) }
    }
    
    public func averageDataLengthForColumn(
        index: Int) -> Float {
        if self.shouldFitTitles {
            return max(self.columnAverageContentLength[index], Float(self.headerTitles[index].count))
        }
        return self.columnAverageContentLength[index]
    }
    
    public func maxDataWidthForColumn(
        index: Int) -> CGFloat {
        return self.columnMaxContentWidth[index]
    }

    //extension DataStructureModel {
    //Finds the average content length in each column
    private func processColumnDataAverages(data: DataTableContent) -> [Float] {
        var columnContentAverages = [Float]()
        for column in Array(0..<self.headerTitles.count) {
            let averageForCurrentColumn = Array(0..<data.count).reduce(0){
                let dataType: DataTableValueType = data[$1][column]
                return $0 + dataType.stringRepresentation.count
            }
            columnContentAverages.append((data.count == 0) ? 1 : Float(averageForCurrentColumn) / Float(data.count))
        }
        return columnContentAverages
    }
    
    private func processColumnDataMaxWidth(data: DataTableContent) -> [CGFloat] {
        var columnContentMaxWidth = [CGFloat]()
        for column in Array(0..<self.headerTitles.count) {
            var maxWidthForCurrentColumn: CGFloat = 0.0
            for row in Array(0..<data.count) {
                let rowData = data[row][column].stringRepresentation as NSString
                let headerData = headerTitles[column]
                let constraintRect = CGSize(width: .max, height: 50)
                let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
                
                let rowDataRect = rowData.boundingRect(with: constraintRect,
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: attributes,
                                                       context: nil)
                
                let headerDataRect = headerData.boundingRect(with: constraintRect,
                                                             options: .usesLineFragmentOrigin,
                                                             attributes: attributes,
                                                             context: nil)
                
                maxWidthForCurrentColumn = max(rowDataRect.width, headerDataRect.width + 20.0 )
            }
            columnContentMaxWidth.append((data.count == 0) ? 50 : maxWidthForCurrentColumn)
        }
        return columnContentMaxWidth
    }
    
    
    public func columnHeaderSortType(for index: Int) -> DataTableSortType {
        guard self.headerTitles[safe: index] != nil else {
            return .hidden
        }
        //Check the configuration object to see what it wants us to display otherwise return default
        return .unspecified
    }

    public func columnFooterSortType(for index: Int) -> DataTableSortType {
        guard self.footerTitles[safe: index] != nil else {
            return .hidden
        }
        //Check the configuration object to see what it wants us to display otherwise return default
        return .hidden
    }
}
