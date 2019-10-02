//
//  FlickerAtFlickTests.swift
//  FlickerAtFlickTests
//
//  Created by sriharshay on 28/09/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import XCTest
@testable import FlickerAtFlick

class FlickerImageSearchViewModelTests: XCTestCase {
    
    fileprivate var vieModel: FlickerImageSearchViewModel<MockRouter>!

    override func setUp() {
        self.vieModel = FlickerImageSearchViewModel(router: MockRouter())
    }

    override func tearDown() {
        self.vieModel = nil
    }
    
    func testInitialStateOfFlickerImageSearchModel() {
        // Given
        
        // When
        
        // Then
        XCTAssertEqual(self.vieModel.flickerImageSearchModel.photos.photo.count, 0)
        XCTAssertEqual(self.vieModel.flickerImageSearchModel.photos.page, 1)
        XCTAssertEqual(self.vieModel.flickerImageSearchModel.photos.pages, 0)
        XCTAssertEqual(self.vieModel.flickerImageSearchModel.photos.perpage, 0)
        XCTAssertEqual(self.vieModel.flickerImageSearchModel.photos.total, "0")
    }

    func testNewResultsAreAppendedToFlickerImageSearchModel() {
        // Given
        let expectaion = self.expectation(description: "Check First Model")
        self.vieModel.searchFor(image: "test")

        // When
        self.vieModel.notifyCollectionReload = {
            expectaion.fulfill()
        }

        // Then
        wait(for: [expectaion], timeout: 5.0)
        print(self.vieModel.flickerImageSearchModel)
        XCTAssertEqual(self.vieModel.flickerImageSearchModel.photos.photo.count, 1)
        XCTAssertEqual(self.vieModel.flickerImageSearchModel.photos.photo[0].id, "1")
        XCTAssertEqual(self.vieModel.flickerImageSearchModel.photos.photo[0].secret, "123")
        XCTAssertEqual(self.vieModel.flickerImageSearchModel.photos.photo[0].server, "ggh")
        XCTAssertEqual(self.vieModel.flickerImageSearchModel.photos.photo[0].farm, 00)
    }

}

fileprivate class MockRouter: NetworkRouter {
    
    func request(_ route: EndPointType, completion: @escaping NetworkRouterCompletion) {
        let firstPage = FlickerImageSearchModel(photos: FlickerImageSearchModel.FlickerImageSearchPageModel(page: 1, pages: 2, perpage: 1, total: "2", photo: [
           FlickerImageModel(id: "1", owner: nil, secret: "123", server: "ggh", farm: 00, title: nil, ispublic: 0, isfriend: 0, isfamily: 0)
        ]))
        do {
            let data = try JSONEncoder().encode(firstPage)
            completion(data,nil,nil)
        }
        catch{
            
        }
    }
    
    func cancel() {
        return
    }
}
