//
//  ColumnData.swift
//  
//
//  Created by Eric DeLabar on 12/30/22.
//

import SwiftUI

public protocol ColumnData: Equatable {
    var fillColumn: Bool { get }
    var alignment: Alignment { get }
}
