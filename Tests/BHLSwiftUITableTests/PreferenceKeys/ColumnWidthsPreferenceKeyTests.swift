//
//  ColumnWidthsPreferenceKeyTests.swift
//  
//
//  Created by Eric DeLabar on 12/30/22.
//

import XCTest
@testable import BHLSwiftUITable

final class ColumnWidthsPreferenceKeyTests: XCTestCase {

    func testReduce_Empty() throws {
        
        var data: [CGFloat] = []
        
        ColumnWidthsPreferenceKey.reduce(value: &data) {
            []
        }
        
        XCTAssertEqual(data, [])
    }
    
    func testReduce_NewValue() throws {
        
        var data: [CGFloat] = []
        
        ColumnWidthsPreferenceKey.reduce(value: &data) {
            [1]
        }
        
        XCTAssertEqual(data, [1])
    }
    
    func testReduce_ReplaceFirst() throws {
        
        var data: [CGFloat] = [0, 5, 10]
        
        ColumnWidthsPreferenceKey.reduce(value: &data) {
            [20]
        }
        
        XCTAssertEqual(data, [20, 5, 10])
    }
    
    func testReduce_ReplaceMiddle() throws {
        
        var data: [CGFloat] = [0, 5, 10]
        
        ColumnWidthsPreferenceKey.reduce(value: &data) {
            [0, 25]
        }
        
        XCTAssertEqual(data, [0, 25, 10])
    }
    
    func testReduce_ReplaceLast() throws {
        
        var data: [CGFloat] = [0, 5, 10]
        
        ColumnWidthsPreferenceKey.reduce(value: &data) {
            [0, 5, 20]
        }
        
        XCTAssertEqual(data, [0, 5, 20])
    }
    
    func testReduce_ReplaceAll() throws {
        
        var data: [CGFloat] = [0, 5, 10]
        
        ColumnWidthsPreferenceKey.reduce(value: &data) {
            [5, 10, 15]
        }
        
        XCTAssertEqual(data, [5, 10, 15])
    }

}
