//
//  HomeViewModel.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import Foundation

final class HomeViewModel {
    let apiService: TicketApi
    var categories = [Category]()

    init(apiService: TicketApi = TicketAPIService()) {
        self.apiService = apiService
    }

    func retrieveCategories() {
        self.apiService.retrieveCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories.append(contentsOf: categories)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
