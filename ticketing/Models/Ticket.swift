//
//  Ticket.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import Foundation

struct Ticket: Decodable {
    let id: Int
    let title: String?
    var price: Double = 0
    let description: String?
}
