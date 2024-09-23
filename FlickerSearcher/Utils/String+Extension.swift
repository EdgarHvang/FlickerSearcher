//
//  Helper.swift
//  FlickerSearcher
//
//  Created by Qiyao Huang on 9/23/24.
//

import Foundation

extension String {
    func formatPublishedDate() -> String? {
        let inputFormatter = ISO8601DateFormatter()
        guard let date = inputFormatter.date(from: self) else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .none
        
        return outputFormatter.string(from: date)
    }
}

