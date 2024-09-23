//
//  ImageSearchService.swift
//  FlickerSearcher
//
//  Created by Qiyao Huang on 9/23/24.
//

import Foundation
import Combine

enum NetWorkError: Error {
    case invalidURL
    case statusCodeError(HTTPCode)
    case parseJsonFailed
    case unexpectedResponse
}

extension NetWorkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .statusCodeError(statusCode): return "Unexpected HTTP status code: \(statusCode)"
        case .parseJsonFailed: return "Unexpected JSON parse error"
        case .unexpectedResponse: return "Unexpected response from the server"
        }
    }
}

typealias HTTPCode = Int

typealias HTTPCodes = Range<HTTPCode>
extension HTTPCodes {
    static let success = 200 ..< 300
}

class ItemService: Service {
    
    func fetch<T>(from url: URL?) -> AnyPublisher<T, Error> where T : Decodable {
        guard let url else {
            return Fail(error: NetWorkError.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let statusCode = (output.response as? HTTPURLResponse)?.statusCode else {
                    throw NetWorkError.unexpectedResponse
                }
                guard HTTPCodes.success.contains(statusCode) else {
                    throw NetWorkError.statusCodeError(statusCode)
                }
                return output.data
            }.decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in
                NetWorkError.parseJsonFailed
            }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
