//
//  CartManager.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 18/10/2021.
//

import Foundation

enum Nationality: String {
    case singaporean = "Singaporean/PR"
    case foreigner = "Foreigner"
}

final class CartManager {
    static let shared = CartManager()

    var items = [Item]()
    var dateOfVisit: String = ""
    var natianality: Nationality = .singaporean {
        didSet {
            self.notify()
        }
    }

    func create(with dateOfVisit: String,
                item: Item) {
        self.dateOfVisit = dateOfVisit
    }

    func addToCart(with ticket: Ticket) {
        self.items.append(Item(ticket: ticket))
        self.notify()
    }

    func increase(of ticket: Ticket) {
        self.items.first(where: {$0.id == ticket.id })?.quantity += 1
        self.notify()
    }

    func decrease(of ticket: Ticket) {
        self.items.first(where: {$0.id == ticket.id })?.quantity -= 1
        self.notify()
    }

    func removeFromCart(with ticket: Ticket) {
        self.items = self.items.filter({ $0.id != ticket.id })
        self.notify()
    }

    func reset() {
        self.items.removeAll()
        self.notify()
    }

    func registerChange(block: (() -> Void)?) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "test"), object: self, queue: .main) { _ in
            block?()
        }
    }

    func notify() {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "test"), object: self)
    }

    func isExit(ticket: Ticket) -> Bool {
        return self.items.contains { item in
            return item.id == ticket.id
        }
    }
}

class Item {
    var id: Int
    var ticket: Ticket
    var quantity: Int = 1

    init(ticket: Ticket) {
        self.id = ticket.id
        self.ticket = ticket
    }
}
