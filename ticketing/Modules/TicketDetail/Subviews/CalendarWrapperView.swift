//
//  CalenderView.swift
//  ticketing
//
//  Created by Doan Duy Phuong on 17/10/2021.
//

import Foundation
import UIKit
import HorizonCalendar

final class CalendarWrapperView: UIView {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var valueDayLbl: UILabel!
    @IBOutlet weak var calendarWrapperView: UIView!
    @IBOutlet weak var selectButtonLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    var closeAction: (() -> Void)?
    var didSelectDay: ((Day?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.closeButton.setTitle("", for: .normal)
        self.selectButtonLabel.layer.cornerRadius = 5
        self.selectButtonLabel.layer.masksToBounds = true
        self.selectButtonLabel.isUserInteractionEnabled = true
        self.selectButtonLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectButtonLabelTapped)))

        self.dayView.layer.borderColor = UIColor(red: 0.758, green: 0.812, blue: 0.867, alpha: 1).cgColor
        self.dayView.layer.borderWidth = 1.5
        self.dayView.layer.cornerRadius = 4
        self.addCalendarView()
    }

    @objc private func selectButtonLabelTapped() {
        self.closeAction?()
        self.didSelectDay?(self.selectedDay)
    }

    @IBAction func closeButtonAction() {
        self.closeAction?()
    }

    private var selectedDay: Day?
    private let calendar = Calendar.current

    private func addCalendarView() {
        let calendarView = CalendarView(initialContent: self.makeContent())
        calendarView.backgroundColor = .white
        calendarView.layer.cornerRadius = 10.0
        calendarView.layer.applySketchShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1),
                                              alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.calendarWrapperView.addSubview(calendarView)
        calendarView.fitToSuperView()
        calendarView.daySelectionHandler = { day in
            self.selectedDay = day
            self.valueDayLbl.text = "\(day)"
            self.renderColorSelectLabelButton()
            calendarView.setContent(self.makeContent())
        }
    }

    func renderColorSelectLabelButton() {
        if let _ = selectedDay {
            self.selectButtonLabel.backgroundColor = ColorPalette.background
            self.selectButtonLabel.textColor = .white
        } else {
            self.selectButtonLabel.backgroundColor = ColorPalette.blue
            self.selectButtonLabel.textColor = ColorPalette.background
        }
    }
}

extension CalendarWrapperView {
    private func makeContent() -> CalendarViewContent {
        let startDate = Date()
        let endDate = calendar.date(from: DateComponents(year: 2024,
                                                         month: 12,
                                                         day: 31))!
        let selectedDay = self.selectedDay
        let monthLayout :MonthsLayout = .horizontal(options: HorizontalMonthsLayoutOptions(maximumFullyVisibleMonths: 1.0,
                                                                                           scrollingBehavior: .paginatedScrolling(.init(restingPosition: .atLeadingEdgeOfEachMonth,
                                                                                                                                        restingAffinity: .atPositionsClosestToTargetOffset))))
        
        return CalendarViewContent(calendar: calendar,
                                   visibleDateRange: startDate...endDate,
                                   monthsLayout: monthLayout)
            .withInterMonthSpacing(24)
            .withVerticalDayMargin(1)
            .withHorizontalDayMargin(8)
            .withDayItemModelProvider { [weak self] day in
                let textColor: UIColor
                if #available(iOS 13.0, *) {
                    textColor = .label
                } else {
                    textColor = .red
                }
                
                let dayAccessibilityText: String?
                if let date = self?.calendar.date(from: day.components) {
                    dayAccessibilityText = DateFormat.yyyymmdd.stringFromDate(date: date)
                } else {
                    dayAccessibilityText = nil
                }
                
                return CalendarItemModel<DayView>(invariantViewProperties: DayView.InvariantViewProperties.init(textColor: textColor,
                                                                                                                isSelectedStyle: day == selectedDay,
                                                                                                                selectedColor: ColorPalette.background),
                                                  viewModel: .init(dayText: "\(day.day)",
                                                                   dayAccessibilityText: dayAccessibilityText))
            }
    }
}

final class DayView: UIView {
    // MARK: Lifecycle
    init(invariantViewProperties: InvariantViewProperties) {
        dayLabel = UILabel()
        dayLabel.font = invariantViewProperties.font
        dayLabel.textAlignment = invariantViewProperties.textAlignment
        dayLabel.textColor = invariantViewProperties.textColor
        super.init(frame: .zero)
        addSubview(dayLabel)
        layer.borderColor = invariantViewProperties.selectedColor.cgColor
        layer.borderWidth = invariantViewProperties.isSelectedStyle ? 2 : 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    var dayText: String {
        get {
            dayLabel.text ?? ""
        }
        set {
            dayLabel.text = newValue
        }
    }

    var dayAccessibilityText: String?
    var isHighlighted = false {
        didSet {
            updateHighlightIndicator()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dayLabel.frame = bounds
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }

    // MARK: Private
    private let dayLabel: UILabel
    private func updateHighlightIndicator() {
        backgroundColor = isHighlighted ? UIColor.black.withAlphaComponent(0.1) : .clear
    }
}

// MARK: UIAccessibility
extension DayView {
    override var isAccessibilityElement: Bool {
        get { true }
        set { }
    }

    override var accessibilityLabel: String? {
        get { dayAccessibilityText ?? dayText }
        set { }
    }
}

// MARK: - CalendarItemViewRepresentable
extension DayView: CalendarItemViewRepresentable {
    struct InvariantViewProperties: Hashable {
        var font = UIFont.interRegular(size: 14)
        var textAlignment = NSTextAlignment.center
        var textColor: UIColor
        var isSelectedStyle: Bool
        var selectedColor = UIColor.red
    }

    struct ViewModel: Equatable {
        let dayText: String
        let dayAccessibilityText: String?
    }

    static func makeView(withInvariantViewProperties invariantViewProperties: InvariantViewProperties) -> DayView {
        DayView(invariantViewProperties: invariantViewProperties)
    }

    static func setViewModel(_ viewModel: ViewModel,
                             on view: DayView) {
        view.dayText = viewModel.dayText
        view.dayAccessibilityText = viewModel.dayAccessibilityText
    }
}


enum DateFormat: String {
    case yyyymmdd = "yyyy-MM-dd"
    case ddmmyyyy = "dd-MM-yyyy"
    case full = "hh:mm:ss - yyyy-MM-dd"
    case eemmddyy = "EEEE, MMM-dd-yyyy"
    case yyyy = "yyyy"
    case ddmmyy = "MMM d, yyyy"
    case dd = "dd"
    case MM = "MM"
    case MMdd = "MM/dd"
    case yyyyMMddHHmmssZ = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case yyyyMMddHHmmssSSSSSSS = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
    case hhmma = "hh:mm a"
    
    func stringFromDate(date: Date, formatter: UsingFormatter = .currentTimezone) -> String {
        let dateFormatter = formatter.formatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = self.rawValue
        return dateFormatter.string(from: date)
    }
}

enum UsingFormatter {
    case timezoneGMT0
    case currentTimezone
    
    func formatter() -> DateFormatter {
        let formatter = DateFormatter()
        switch self {
        case .timezoneGMT0:
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
        case .currentTimezone:
            formatter.timeZone = .current
        }
        return formatter
    }
}
