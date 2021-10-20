//
//  ItemView.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 18/10/2021.
//

import Foundation
import UIKit

final class ItemView: UIView {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    @IBOutlet weak var singaporeanButton: UIButton!
    @IBOutlet weak var foreignerButton: UIButton!
    
    @IBOutlet weak var quantityStackView: UIStackView!
    @IBOutlet weak var increseButton: UIButton!
    @IBOutlet weak var descreaseButton: UIButton!
    @IBOutlet weak var quantityLbl: UILabel!

    @IBOutlet weak var addToCartButton: UIButton!

    let cartManager = CartManager.shared
    var ticket: Ticket!
    var closeAction: (() -> Void)?
    var addToCartButtonAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addToCartButton.isUserInteractionEnabled = true
        self.closeButton.setTitle("", for: .normal)
        self.singaporeanButton.layer.borderColor = UIColor(red: 0.412, green: 0.412, blue: 0.412, alpha: 0.3).cgColor
        self.singaporeanButton.layer.borderWidth = 0.5
        self.singaporeanButton.layer.cornerRadius = self.singaporeanButton.frame.height / 2

        self.foreignerButton.layer.borderColor = UIColor(red: 0.412, green: 0.412, blue: 0.412, alpha: 0.3).cgColor
        self.foreignerButton.layer.borderWidth = 0.5
        self.foreignerButton.layer.cornerRadius = self.singaporeanButton.frame.height / 2

        self.addToCartButton.layer.cornerRadius = 5

        self.quantityStackView.layer.borderWidth = 1
        self.quantityStackView.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        self.quantityStackView.layer.cornerRadius = 5

        self.quantityStackView.clipsToBounds = true

        self.increseButton.layer.borderWidth = 1
        self.increseButton.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor

        self.descreaseButton.layer.borderWidth = 1
        self.descreaseButton.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor

        cartManager.cartDidChange = { [weak self] in
            self?.renderItemView()
        }
    }

    @IBAction func closeButtonAction() {
        self.closeAction?()
    }

    @IBAction func addToCartAction() {
        self.cartManager.addToCart(with: self.ticket)
        self.addToCartButton.alpha = 0
        self.addToCartButton.isUserInteractionEnabled = false
        self.addToCartButtonAction?()
    }

    @IBAction func increaseAction() {
        self.cartManager.increase(of: self.ticket)
    }

    @IBAction func descreaseAction() {
        self.cartManager.decrease(of: self.ticket)
    }

    @IBAction func singaporeanAction() {
        cartManager.natianality = .singaporean
    }

    @IBAction func foreignerAction() {
        cartManager.natianality = .foreigner
    }

    func renderItemView() {
        switch cartManager.natianality {
        case .singaporean:
            self.singaporeanButton.backgroundColor = UIColor(red: 0.679, green: 0.679, blue: 0.679, alpha: 0.3)
            self.foreignerButton.backgroundColor = .white
        case .foreigner:
            self.singaporeanButton.backgroundColor = .white
            self.foreignerButton.backgroundColor = UIColor(red: 0.679, green: 0.679, blue: 0.679, alpha: 0.3)
        }
        self.quantityLbl.text = "\(self.cartManager.items.filter({$0.id == self.ticket.id}).first?.quantity ?? 0)"
        self.titleLbl.text = self.ticket.title
        if self.ticket.price == 0 {
            self.priceLbl.text = "Free"
        } else {
            self.priceLbl.text = "\(self.ticket.price)"
        }
    }
}
