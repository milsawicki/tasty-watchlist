//
//  AddWatchlistItemViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import Combine
import UIKit
import XCoordinator

final class SearchSymbolViewModel {
    @Published var searchTextFieldValue: String = ""
    @Published var searchResult: AsyncResult<[SearchSymbolResponse], Error> = .pending
    private let service: WatchlistService
    private let watchlistStorage: WatchlistStorageProtocol
    private var cancellables = [AnyCancellable]()
    private var watchlistId: UUID
    private var router: WeakRouter<AppRoute>
    private var addSymbolCompletion: () -> ()
    init(
        service: WatchlistService,
        watchlistStorage: WatchlistStorageProtocol,
        router: WeakRouter<AppRoute>,
        watchlistId: UUID,
        addSymbolCompletion: @escaping () -> ()
    ) {
        self.watchlistStorage = watchlistStorage
        self.service = service
        self.watchlistId = watchlistId
        self.router = router
        self.addSymbolCompletion = addSymbolCompletion
    }

    func bind(query: AnyPublisher<String, Never>) {
        query
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.global())
            .flatMap { [weak self] symbol in
                guard let self = self else { return Empty<[SearchSymbolResponse], Error>().eraseToAnyPublisher() }
                return self.service.searchSymbol(for: symbol).eraseToAnyPublisher()
            }
            .asResult()
            .assign(to: &$searchResult)
    }

    func addSymbolToWatchlist(_ symbol: String) {
        watchlistStorage.addSymbol(to: watchlistId, symbol: symbol)
        router.trigger(.dismiss)
        addSymbolCompletion()
    }
}
