//
//  SearchSymbolViewModelTests.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 04/02/2024.
//

import Combine
@testable import tasty_assignment
import XCoordinator
import XCTest
class SearchSymbolViewModelTests: XCTestCase {
    var sut: SearchSymbolViewModel!
    var mockStorage: MockWatchlistStorage!
    var mockCoordinator: MockAppCoordinator!
    var mockService: MockWatchlistService!
    var mockWatchlist = Watchlist(name: "mock")
    var mockTextFieldPublisher: AnyPublisher<String, Never>!
    var addSymbolClosureSpy: (() -> Void) = {}
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockStorage = MockWatchlistStorage()
        mockCoordinator = MockAppCoordinator()
        mockService = MockWatchlistService()

        sut = SearchSymbolViewModel(
            service: mockService,
            watchlistStorage: mockStorage,
            router: mockCoordinator.weakRouter,
            watchlistId: mockWatchlist.id, addSymbolCompletion: addSymbolClosureSpy
        )
    }

    override func tearDown() {
        sut = nil
        mockStorage = nil
        mockService = nil
        mockCoordinator = nil
        super.tearDown()
    }

    func testAddSymbolToWatchlist_AddsSymbol() {
        mockStorage.loadWatchlistsReturnValue = [mockWatchlist]
        let addedSymbol = "AAPL"
        sut.addSymbolToWatchlist(addedSymbol)

        XCTAssertTrue(mockStorage.addSymbolCalled)
        XCTAssertEqual(mockStorage.addSymbolReceivedWatchlistId, mockWatchlist.id)
        XCTAssertEqual(mockCoordinator.lastCalledRoute, .dismiss)
        XCTAssertEqual(mockStorage.addSymbolReceivedSymbol, addedSymbol)
    }

    func test_doesnt_show_empty_view_when_no_query_entered() {
        // given
        let expectation = XCTestExpectation(description: "Debounce publisher test")
        let mockTextFieldPublisher = PassthroughSubject<String, Never>()
        mockService.expectedSearchSymbolResponse = .just(.success([]))
        sut.bind(queryPublisher: mockTextFieldPublisher.eraseToAnyPublisher())

        // when
        mockTextFieldPublisher.send("")

        // then
        sut.$emptyPublisher
            .sink { shouldShowEmpty in
                XCTAssertFalse(shouldShowEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 0.3)
    }
    
    func test_shows_loading_indicator_when_request_result_pending() {
        // given
        let expectation = XCTestExpectation(description: "Debounce publisher test")
        let mockTextFieldPublisher = PassthroughSubject<String, Never>()
        mockService.expectedSearchSymbolResponse = .just(.pending)
        sut.bind(queryPublisher: mockTextFieldPublisher.eraseToAnyPublisher())

        // when
        mockTextFieldPublisher.send("some")

        // then
        sut.$loadingPublisher
            .sink { shouldShowEmpty in
                XCTAssertTrue(shouldShowEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 0.3)
    }

    func test_should_display_empty_view_when_no_results_return() {
        // given
        let expectation = XCTestExpectation(description: "Debounce publisher test")
        let mockTextFieldPublisher = PassthroughSubject<String, Never>()
        mockService.expectedSearchSymbolResponse = .just(.success([]))
        sut.bind(queryPublisher: mockTextFieldPublisher.eraseToAnyPublisher())

        // when
        mockTextFieldPublisher.send("somesymbol")

        // then
        sut.$emptyPublisher
            .sink { shouldShowEmpty in
                XCTAssertTrue(shouldShowEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 0.1)
    }
}
