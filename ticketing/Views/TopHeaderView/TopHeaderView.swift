//
//  TopHeaderView.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 15/10/2021.
//

import Foundation
import UIKit

class TopHeaderView: UIView {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var itemCountView: UIView!

    @IBOutlet weak var cartButton: UIButton!
    var didTapCartButton: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.cartButton.setTitle("", for: .normal)
        self.backgroundColor = ColorPalette.background
        CartManager.shared.cartDidChange = {
            let count = CartManager.shared.items.count
            self.itemCountLbl.text = "\(count)"
        }
        self.itemCountView.layer.cornerRadius = self.itemCountView.frame.height / 2
        self.itemCountView.backgroundColor = .red
    }

    @IBAction func cartButtonTouchUpInside(_ sender: Any) {
        self.didTapCartButton?()
    }
}
