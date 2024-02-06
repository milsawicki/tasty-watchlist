//
//  WatchlistViewModel.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 04/02/2024.
//

import Combine
@testable import tasty_assignment
import XCTest

class WatchlistViewModelTests: XCTestCase {
    var mockStorage: WatchlistStorageProtocol!
    var mockCoordinator: MockAppCoordinator!
    var mockService: MockWatchlistService!
    var mockWatchlist: Watchlist!
    var sut: WatchlistViewModel!
    var mockUserDefaults: MockUserDefaults!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockService = MockWatchlistService()
        mockCoordinator = MockAppCoordinator()
        mockUserDefaults = MockUserDefaults()
        mockStorage = WatchlistStorage(userDefaults: mockUserDefaults)
        mockWatchlist = Watchlist(name: "mock")
        mockStorage.addWatchlist(mockWatchlist)
        sut = .init(
            watchlistId: mockWatchlist.id,
            service: mockService,
            watchlistStorage: mockStorage,
            router: mockCoordinator.weakRouter
        )
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        mockCoordinator = nil
        mockStorage = nil
        mockWatchlist = nil
        super.tearDown()
    }

    func test_shouldShowEmpty_whenNoSymbols_shouldReturnTrue() {
        XCTAssertTrue(sut.shouldShowEmpty)
    }

    func test_shouldShowEmptyView_whenSymbolsNotEmpty_shouldReturnFalse() {
        mockStorage.addSymbol(to: mockWatchlist.id, symbol: "AAPL")
        XCTAssertFalse(sut.shouldShowEmpty)
    }

    func test_numberOfRows_whenSymbolsPresent_shouldReturnCorrectCount() {
        mockStorage.addSymbol(to: mockWatchlist.id, symbol: "AAPL")
        mockStorage.addSymbol(to: mockWatchlist.id, symbol: "MSFT")
        XCTAssertEqual(sut.numberOfRows, 2, "Number of rows should match the number of symbols")
    }

    func test_currentWatchlistName_whenWatchlistExists_shouldReturnCorrectName() {
        XCTAssertEqual(sut.currentWatchlistName, mockWatchlist.name, "Current watchlist name should be returned")
    }

    func test_viewDidLoad_whenCalled_shouldTriggerReloadData() {
        var reloadDataCalled = false
        sut.reloadData = { reloadDataCalled = true }

        sut.viewDidLoad()
        XCTAssertTrue(reloadDataCalled, "ReloadData should be called on viewDidLoad")
    }

    func test_deleteSymbol_withValidSymbol_shouldRemoveSymbolAndReloadData() {
        mockStorage.addWatchlist(name: "Watchlist", with: ["AAPL"])

        var reloadDataCalled = false
        sut.reloadData = { reloadDataCalled = true }

        sut.delete(symbol: "AAPL")

        XCTAssertTrue(reloadDataCalled, "Reload data should be called after symbol deletion")
        XCTAssertFalse(sut.symbols.contains("AAPL"), "Symbol should be deleted")
    }

    func test_showAddSymbol_whenCalled_shouldTriggerRouter() {
        sut.showAddSymbol()
        XCTAssertEqual(mockCoordinator.lastCalledRoute, .addSymbolToWatchlist(watchlistId: mockWatchlist.id, completion: {}), "Router should be triggered for adding a symbol")
    }

    func test_manageWatchlists_whenCalled_shouldTriggerRouter() {
        sut.manageWatchlists()
        XCTAssertEqual(mockCoordinator.lastCalledRoute, .manageWatchlists, "Router should be triggered for managing watchlists")
    }

    func test_symbolForRowIndex_withValidIndex_shouldReturnCorrectSymbol() {
        let symbols = ["AAPL", "MSFT"]
        symbols.forEach { mockStorage.addSymbol(to: mockWatchlist.id, symbol: $0) }

        let rowIndex = 1
        let expectedSymbol = symbols[rowIndex]
        XCTAssertEqual(sut.symbol(for: 1), expectedSymbol, "The symbol for a given row should match the symbol in the array")
    }

    func test_FetchQuotes_shouldReturnQuotes() {
        let expectation = XCTestExpectation(description: "Debounce publisher test")

        let symbol = "AAPL"
        let expectedQuote = StockQuoteResponse(companyName: "Apple", symbol: "AAPL", bidPrice: 149, askPrice: 151, latestPrice: 150)
        mockService.expectedQuotesResponse = .just(.success(expectedQuote))

        sut.fetchQuotes(for: symbol)
            .sink { _ in
            } receiveValue: { result in
                switch result {
                case let .success(quoteResponse):
                    XCTAssertEqual(quoteResponse.symbol, symbol, "The fetched symbol should match the requested symbol")
                    XCTAssertEqual(quoteResponse.askPrice, 151.0, "The fetched price should match the mocked price")
                    XCTAssertEqual(quoteResponse.bidPrice, 149.0, "The fetched price should match the mocked price")
                    expectation.fulfill()
                case .failure:
                    XCTFail("Expected successful fetch of quotes")
                case .pending:
                    XCTFail("Expected successful fetch of quotes")
                }
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 0.3)
    }
}
