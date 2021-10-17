//
//  CategoryCollectionViewCell.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 16/10/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var indicatorView: UIView!

    func configure(with selectedCategoryId: Int,
                   category: Category) {
        if selectedCategoryId == category.id {
            self.indicatorView.alpha = 1
            self.nameLbl.textColor = ColorPalette.black
        } else {
            self.indicatorView.alpha = 0
            self.nameLbl.textColor = ColorPalette.gray
        }
        self.nameLbl.text = category.name
    }
}
