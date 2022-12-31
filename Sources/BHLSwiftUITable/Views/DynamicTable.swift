//
//  DynamicTable.swift
//  
//
//  Created by Eric DeLabar on 12/30/22.
//

import SwiftUI
import BHLSwiftUIHelpers

public struct DynamicTable<ColumnContent: View, TableColumnValue: ColumnData>: View {
    
    let table: TableDefinition<TableColumnValue>
    let headerPadding: CSSPadding
    let headerPrimaryBackgroundColor: Color
    let headerObscuringBackgroundColor: Color
    let stripeColor: Color
    let columnBuilder: (TableColumnValue, String) -> ColumnContent
    @State private var maxColumnWidths: [CGFloat] = []
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                IndexedForEach(table.rows) { row, index in
                    DynamicTableRow(row.columns, maxColumnWidths: $maxColumnWidths, background: index % 2 != 0 ? stripeColor : stripeColor.opacity(0.25)) { column, _ in
                        columnBuilder(column.value, row.id)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .safeAreaInset(edge: .top, spacing: 1) {
            DynamicTableRow(
                table.headers,
                maxColumnWidths: $maxColumnWidths,
                background: headerPrimaryBackgroundColor
            ) { header, _ in
                Text(header.title)
                    .font(.headline)
                    .cssPadding(headerPadding)
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
        headerPadding: CSSPadding = [4, 12],
        headerPrimaryBackgroundColor: Color = Color.black.opacity(0.1),
        headerObscuringBackgroundColor: Color = Color.white.opacity(0.9),
        stripeColor: Color = Color.black.opacity(0.05),
        @ViewBuilder columnBuilder: @escaping (TableColumnValue, String) -> ColumnContent
    ) {
        self.table = table
        self.headerPadding = headerPadding
        self.headerPrimaryBackgroundColor = headerPrimaryBackgroundColor
        self.headerObscuringBackgroundColor = headerObscuringBackgroundColor
        self.stripeColor = stripeColor
        self.columnBuilder = columnBuilder
    }
}
