//
//  TicketsCollectionViewCell.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import UIKit

class TicketsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!

    private var tickets = [Ticket]()
    var didSelectTicket: ((Ticket) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "\(TicketTableViewCell.self)", bundle: nil),
                                forCellReuseIdentifier: "\(TicketTableViewCell.self)")
        self.tableView.backgroundView?.backgroundColor = .clear
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 114
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func configure(_ tickets: [Ticket]) {
        self.renderEmptyView(isShow: tickets.isEmpty)
        self.tickets = tickets
        self.tableView.reloadData()
    }

    private func renderEmptyView(isShow: Bool) {
        self.emptyView.alpha = isShow ? 1 : 0
        if isShow {
            self.contentView.bringSubviewToFront(self.emptyView)
        } else {
            self.contentView.bringSubviewToFront(self.tableView)
        }
    }
}

extension TicketsCollectionViewCell: UITableViewDelegate,
                                        UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.tickets.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TicketTableViewCell.self)",
                                                       for: indexPath) as? TicketTableViewCell else { return .init() }
        cell.configure(self.tickets[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        self.didSelectTicket?(self.tickets[indexPath.row])
    }
}
