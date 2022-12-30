//
//  DynamicTable.swift
//  
//
//  Created by Eric DeLabar on 12/30/22.
//

import SwiftUI

public struct DynamicTable<ColumnContent: View, TableColumnValue: ColumnData>: View {
    
    let table: TableDefinition<TableColumnValue>
    let headerPrimaryBackgroundColor: Color
    let headerObscuringBackgroundColor: Color
    let columnBuilder: (TableColumnValue, String) -> ColumnContent
    @State private var maxColumnWidths: [CGFloat] = []
    
    public var body: some View {
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
            DynamicTableRow(
                table.headers,
                maxColumnWidths: $maxColumnWidths,
                background: headerPrimaryBackgroundColor
            ) { header, _ in
                Text(header.title)
                    .font(.headline)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
            }
            .background {
                headerObscuringBackgroundColor
            }
        }
        .onPreferenceChange(ColumnWidthsPreferenceKey.self) {
            maxColumnWidths = $0
        }
    }
    
    public init(
        table: TableDefinition<TableColumnValue>,
        headerPrimaryBackgroundColor: Color = Color.black.opacity(0.1),
        headerObscuringBackgroundColor: Color = Color.white.opacity(0.9),
        @ViewBuilder columnBuilder: @escaping (TableColumnValue, String) -> ColumnContent
    ) {
        self.table = table
        self.headerPrimaryBackgroundColor = headerPrimaryBackgroundColor
        self.headerObscuringBackgroundColor = headerObscuringBackgroundColor
        self.columnBuilder = columnBuilder
    }
}
