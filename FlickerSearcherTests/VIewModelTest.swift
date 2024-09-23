//
//  VIewModelTest.swift
//  FlickerSearcherTests
//
//  Created by Qiyao Huang on 9/23/24.
//

import XCTest
import Combine
@testable import FlickerSearcher

final class ItemViewModelTests: XCTestCase {
    var viewModel: ItemViewModel!
    var mockService: MockService!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockService = MockService()
        viewModel = ItemViewModel(itemService: mockService)
    }
    
    override func tearDown() {
        cancellables = []
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchItemsSuccess() {
        let expectedItems = [Item(title: "Testxx", link: URL(string: "http://fsdafsld.com")!, description: "Description", author: "Eddie Huang", published: "Sep 23, 2024", media: Media(m: URL(string: "fdsalfsdj")!))]
        let searchResponse = SearchResponse(title: "Test", description: "Description", items: expectedItems)
        let mockData = try? JSONEncoder().encode(searchResponse)
        mockService.mockData = mockData
        
        let expectation = XCTestExpectation(description: "Fetch items successfully")
        viewModel.fetchItems(with: "test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.items?.count, 1)
            XCTAssertEqual(self.viewModel.items?.first?.title, "Testxx")
            XCTAssertNil(self.viewModel.errorMessage)
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchItemsEmptySearch() {
        let expectation = XCTestExpectation(description: "Handle empty search")
        
        viewModel.fetchItems(with: "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.errorMessage, "please enter your keyword")
            XCTAssertNil(self.viewModel.items)
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchItemsError() {
        mockService.shouldReturnError = true
        
        let expectation = XCTestExpectation(description: "Handle fetch error")
        viewModel.fetchItems(with: "test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertNil(self.viewModel.items)
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
