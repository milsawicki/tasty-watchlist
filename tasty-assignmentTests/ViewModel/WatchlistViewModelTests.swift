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
    var mockStorage: MockWatchlistStorage!
    var mockCoordinator: MockAppCoordinator!
    var mockService: MockWatchlistService!
    var mockWatchlist: Watchlist!
    var sut: WatchlistViewModel!
    var cancellables: Set<AnyCancellable> = []
    override func setUp() {
        super.setUp()
        mockService = MockWatchlistService()
        mockCoordinator = MockAppCoordinator()
        mockStorage = MockWatchlistStorage()
        mockWatchlist = Watchlist(name: "mock")
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

    func test_shouldShowEmptyView_whenNoSymbolsInWatchlist_shouldReturnTrue() {
        mockStorage.fetchSymbolsReturnValue = []
        XCTAssertTrue(sut.shouldShowEmpty)
    }

    func test_shouldShowEmptyView_whenSymbolsNotEmpty_shouldReturnFalse() {
        mockStorage.fetchSymbolsReturnValue = ["AAPL"]
        XCTAssertFalse(sut.shouldShowEmpty)
    }

    func test_currentWatchlistName_returnsExpectedWatchlistName() {
        let expectedName = "Expected Name"
        mockWatchlist.name = expectedName
        mockStorage.fetchWatchlistReturnedValue = mockWatchlist
        XCTAssertEqual(sut.currentWatchlistName, expectedName)
    }

    func test_numberOfRows_withNoSymbolsOnWatchlist_shouldReturn0() {
        mockStorage.fetchSymbolsReturnValue = []
        XCTAssertEqual(sut.numberOfRows, 0)
    }

    func test_numberOfRows_shouldReturnNumberOfItemsOnWatchlist() {
        mockStorage.fetchSymbolsReturnValue = ["AAPL", "MSFT"]
        XCTAssertEqual(sut.numberOfRows, mockStorage.fetchSymbolsReturnValue!.count, "numberOfRows should equal the number of symbols")
    }

    func test_showAddSymbol_shouldTriggerAddSymbolToWatchlistRoute() {
        mockStorage.fetchWatchlistReturnedValue = mockWatchlist
        sut.showAddSymbol()
        XCTAssertEqual(mockCoordinator.lastCalledRoute, .addSymbolToWatchlist(watchlistId: mockWatchlist.id, completion: {}))
    }

    func test_manageWatchlists_shouldTriggerManageWatchlistsRoute() {
        sut.manageWatchlists()
        XCTAssertEqual(mockCoordinator.lastCalledRoute, .manageWatchlists)
    }

    func test_SymbolForRowAt() {
        let symbols = ["AAPL", "GOOGL", "MSFT"]
        mockStorage.fetchSymbolsReturnValue = symbols

        let rowIndex = 1
        let expectedSymbol = symbols[rowIndex]
        XCTAssertEqual(sut.symbol(for: rowIndex), expectedSymbol, "The symbol for a given row should match the symbol in the array")
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
