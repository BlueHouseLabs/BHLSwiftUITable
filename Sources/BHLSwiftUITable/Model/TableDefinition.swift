//
//  TableDefinition.swift
//  
//
//  Created by Eric DeLabar on 12/30/22.
//

import SwiftUI
import BHLSwiftHelpers

public struct TableDefinition<TableColumnValue: ColumnData> {
    
    public struct TableColumnRow: Identifiable {
        public let id: String
        let values: [TableColumnValue]
        
        public init(id: String, values: [TableColumnValue]) {
            self.id = id
            self.values = values
        }
    }
    
    struct Row: Identifiable, Equatable {
        let id: String
        let columns: [Column]
        
        func headers(withTitles titles: [String], fillColumnIndex: Int) -> [Header] {
            var headers = [Header]()
            for i in 0..<columns.count {
                headers.append(Header(title: titles.getOrDefaultValue(index: i) ?? "", fillColumn: i == fillColumnIndex, alignment: columns[i].alignment))
            }
            return headers
        }
    }
    
    struct Column: Identifiable, Equatable, ColumnData {
        let id: UUID
        let objectId: String
        let fillColumn: Bool
        let value: TableColumnValue
        
        var alignment: Alignment {
            value.alignment
        }
    }
    
    struct Header: ColumnData {
        let title: String
        let fillColumn: Bool
        let alignment: Alignment
    }
    
    public let id: String
    let headers: [Header]
    let rows: [Row]
    
    public var rowCount: Int {
        rows.count
    }
    
    public var isEmpty: Bool {
        rows.isEmpty
    }
    
    public init(
        id: String,
        headers headerTitles: [String],
        rows inputRows: [TableColumnRow],
        fillColumnIndex passedFillColumnIndex: Int? = nil
    ) {
        self.id = id
        
        var fillColumnIndex = 0
        if let passedFillColumnIndex {
            fillColumnIndex = passedFillColumnIndex
        } else if let firstRow = inputRows.first {
            fillColumnIndex = firstRow.values.firstIndex { $0.fillColumn } ?? 0
        }
        
        let rows = inputRows.map { row in
            Row(
                id: row.id,
                columns: row.values.indexedMap { value, index in
                    Column(id: UUID(), objectId: row.id, fillColumn: index == fillColumnIndex, value: value)
                }
            )
        }
        
        self.rows = rows
        self.headers = rows.first?.headers(withTitles: headerTitles, fillColumnIndex: fillColumnIndex) ?? []
    }
}

extension TableDefinition: Identifiable {}
extension TableDefinition: Equatable {}
