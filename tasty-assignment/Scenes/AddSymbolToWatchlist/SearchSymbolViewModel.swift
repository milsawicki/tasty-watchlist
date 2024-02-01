//
//  AddWatchlistItemViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import Combine
import UIKit

class SearchSymbolViewModel {
    private let service: WatchlistService
    @Published var searchTextFieldValue: String = ""
    @Published var searchResult: [SearchSymbolResponse] = []
    private var cancellables = [AnyCancellable]()

    init(service: WatchlistService) {
        self.service = service
    }

    func bind(query: AnyPublisher<String, Never>) {
        let searchSymbolResult = query
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.global())
            .map { self.service.searchSymbol(for: $0) }
            .switchToLatest()
            .replaceError(with: SearchSymbolItemsResponse())
            .share()

        searchSymbolResult
            .map { $0.items }
            .assign(to: &$searchResult)

    }
}
