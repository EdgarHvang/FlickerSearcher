//
//  ContentView.swift
//  FlickerSearcher
//
//  Created by Qiyao Huang on 9/23/24.
//

import SwiftUI
import Combine

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = ItemViewModel()
    @State private var search: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    TextField("Search for images", text: $search)
                        .onChange(of: search) { oldValue, newValue in
                            viewModel.searchSubject.send(newValue)
                        }
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                // Grid
                if let items = viewModel.items {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                            ForEach(items, id: \.link) { item in
                                ItemView(item: item)
                            }
                        }
                        .padding()
                    }
                } else if viewModel.isLoading {
                    ProgressView("Searching...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                Spacer()
            }
            .navigationTitle("Flickr Searcher")
            .onAppear {
                viewModel.setSearchSubject()
            }
        }
    }
}
