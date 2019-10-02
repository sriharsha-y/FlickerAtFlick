//
//  ImageApiTests.swift
//  FlickerAtFlickTests
//
//  Created by sriharshay on 02/10/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import XCTest
@testable import FlickerAtFlick

class ImageAPITests: XCTestCase {
    
    private var imageAPI: ImagesAPI!

    override func setUp() {
    }

    override func tearDown() {
        self.imageAPI = nil
    }

    func testSearchImagesEndpointConfiguration() {
        self.imageAPI = .searchImage(text: "test", pageNumber: 1)
        
        XCTAssertEqual(self.imageAPI.baseURL.absoluteString, "https://api.flickr.com/")
        XCTAssertEqual(self.imageAPI.path, "services/rest/")
        XCTAssertEqual(self.imageAPI.headers.count, 0)
        XCTAssertEqual(self.imageAPI.httpMethod.rawValue, "GET")
        XCTAssertTrue("\(self.imageAPI.task)".contains("requestParameters"))
    }
    
    func testDownloadImagesEndpointConfiguration() {
        self.imageAPI = .downloadImage(url: URL(string: "https://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg")!)
        
        XCTAssertEqual(self.imageAPI.baseURL.absoluteString, "https://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg")
        XCTAssertEqual(self.imageAPI.path, "")
        XCTAssertEqual(self.imageAPI.headers.count, 0)
        XCTAssertEqual(self.imageAPI.httpMethod.rawValue, "GET")
        XCTAssertEqual("\(self.imageAPI.task)", "request")
    }
}
