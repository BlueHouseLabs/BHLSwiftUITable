//
//  TableDefinitionTests.swift
//  
//
//  Created by Eric DeLabar on 12/30/22.
//

import XCTest
import SwiftUI
@testable import BHLSwiftUITable

final class TableDefinitionTests: XCTestCase {
    
    private struct TestColumnData: ColumnData {
        let data: String
        let alignment: Alignment
    }

    func testRowHeaders() throws {
        
        let cut = TableDefinition<TestColumnData>.Row(
            id: UUID().uuidString,
            columns: [
                TableDefinition<TestColumnData>.Column(
                    id: UUID(),
                    objectId: "1",
                    padding: true,
                    value: TestColumnData(
                        data: "1",
                        alignment: .center
                    )
                ),
                TableDefinition<TestColumnData>.Column(
                    id: UUID(),
                    objectId: "2",
                    padding: true,
                    value: TestColumnData(
                        data: "2",
                        alignment: .leading
                    )
                ),
            ]
        )
        
        XCTAssertEqual(cut.headers(withTitles: ["One"]), [
            TableDefinition<TestColumnData>.Header(
                title: "One",
                alignment: .center
            ),
            TableDefinition<TestColumnData>.Header(
                title: "",
                alignment: .leading
            ),
        ])
        
    }
    
    func testColumnAlignment() throws {
        
        let cutLeading = TableDefinition<TestColumnData>.Column(
            id: UUID(),
            objectId: "2",
            padding: true,
            value: TestColumnData(
                data: "2",
                alignment: .leading
            )
        )
        XCTAssertEqual(cutLeading.alignment, .leading)
        
        let cutTrailing = TableDefinition<TestColumnData>.Column(
            id: UUID(),
            objectId: "2",
            padding: true,
            value: TestColumnData(
                data: "2",
                alignment: .trailing
            )
        )
        XCTAssertEqual(cutTrailing.alignment, .trailing)
            
        let cutCenter = TableDefinition<TestColumnData>.Column(
            id: UUID(),
            objectId: "2",
            padding: true,
            value: TestColumnData(
                data: "2",
                alignment: .center
            )
        )
        XCTAssertEqual(cutCenter.alignment, .center)
    }
    
    func testIsEmpty_Empty() throws {
        
        let cut = TableDefinition<TestColumnData>(
            id: UUID().uuidString,
            headers: ["Test"],
            rows: []
        )
        
        XCTAssertTrue(cut.isEmpty)
        XCTAssertEqual(cut.rowCount, 0)
        
    }
    
    func testIsEmpty_NotEmpty() throws {
        
        let cut = TableDefinition<TestColumnData>(
            id: UUID().uuidString,
            headers: ["Test"],
            rows: [
                TableDefinition<TestColumnData>.TableColumnRow(
                    id: "MyId",
                    values: [
                        TestColumnData(
                            data: "2",
                            alignment: .center
                        )
                    ]
                )
            ]
        )
        
        XCTAssertFalse(cut.isEmpty)
        XCTAssertEqual(cut.rowCount, 1)
        
    }
    
    func testInit() throws {
        
        let tableId = UUID().uuidString
        
        let cut = TableDefinition<TestColumnData>(
            id: tableId,
            headers: ["First"],
            rows: [
                TableDefinition<TestColumnData>.TableColumnRow(
                    id: "MyId1",
                    values: [
                        TestColumnData(
                            data: "1",
                            alignment: .trailing
                        ),
                        TestColumnData(
                            data: "2",
                            alignment: .leading
                        )
                    ]
                ),
                TableDefinition<TestColumnData>.TableColumnRow(
                    id: "MyId2",
                    values: [
                        TestColumnData(
                            data: "3",
                            alignment: .trailing
                        ),
                        TestColumnData(
                            data: "4",
                            alignment: .leading
                        )
                    ]
                )
            ]
        )
        
        XCTAssertEqual(cut.id, tableId)
        
        XCTAssertEqual(cut.rows.map { $0.id }, ["MyId1", "MyId2"])
        XCTAssertEqual(cut.rows.map { $0.columns.map { $0.value.data } }, [["1", "2"], ["3", "4"]])
        XCTAssertEqual(cut.rows.map { $0.columns.map { $0.value.alignment } }, [[.trailing, .leading], [.trailing, .leading]])
        
        XCTAssertEqual(cut.headers, [
            TableDefinition<TestColumnData>.Header(
                title: "First",
                alignment: .trailing
            ),
            TableDefinition<TestColumnData>.Header(
                title: "",
                alignment: .leading
            ),
        ])
        
    }
    
    func testInit_NoRows() throws {
        
        let cut = TableDefinition<TestColumnData>(
            id: UUID().uuidString,
            headers: ["One"],
            rows: []
        )
        
        XCTAssertTrue(cut.rows.isEmpty)
        XCTAssertTrue(cut.headers.isEmpty)
        
    }

}
