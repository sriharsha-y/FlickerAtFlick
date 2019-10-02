//
//  EncoderTests.swift
//  FlickerAtFlickTests
//
//  Created by sriharshay on 02/10/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import XCTest
@testable import FlickerAtFlick

class EncoderTests: XCTestCase {

    private var request: URLRequest!
    
    override func setUp() {
        self.request = URLRequest(url: URL(string: "https://test.com/")!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURLEncodedParameters() {
        try! URLParameterEncoder.encode(urlRequest: &request, with: ["testKey1":"testValue1", "testKey2": "testValue2"])
        XCTAssert(self.request.url!.absoluteString.contains("testKey1=testValue1"))
        XCTAssert(self.request.url!.absoluteString.contains("testKey2=testValue2"))
        XCTAssertEqual(self.request.allHTTPHeaderFields!["Content-Type"], "application/x-www-form-urlencoded; charset=utf-8")
    }
    
    func testJSONEncodedParameters() {
        try! JSONParameterEncoder.encode(urlRequest: &request, with: ["testKey1":"testValue1", "testKey2": "testValue2"])
        let jsonAsData = try! JSONSerialization.data(withJSONObject: ["testKey1":"testValue1", "testKey2": "testValue2"], options: .prettyPrinted)
        XCTAssertEqual(self.request.httpBody!, jsonAsData)
        XCTAssertEqual(self.request.allHTTPHeaderFields!["Content-Type"], "application/json")
    }
}
