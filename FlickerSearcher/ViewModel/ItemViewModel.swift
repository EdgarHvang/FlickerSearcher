//
//  ItemViewModel.swift
//  FlickerSearcher
//
//  Created by Qiyao Huang on 9/23/24.
//

import Foundation
import Combine

class ItemViewModel: ObservableObject {
    @Published var items: [Item]?
    
    private var itemService: Service
    
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private var response: SearchResponse?
    
    private var cancellable: Set<AnyCancellable> = []
    
    var searchSubject = PassthroughSubject<String,Never>()
    
    init(itemService: Service = ItemService()) {
        self.itemService = itemService
    }
    
    func fetchItems(with search: String) {
        //        print(search.isEmpty)
        if search.isEmpty {
            errorMessage = "please enter your keyword"
            return
        }
        isLoading = true
        guard let url = URL(string:"\(Endpoint.baseURL.rawValue)"+search ) else { return }
        
        itemService.fetch(from: url)
            .sink { [weak self] completion in
                switch completion {
                case.finished: self?.isLoading = false
                case.failure(let error): self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: {[weak self] response in
                self?.response = response
                if let items = self?.response?.items {
                    self?.items = items
                }
            }.store(in: &cancellable)
    }
    
    func setSearchSubject() {
        searchSubject.debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink {[weak self] search in
                self?.fetchItems(with: search)
            }.store(in: &cancellable)
    }
}
