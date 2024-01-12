//
//  DynamicTableRow.swift
//  
//
//  Created by Eric DeLabar on 12/30/22.
//

import SwiftUI
import BHLSwiftUIHelpers

import BHLSwiftUITableModel

struct DynamicTableRow<Data: ColumnData & Identifiable, CellContent: View>: View {
    
    let data: [Data]
    let spacing: CGFloat?
    let backgroundColor: Color
    let debugCellColor: Color
    @Binding private var maxColumnWidths: [CGFloat]
    @ViewBuilder let cellBuilder: (Data, Int) -> CellContent
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            IndexedForEach(data) { value, index in
                cell(value, index: index, fill: value.fillColumn)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .transition(.asymmetric(insertion: .move(edge: .top), removal: .scale(scale: 0.0, anchor: .top).combined(with: .opacity)))
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
                .font(.subheadline)
                .background { debugCellColor }
            if fill {
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
        .frame(width: fill ? nil : maxColumnWidths.getOrDefaultValue(index: index), alignment: value.alignment)
        .background {
            GeometryReader { geometry in
                backgroundColor
                    .transition(.opacity)
                    .preference(
                        key: ColumnWidthsPreferenceKey.self,
                        value: ([CGFloat](repeating: 0, count: index)) + [geometry.size.width]
                    )
            }
        }
    }
}
