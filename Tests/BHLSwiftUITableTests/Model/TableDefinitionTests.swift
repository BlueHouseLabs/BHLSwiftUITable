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
        let fillColumn: Bool
    }

    func testRowHeaders() throws {
        
        let cut = TableDefinition<TestColumnData>.Row(
            id: UUID().uuidString,
            columns: [
                TableDefinition<TestColumnData>.Column(
                    id: UUID(),
                    objectId: "1",
                    fillColumn: true,
                    value: TestColumnData(
                        data: "1",
                        alignment: .center,
                        fillColumn: true
                    )
                ),
                TableDefinition<TestColumnData>.Column(
                    id: UUID(),
                    objectId: "2",
                    fillColumn: false,
                    value: TestColumnData(
                        data: "2",
                        alignment: .leading,
                        fillColumn: false
                    )
                ),
            ]
        )
        
        XCTAssertEqual(cut.headers(withTitles: ["One"], fillColumnIndex: 0), [
            TableDefinition<TestColumnData>.Header(
                title: "One",
                fillColumn: true,
                alignment: .center
            ),
            TableDefinition<TestColumnData>.Header(
                title: "",
                fillColumn: false,
                alignment: .leading
            ),
        ])
        
    }
    
    func testColumnAlignment() throws {
        
        let cutLeading = TableDefinition<TestColumnData>.Column(
            id: UUID(),
            objectId: "2",
            fillColumn: true,
            value: TestColumnData(
                data: "2",
                alignment: .leading,
                fillColumn: false
            )
        )
        XCTAssertEqual(cutLeading.alignment, .leading)
        
        let cutTrailing = TableDefinition<TestColumnData>.Column(
            id: UUID(),
            objectId: "2",
            fillColumn: true,
            value: TestColumnData(
                data: "2",
                alignment: .trailing,
                fillColumn: false
            )
        )
        XCTAssertEqual(cutTrailing.alignment, .trailing)
            
        let cutCenter = TableDefinition<TestColumnData>.Column(
            id: UUID(),
            objectId: "2",
            fillColumn: true,
            value: TestColumnData(
                data: "2",
                alignment: .center,
                fillColumn: false
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
                            alignment: .center,
                            fillColumn: false
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
                            alignment: .trailing,
                            fillColumn: false
                        ),
                        TestColumnData(
                            data: "2",
                            alignment: .leading,
                            fillColumn: true
                        )
                    ]
                ),
                TableDefinition<TestColumnData>.TableColumnRow(
                    id: "MyId2",
                    values: [
                        TestColumnData(
                            data: "3",
                            alignment: .trailing,
                            fillColumn: false
                        ),
                        TestColumnData(
                            data: "4",
                            alignment: .leading,
                            fillColumn: true
                        )
                    ]
                )
            ]
        )
        
        XCTAssertEqual(cut.id, tableId)
        
        XCTAssertEqual(cut.rows.map { $0.id }, ["MyId1", "MyId2"])
        XCTAssertEqual(cut.rows.map { $0.columns.map { $0.value.data } }, [["1", "2"], ["3", "4"]])
        XCTAssertEqual(cut.rows.map { $0.columns.map { $0.value.alignment } }, [[.trailing, .leading], [.trailing, .leading]])
        XCTAssertEqual(cut.rows.map { $0.columns.map { $0.fillColumn } }, [[false, true], [false, true]])
        
        XCTAssertEqual(cut.headers, [
            TableDefinition<TestColumnData>.Header(
                title: "First",
                fillColumn: false,
                alignment: .trailing
            ),
            TableDefinition<TestColumnData>.Header(
                title: "",
                fillColumn: true,
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
    
    func testInit_FillColumnIndex() throws {
        
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
                            alignment: .trailing,
                            fillColumn: false
                        ),
                        TestColumnData(
                            data: "2",
                            alignment: .leading,
                            fillColumn: false
                        )
                    ]
                ),
                TableDefinition<TestColumnData>.TableColumnRow(
                    id: "MyId2",
                    values: [
                        TestColumnData(
                            data: "3",
                            alignment: .trailing,
                            fillColumn: false
                        ),
                        TestColumnData(
                            data: "4",
                            alignment: .leading,
                            fillColumn: false
                        )
                    ]
                )
            ],
            fillColumnIndex: 1
        )
        
        XCTAssertEqual(cut.id, tableId)
        
        XCTAssertEqual(cut.rows.map { $0.id }, ["MyId1", "MyId2"])
        XCTAssertEqual(cut.rows.map { $0.columns.map { $0.value.data } }, [["1", "2"], ["3", "4"]])
        XCTAssertEqual(cut.rows.map { $0.columns.map { $0.value.alignment } }, [[.trailing, .leading], [.trailing, .leading]])
        XCTAssertEqual(cut.rows.map { $0.columns.map { $0.fillColumn } }, [[false, true], [false, true]])
        
        XCTAssertEqual(cut.headers, [
            TableDefinition<TestColumnData>.Header(
                title: "First",
                fillColumn: false,
                alignment: .trailing
            ),
            TableDefinition<TestColumnData>.Header(
                title: "",
                fillColumn: true,
                alignment: .leading
            ),
        ])
        
    }

}
