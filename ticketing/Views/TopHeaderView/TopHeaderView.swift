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
        self.itemCountView.layer.cornerRadius = self.itemCountView.frame.height / 2
        self.itemCountView.backgroundColor = .red
        self.itemCountLbl.textColor = .white
        self.titleLbl.numberOfLines = 0
    }

    func updateTitle(title: String) {
        let titleAttributedText = NSMutableAttributedString()
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.alignment = .left
        titleAttributedText.append(NSAttributedString(string: title + "\n", attributes: [.font: UIFont.interBold(size: 14)!, .foregroundColor: UIColor.white, .paragraphStyle: style]))
        titleAttributedText.append(NSAttributedString(string: "National Museum Wakanda", attributes: [.font: UIFont.interRegular(size: 12)!, .foregroundColor: UIColor.white]))
        self.titleLbl.attributedText = titleAttributedText
    }

    func updateCartView() {
        let count = CartManager.shared.items.count
        guard count > 0 else {
            self.itemCountLbl.text = ""
            return
        }
        self.itemCountLbl.text = "\(count)"
    }

    @IBAction func cartButtonTouchUpInside(_ sender: Any) {
        self.didTapCartButton?()
    }
}
