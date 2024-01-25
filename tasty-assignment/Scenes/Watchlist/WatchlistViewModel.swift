//
//  WatchlistViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import Foundation

struct WatchlistItem {
    let symbol: String
}

class WatchlistViewModel: ObservableObject {
    
    var title: String {
        "My Watchlist"
    }
}
