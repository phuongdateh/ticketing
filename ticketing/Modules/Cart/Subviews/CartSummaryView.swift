//
//  CartSummaryView.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 22/10/2021.
//

import Foundation
import UIKit

class CartSummaryView: UIView {

    static var instance: UIView {
        guard let view = UINib(nibName: "\(CartSummaryView.self)", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? CartSummaryView else { return .init()}
        return view
    }

    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var confirmButton: UIButton!

    lazy var cartManager: CartManager = CartManager.shared

    var didTapConfirmButton: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.confirmButton.layer.cornerRadius = 4
        self.confirmButton.addTarget(self, action: #selector(confirmButtonTouchUpInside), for: .touchUpInside)
        self.cartManager.cartDidChange = {
            self.updatePrice()
        }
        self.updatePrice()
    }

    func updatePrice() {
        var total: Double = 0
        self.cartManager.items.forEach { item in
            total += item.ticket.price * Double(item.quantity)
        }
        self.subTotalLbl.text = "$\(total)"
    }

    @objc private func confirmButtonTouchUpInside() {
        self.didTapConfirmButton?()
    }
}
