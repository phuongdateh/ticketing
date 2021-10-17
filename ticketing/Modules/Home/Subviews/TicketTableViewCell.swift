//
//  TicketTableViewCell.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var wrapperView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.wrapperView.layer.borderColor = ColorPalette.border.cgColor
        self.wrapperView.layer.cornerRadius = 12
        self.wrapperView.layer.borderWidth = 0.3
        self.wrapperView.clipsToBounds = true
    }

    func configure(_ ticket: Ticket) {
        self.nameLbl.text = ticket.title
        if ticket.price == 0 {
            self.priceLbl.text = "Free"
        } else {
            self.priceLbl.text = "$ \(ticket.price)"
        }
        self.descriptionLbl.text = ticket.description
    }
}
