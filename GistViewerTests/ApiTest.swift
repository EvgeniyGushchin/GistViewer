//
//  ApiTest.swift
//  GistViewerTests
//
//  Created by Evgeniy Gushchin on 5/7/25.
//

import XCTest
@testable import GistViewer

final class ApiTest: XCTestCase {
    
    var client: ApiClientProtocol!

    override func setUpWithError() throws {
        client =  ApiClient()
    }

    override func tearDownWithError() throws {
        client = nil
    }

    func testGetPublicList() async throws {
        
        let (list, hsaMore) = try await client.fetchPublicGists(page: 0)
        XCTAssertEqual(list.count, 30)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
