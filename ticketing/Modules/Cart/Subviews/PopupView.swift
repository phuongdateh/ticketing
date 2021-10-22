//
//  PopupView.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 22/10/2021.
//

import Foundation
import UIKit

class PopupView: UIView {

    static var instance: PopupView? {
        guard let view = UINib(nibName: "\(PopupView.self)", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? PopupView else { return nil }
        return view
    }

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.removeButton.layer.cornerRadius = 4
        self.removeButton.titleLabel?.font = .interBold(size: 14)

        self.cancelButton.layer.cornerRadius = 4
        self.cancelButton.titleLabel?.font = .interBold(size: 14)
        self.wrapperView.layer.cornerRadius = 4
        self.wrapperView.layer.applySketchShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1),
                                                              alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
    }

    var removeAction: (() -> Void)?
    var cancelAction: (() -> Void)?

    @IBAction func removeButtonAction() {
        self.removeAction?()
    }

    @IBAction func cancelButtonAction() {
        self.cancelAction?()
    }
}
