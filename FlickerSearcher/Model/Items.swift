//
//  Items.swift
//  FlickerSearcher
//
//  Created by Qiyao Huang on 9/23/24.
//

import Foundation

struct SearchResponse: Codable {
    let title: String
    let description: String
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let link: URL
    let description: String
    let author: String
    let published: String
    let media: Media
}

struct Media: Codable {
    let m: URL
}
