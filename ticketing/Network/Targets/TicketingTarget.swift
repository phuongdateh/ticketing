//
//  TicketingTarget.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import Foundation

protocol Target {
    var httpMethod: String { get }
    var path: String { get }
    var baseURL: String { get }
    var urlRequest: URLRequest { get }
}

enum TicketingTarget: Target {

    case categories
    case tickets(Int)
    case ticketdetail(Int)

}
extension TicketingTarget {
    var urlRequest: URLRequest {
        guard let url = URL.init(string: self.baseURL + self.path) else {
            fatalError("URL invalid")
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        return URLRequest.init(url: url)
    }

    var httpMethod: String {
        switch self {
        default:
            return "GET"
        }
    }

    var path: String {
        switch self {
        case .categories:
            return "categories"
        case .tickets(let categoryId):
            return "categories/\(categoryId)"
        case .ticketdetail(let ticketId):
            return "tickets/\(ticketId)"
        }
    }

    var baseURL: String {
        switch self {
        default: return "https://app-stg.vouch.sg/json-mock/ticketing/"
        }
    }
}
