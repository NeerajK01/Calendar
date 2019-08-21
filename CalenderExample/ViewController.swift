//
//  ViewController.swift
//  CalenderExample
//
//  Created by Neeraj kumar on 11/07/19.
//  Copyright © 2019 prolifics. All rights reserved.
//
import JTAppleCalendar
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var calendarView: JTACMonthView!
    let testCalendar = Calendar(identifier: .gregorian)
    
    var numberOfRows = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        
        calendarView.allowsMultipleSelection = true
        calendarView.allowsRangedSelection = true
        
        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        panGensture.minimumPressDuration = 0.5
        calendarView.addGestureRecognizer(panGensture)
        
    }
    
    @objc func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        let rangeSelectedDates = calendarView.selectedDates
        
        guard let cellState = calendarView.cellStatus(at: point) else { return }
        
        if !rangeSelectedDates.contains(cellState.date) {
            let dateRange = calendarView.generateDateRange(from: rangeSelectedDates.first ?? cellState.date, to: cellState.date)
            calendarView.selectDates(dateRange, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            let followingDay = testCalendar.date(byAdding: .day, value: 1, to: cellState.date)!
            calendarView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
        }
    }

    //MARK:- toggleButton - get current month when click
    @IBAction func toggleButtonClick(_ sender: Any) {
        if numberOfRows == 6 {
            self.numberOfRows = 1
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { completed in
                self.calendarView.reloadData(withAnchor: Date())
            }
        } else {
            self.numberOfRows = 6
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.calendarView.reloadData(withAnchor: Date())
            })
        }
    }
    
    //MARK:- ConfigureCell
    func configureCell(view: JTACDayCell?, cellState: CellState){
        guard let cell = view as? DateCell else { return }
        cell.dateCell.text = cellState.text
        
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelectedColor(cell: cell, cellState: cellState)
    }
    
    //MARK:- This func handle current month date textColor black and pevious and next gray
    func handleCellTextColor(cell: DateCell, cellState: CellState){
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateCell.textColor = UIColor.white
        } else {
            cell.dateCell.textColor = UIColor.lightGray
        }
        
        //for making hidden previous month date or next month date
        //        if cellState.dateBelongsTo == .thisMonth {
        //            cell.isHidden = false
        //        } else {
        //            cell.isHidden = true
        //        }
        
    }
    
    //MARK:- this function handle selected color of date
    func handleCellSelectedColor(cell: DateCell, cellState: CellState){
        //below code for implement for single selection
        
//                if cellState.isSelected{
//                    cell.dateSelectedView.layer.cornerRadius = 20
//                    cell.dateCell.textColor = UIColor.blue
//                    cell.dateSelectedView.isHidden = false
//                }else{
//                    cell.dateSelectedView.isHidden = true
//                }
        
        // below code implement code for multiple selection
        cell.dateSelectedView.isHidden = !cellState.isSelected

        switch cellState.selectedPosition() {

        case .left:
            cell.selectedDate.isHidden = false
            cell.dateCell.textColor = UIColor.blue
            cell.dateSelectedView.layer.cornerRadius = 20
            cell.dateSelectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]

        case .middle:
            cell.selectedDate.isHidden = false
            cell.dateCell.textColor = UIColor.blue
            cell.dateSelectedView.layer.cornerRadius = 0
            cell.dateSelectedView.layer.maskedCorners = []

        case .right:
            cell.selectedDate.isHidden = false
            cell.dateCell.textColor = UIColor.blue
            cell.dateSelectedView.layer.cornerRadius = 20
            cell.dateSelectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]

        case .full:
            cell.selectedDate.isHidden = false
            cell.dateCell.textColor = UIColor.blue
            cell.dateSelectedView.layer.cornerRadius = 20
            cell.dateSelectedView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]

        default: break
        }
        
    }
    
    
}

extension ViewController: JTACMonthViewDataSource{
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2019 01 01")!
        let endDate = formatter.date(from: "2021 12 31")!
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension ViewController: JTACMonthViewDelegate{
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    //MARK:- CalenderCell display
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        configureCell(view: cell, cellState: cellState)
    }
    
    //MARK:- when user select any date
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    //MARK:- when deselect date
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    //MARK:- shouldSelectDate
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return true
    }

    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMM"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
        
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }

}
