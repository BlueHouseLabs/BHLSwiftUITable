//
//  DynamicTableRow.swift
//  
//
//  Created by Eric DeLabar on 12/30/22.
//

import SwiftUI
import BHLSwiftUIHelpers

struct DynamicTableRow<Data: ColumnData, CellContent: View>: View {
    
    let data: [Data]
    let spacing: CGFloat?
    let backgroundColor: Color
    let debugCellColor: Color
    @Binding private var maxColumnWidths: [CGFloat]
    @ViewBuilder let cellBuilder: (Data, Int) -> CellContent
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            IndexedForEach(data) { value, index in
                cell(value, index: index, fill: index == 0)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    init(
        _ data: [Data],
        maxColumnWidths: Binding<[CGFloat]>,
        spacing: CGFloat? = 1,
        background: Color = Color.clear,
        debugCellColor: Color = Color.clear,
        @ViewBuilder cellBuilder: @escaping (Data, Int) -> CellContent
    ) {
        self.data = data
        self._maxColumnWidths = maxColumnWidths
        self.spacing = spacing
        self.backgroundColor = background
        self.debugCellColor = debugCellColor
        self.cellBuilder = cellBuilder
    }
    
    func cell(_ value: Data, index: Int, fill: Bool = true) -> some View {
        HStack(alignment: .top, spacing: 0) {
            cellBuilder(value, index)
                .background { debugCellColor }
            if fill {
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
        .frame(width: index == 0 ? nil : maxColumnWidths.getOrDefaultValue(index: index), alignment: value.alignment)
        .background {
            GeometryReader { geometry in
                backgroundColor
                    .preference(
                        key: ColumnWidthsPreferenceKey.self,
                        value: ([CGFloat](repeating: 0, count: index)) + [geometry.size.width]
                    )
            }
        }
    }
}
