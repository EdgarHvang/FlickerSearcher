//
//  DetailView.swift
//  FlickerSearcher
//
//  Created by Qiyao Huang on 9/23/24.
//

import SwiftUI

struct DetailView: View {
    let item: Item
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(item.title)
                    .font(.largeTitle)
                    .padding()
                
                AsyncImage(url: item.media.m) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
                
                Text(item.description)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text("By \(item.author)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                if let formattedDate = item.published.formatPublishedDate() {
                    Text("Published on \(formattedDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}
