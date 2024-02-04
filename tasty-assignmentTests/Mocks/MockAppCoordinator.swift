//
//  MockAppCoordinator.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 04/02/2024.
//

import Foundation
import XCoordinator
@testable import tasty_assignment

final class MockAppCoordinator: NavigationCoordinator<AppRoute> {
    
    var lastCalledRoute: AppRoute?
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        lastCalledRoute = route
        return .none()
    }
}
