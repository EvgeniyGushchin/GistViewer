//
//  CodableTests.swift
//  GistViewerTests
//
//  Created by Evgeniy Gushchin on 4/30/25.
//

import XCTest
@testable import GistViewer

final class CodableTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGistFile() throws {
        let testBundle = Bundle(for: type(of: self))
        let url = try XCTUnwrap(testBundle.url(forResource: "GistFile", withExtension: "json"), "GistFile.json not found in bundle")
        
        let data = try Data(contentsOf: url)
        let gistFile = try XCTUnwrap(try? JSONDecoder()
          .decode(GistFile.self, from: data), "Fail to decode GistFile.json")
        
        XCTAssert(gistFile.filename == "output_log.txt")
        XCTAssert(gistFile.language == "Text")
        XCTAssert(gistFile.rawUrlString == "https://gist.githubusercontent.com/HugsLibRecordKeeper/ce2d8a1cf6280b100d6dfb9fba839a3c/raw/e592947eae5706cf1e6efbcb9abeba917dac0a3c/output_log.txt")
        XCTAssert(gistFile.type == "text/plain")
        XCTAssert(gistFile.size == 379613)
        
    }
    
    func testGistUser() throws {
        let testBundle = Bundle(for: type(of: self))
        let url = try XCTUnwrap(testBundle.url(forResource: "GistUser", withExtension: "json"), "GistUserJSON.json not found in bundle")
        
        let data = try Data(contentsOf: url)
        let gistUser = try XCTUnwrap(try? JSONDecoder()
          .decode(GistUser.self, from: data), "Fail to decode GistUser.json")
        
        XCTAssert(gistUser.login == "HugsLibRecordKeeper")
        XCTAssert(gistUser.id == 23506375)
        XCTAssert(gistUser.nodeId == "MDQ6VXNlcjIzNTA2Mzc1")
        XCTAssert(gistUser.avatarUrlString == "https://avatars.githubusercontent.com/u/23506375?v=4")
        XCTAssert(gistUser.gravatarId == "")
        XCTAssert(gistUser.urlString == "https://api.github.com/users/HugsLibRecordKeeper")
        XCTAssert(gistUser.htmlUrlString == "https://github.com/HugsLibRecordKeeper")
        XCTAssert(gistUser.gistsUrlString == "https://api.github.com/users/HugsLibRecordKeeper/gists{/gist_id}")
        
    }
    
    func testGist() throws {
        let testBundle = Bundle(for: type(of: self))
        let url = try XCTUnwrap(testBundle.url(forResource: "Gist", withExtension: "json"), "Gist.json not found in bundle")
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let gists = try XCTUnwrap(try? decoder
          .decode([Gist].self, from: data), "Fail to decode Gist.json")
        XCTAssertEqual(gists.count, 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
