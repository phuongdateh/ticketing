//
//  TicketDetailViewModel.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 17/10/2021.
//

import Foundation

final class TicketDetailViewModel {
    let apiService: TicketApi
    let ticketId: Int
    var ticket: Ticket?

    init(ticketId: Int,
         apiService: TicketApi = TicketAPIService()) {
        self.ticketId = ticketId
        self.apiService = apiService
    }

    func shouldFetchData() -> Bool {
        return self.ticket == nil
    }

    func retrieveTicketDetail(success: @escaping (() -> Void),
                              failure: @escaping (() -> Void)) {
        self.apiService.retrieveTicketDetail(with: self.ticketId) { [weak self] result in
            switch result {
            case .success(let ticket):
                self?.ticket = ticket
                success()
            case .failure(let error):
                print(error.localizedDescription)
                failure()
            }
        }
    }
}
