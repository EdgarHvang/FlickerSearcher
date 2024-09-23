//
//  Service.swift
//  FlickerSearcher
//
//  Created by Qiyao Huang on 9/23/24.
//

import Foundation
import Combine

protocol Service {
    func fetch<T: Decodable>(from url: URL?) -> AnyPublisher<T, Error> where T: Decodable
}
