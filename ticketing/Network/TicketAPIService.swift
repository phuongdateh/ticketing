//
//  TicketAPIService.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import Foundation

final class TicketAPIService: TicketApi {

    var urlSession: URLSession

    init(_ urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func retrieveCategories(completion: @escaping ResultCompletion<[Category]>) {
        self.request(target: TicketingTarget.categories,
                     completionHandler: completion)
    }

    func retrieveTicketByCategory(with id: Int,
                                  completion: @escaping ResultCompletion<[Ticket]>) {
        self.request(target: TicketingTarget.tickets(id),
                     completionHandler: completion)
    }

    func retrieveTicketDetail(with ticketId: Int,
                              completion: @escaping ResultCompletion<Ticket>) {
        self.request(target: TicketingTarget.ticketdetail(ticketId),
                     completionHandler: completion)
    }
}

extension TicketAPIService {
    func request<T: Decodable>(target: Target,
                               completionHandler: @escaping ResultCompletion<T>) {
        self.urlSession.dataTask(with: target.urlRequest, completionHandler: { data, response, _ in
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(response))
                } catch {
                    completionHandler(.failure(.failedRequest))
                }
            } else {
                completionHandler(.failure(.failedRequest))
            }
        }).resume()
    }

}
