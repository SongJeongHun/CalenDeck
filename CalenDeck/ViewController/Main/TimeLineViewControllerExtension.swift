import UIKit
import RxSwift
import NSObject_Rx
import RxCocoa
import FSCalendar
import Action
extension TimeLineViewController:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    func foldAction() -> CocoaAction{
        return CocoaAction{ _ in
            if self.calendar.scope == FSCalendarScope.month{
                self.calendar.setScope(.week, animated: true)
            }else{
                self.calendar.setScope(.month, animated: true)
            }
            return Observable.empty()
        }
    }
    func calendarSet(){
        calendar.layer.cornerRadius = 5.0
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.locale = Locale(identifier: "Ko_kR")
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("선택 -> \(viewModel.eventStorage.formatter.string(from: date))")
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("해제 -> \(viewModel.eventStorage.formatter.string(from: date))")
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}
