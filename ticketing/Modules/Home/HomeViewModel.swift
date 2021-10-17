//
//  HomeViewModel.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import Foundation

final class HomeViewModel {
    let apiService: TicketApi
    var viewDatas = [HomeDisplayable]()
    var didFetchData: (() -> Void)?
    var didFailure: ((ErrorData) -> Void)?
    private let group = DispatchGroup.init()

    init(apiService: TicketApi = TicketAPIService()) {
        self.apiService = apiService
    }

    func willFetchData() {
        self.retrieveCategories()
    }

    private func retrieveCategories() {
        self.apiService.retrieveCategories { [weak self] result in
            switch result {
            case .success(let categories):
                categories.forEach({ self?.retrieveTicketsByCategoryId($0)})
            case .failure(let error):
                print(error.localizedDescription)
                self?.didFailure?(error)
            }
        }
    }

    private func retrieveTicketsByCategoryId(_ category: Category) {
        self.group.enter()
        self.apiService.retrieveTicketByCategory(with: category.id) { [weak self] result in
            switch result {
            case .success(let tickets):
                self?.viewDatas.append(HomeDisplayable(category: category,
                                                       tickets: tickets))
            case .failure(let error):
                print(error.localizedDescription)
                self?.didFailure?(error)
            }
            self?.group.leave()
        }
        self.group.notify(queue: .main) {[weak self] in
            self?.didFetchData?()
        }
    }
}

extension HomeViewModel {
    func numberOfSection() -> Int {
        return self.viewDatas.count
    }

    func viewDataForCellAt(indexPath: IndexPath) -> HomeDisplayable {
        return self.viewDatas[indexPath.section]
    }
}

struct HomeDisplayable {
    let category: Category
    let tickets: [Ticket]
}
