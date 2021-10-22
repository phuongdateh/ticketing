//
//  CartItemTableViewCell.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 22/10/2021.
//

import UIKit

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var dateOfVisitLbl: UILabel!
    
    let cartManager = CartManager.shared
    var item: Item!
    var removeItemAction: ((Item) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.increaseButton.layer.cornerRadius = 4
        self.increaseButton.backgroundColor = ColorPalette.background
        self.increaseButton.addTarget(self, action: #selector(increaseButtonTouchUpInside), for: .touchUpInside)

        self.decreaseButton.layer.cornerRadius = 4
        self.decreaseButton.backgroundColor = ColorPalette.background
        self.decreaseButton.addTarget(self, action: #selector(decreaseButtonTouchUpInside), for: .touchUpInside)
    }

    @objc private func increaseButtonTouchUpInside() {
        cartManager.increase(of: self.item.ticket)
    }

    @objc private func decreaseButtonTouchUpInside() {
        guard self.item.quantity > 1 else {
            self.removeItemAction?(self.item)
            return
        }
        cartManager.decrease(of: self.item.ticket)
    }

    func configureData(item: Item) {
        self.item = item
        self.itemNameLbl.text = item.ticket.title
        if item.ticket.price == 0 {
            self.priceLbl.text = "Free"
        } else {
            self.priceLbl.text = "$\(item.ticket.price * Double(item.quantity))"
        }
        self.itemCountLbl.text = "\(item.quantity)"
        self.dateOfVisitLbl.text = "Date of visit: \(CartManager.shared.dateOfVisit)"
    }
}
