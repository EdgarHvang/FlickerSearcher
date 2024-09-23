//
//  MockItemService.swift
//  FlickerSearcherTests
//
//  Created by Qiyao Huang on 9/23/24.
//

import Foundation
import Combine
@testable import FlickerSearcher

class MockService: Service {
    var shouldReturnError = false
    var mockData: Data?
    
    func fetch<T>(from url: URL?) -> AnyPublisher<T, Error> where T : Decodable {
        if shouldReturnError {
            return Fail(error: NetWorkError.invalidURL).eraseToAnyPublisher()
        }
        
        guard let mockData = mockData else {
            return Fail(error: NetWorkError.parseJsonFailed).eraseToAnyPublisher()
        }
        
        return Just(mockData)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in NetWorkError.parseJsonFailed }
            .eraseToAnyPublisher()
    }
}
