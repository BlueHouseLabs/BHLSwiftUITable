//
//  ColumnWidthsPreferenceKey.swift
//  
//
//  Created by Eric DeLabar on 12/30/22.
//

import SwiftUI
import BHLSwiftHelpers

struct ColumnWidthsPreferenceKey: PreferenceKey {
    static let defaultValue: [CGFloat] = []
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        let next = nextValue()
        for i in 0..<next.count {
            let currentWidth = value.getOrDefaultValue(index: i) ?? 0
            let nextWidth = next[i]
            let newMax = max(currentWidth, nextWidth)
            value.setOrAppend(index: i, value: newMax)
        }
    }
}
