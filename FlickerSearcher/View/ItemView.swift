//
//  ItemView.swift
//  FlickerSearcher
//
//  Created by Qiyao Huang on 9/23/24.
//

import SwiftUI

struct ItemView: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.title)
                .font(.headline)
                .lineLimit(2)
            
            AsyncImage(url: item.media.m) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
            }
            
            Text(item.description)
                .font(.body)
                .lineLimit(3)
                .foregroundColor(.secondary)
            
            Text("By \(item.author)")
                .font(.footnote)
                .foregroundColor(.gray)
            
            if let formattedDate = item.published.formatPublishedDate() {
                Text("Published on \(formattedDate)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            NavigationLink(destination: DetailView(item: item)) {
                Text("View Details")
                    .fontWeight(.medium)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(maxWidth: 150, maxHeight: 60)
            }
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .transition(.slide) 
    }
}
