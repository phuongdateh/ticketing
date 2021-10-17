//
//  CalenderView.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 17/10/2021.
//

import Foundation
import UIKit
import HorizonCalendar

final class CalendarView: UIView {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var valueDayLbl: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var selectButtonLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    var closeAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.closeButton.setTitle("", for: .normal)
        self.selectButtonLabel.layer.cornerRadius = 4
        self.selectButtonLabel.isUserInteractionEnabled = true

        self.dayView.layer.borderColor = UIColor(red: 0.758, green: 0.812, blue: 0.867, alpha: 1).cgColor
        self.dayView.layer.borderWidth = 1.5
        self.dayView.layer.cornerRadius = 4
    }

    @IBAction func closeButtonAction() {
        self.closeAction?()
    }
}
