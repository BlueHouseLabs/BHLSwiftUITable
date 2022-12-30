//
//  TableDefinition.swift
//  
//
//  Created by Eric DeLabar on 12/30/22.
//

import SwiftUI

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
        
        func headers(withTitles titles: [String]) -> [Header] {
            var headers = [Header]()
            for i in 0..<columns.count {
                headers.append(Header(title: titles.getOrDefaultValue(index: i) ?? "", alignment: columns[i].alignment))
            }
            return headers
        }
    }
    
    struct Column: Identifiable, Equatable, ColumnData {
        let id: UUID
        let objectId: String
        let padding: Bool
        let value: TableColumnValue
        
        var alignment: Alignment {
            value.alignment
        }
    }
    
    struct Header: ColumnData {
        let title: String
        let alignment: Alignment
    }
    
    public let id: String
    let headers: [Header]
    let rows: [Row]
    
    var isEmpty: Bool {
        rows.isEmpty
    }
    
    public init(
        id: String,
        headers headerTitles: [String],
        rows inputRows: [TableColumnRow]
    ) {
        self.id = id
        
        let rows = inputRows.map { row in
            Row(
                id: row.id,
                columns: (row.values).map { value in
                    Column(id: UUID(), objectId: row.id, padding: true, value: value)
                }
            )
        }
        
        self.rows = rows
        self.headers = rows.first?.headers(withTitles: headerTitles) ?? []
    }
}

extension TableDefinition: Identifiable {}
extension TableDefinition: Equatable {}
