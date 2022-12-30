//
//  DynamicTable.swift
//  
//
//  Created by Eric DeLabar on 12/30/22.
//

import SwiftUI

struct DynamicTable<ColumnContent: View, TableColumnValue: ColumnData>: View {
    
    let table: TableDefinition<TableColumnValue>
    let columnBuilder: (TableColumnValue, String) -> ColumnContent
    @State private var maxColumnWidths: [CGFloat] = []
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(table.rows) { row in
                    DynamicTableRow(row.columns, maxColumnWidths: $maxColumnWidths) { column, _ in
                        columnBuilder(column.value, row.id)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .safeAreaInset(edge: .top) {
            DynamicTableRow(table.headers, maxColumnWidths: $maxColumnWidths, background: Color.black.opacity(0.1)) { header, _ in
                Text(header.title)
                    .font(.headline)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
            }
            .background {
                Color.white.opacity(0.9)
            }
        }
        .onPreferenceChange(ColumnWidthsPreferenceKey.self) {
            maxColumnWidths = $0
        }
    }
    
    init(table: TableDefinition<TableColumnValue>, @ViewBuilder columnBuilder: @escaping (TableColumnValue, String) -> ColumnContent) {
        self.table = table
        self.columnBuilder = columnBuilder
    }
}
