//
//  TicketApi.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import Foundation

enum ErrorData: Error {
    case message(String)
    case failedRequest
    case invalidResponse
}

typealias ResultCompletion<T: Decodable> = (Result<T, ErrorData>) -> Void

protocol TicketApi {
    func retrieveCategories(completion: @escaping ResultCompletion<[Category]>)
    func retrieveTicketByCategory(with id: Int,
                                  completion: @escaping ResultCompletion<[Ticket]>)
    func retrieveTicketDetail(with ticketId: Int,
                              completion: @escaping ResultCompletion<[Ticket]>)
}
