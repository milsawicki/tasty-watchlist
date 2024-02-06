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
    var mockStorage: WatchlistStorageProtocol!
    var mockCoordinator: MockAppCoordinator!
    var mockService: MockWatchlistService!
    var mockWatchlist = Watchlist(name: "mock")
    var mockTextFieldPublisher: AnyPublisher<String, Never>!

    override func setUp() {
        super.setUp()
        mockStorage = WatchlistStorage(userDefaults: MockUserDefaults())
        mockCoordinator = MockAppCoordinator()
        mockService = MockWatchlistService()

        sut = SearchSymbolViewModel(
            service: mockService,
            watchlistStorage: mockStorage,
            router: mockCoordinator.weakRouter,
            watchlistId: mockWatchlist.id, addSymbolCompletion: {}
        )
    }

    override func tearDown() {
        sut = nil
        mockStorage = nil
        mockService = nil
        mockCoordinator = nil
        super.tearDown()
    }

    func test_shouldHideEmptyView_wheQueryEmpty() {
        // given
        let expectation = XCTestExpectation(description: "Debounce publisher test")
        let mockTextFieldPublisher = PassthroughSubject<String, Never>()
        var receivedValues = false

        mockService.expectedSearchSymbolResponse = .just(.success([]))
        sut.bind(queryPublisher: mockTextFieldPublisher.eraseToAnyPublisher())

        // when
        mockTextFieldPublisher.send("")

        // then
        let cancellable = sut.$emptyPublisher
            .sink { shouldShowEmpty in
                receivedValues = shouldShowEmpty
                expectation.fulfill()
            }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            XCTAssertTrue(receivedValues)
            cancellable.cancel()
        }
        wait(for: [expectation], timeout: 0.3)
    }

    func test_shouldShowLoadingIndicator_whenRequestResultPending() {
        // given
        let expectation = XCTestExpectation(description: "Debounce publisher test")
        let mockTextFieldPublisher = PassthroughSubject<String, Never>()
        var receivedValues = false
        mockService.expectedSearchSymbolResponse = .just(.pending)
        sut.bind(queryPublisher: mockTextFieldPublisher.eraseToAnyPublisher())

        // when
        mockTextFieldPublisher.send("some")

        // then
        let cancellable = sut.$loadingPublisher
            .sink { shouldShowLoading in
                receivedValues = shouldShowLoading
                expectation.fulfill()
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            XCTAssertTrue(receivedValues)
            cancellable.cancel()
        }
        wait(for: [expectation], timeout: 0.3)
    }

    func test_shouldShowEmptyView_whenEmptySymolsReturned() {
        // given
        let expectation = XCTestExpectation(description: "Debounce publisher test")
        let mockTextFieldPublisher = PassthroughSubject<String, Never>()
        var receivedValues = false
        mockService.expectedSearchSymbolResponse = .just(.success([]))
        sut.bind(queryPublisher: mockTextFieldPublisher.eraseToAnyPublisher())

        // when
        mockTextFieldPublisher.send("AAPLl")

        // then
        let cancellable = sut.$emptyPublisher
            .sink { shouldShowEmpty in
                receivedValues = shouldShowEmpty
                expectation.fulfill()
            }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            XCTAssertTrue(receivedValues)
            cancellable.cancel()
        }
        wait(for: [expectation], timeout: 0.4)
    }
    
    func test_addSymbolToWatchlist_withSymbolAlreadyAdded_shouldNotAddDuplicateItem() {
        mockStorage.addWatchlist(name: "Mock", with: ["AAPL"])
        
        sut.addSymbolToWatchlist("AAPL")
        XCTAssertEqual(mockStorage.loadWatchlists().count, 1)
    }
}
