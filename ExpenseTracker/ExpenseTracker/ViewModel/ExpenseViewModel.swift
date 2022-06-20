//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by ricardo silva on 21/05/2022.
//

import Foundation
import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var currentMonthStartDate: Date = Date()
    
    @Published var tabName: ExpenseType = .expense
    @Published var showFilterView: Bool = false
    
    @Published var addNewExpense: Bool = false
    @Published var amount: String = ""
    @Published var type: ExpenseType = .all
    @Published var date: Date = Date()
    @Published var remark: String = ""
    
    init() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        
        startDate = calendar.date(from: components)!
        currentMonthStartDate = calendar.date(from: components)!
    }
    
    
    @Published var expenses: [Expense] = sample_expenses
    
    
    func currentMonthDateString() -> String {
        return currentMonthStartDate.formatted(date: .abbreviated, time: .omitted) + " - " + Date().formatted(date: .abbreviated, time: .omitted)
    }
    
    func convertExpensesToCurrency(expenses: [Expense], type: ExpenseType = .all) -> String {
        var value: Double = 0
        value = expenses.reduce(0, { partialResult, expense in
            return partialResult + (type == .all ? (expense.type == .income ? expense.amount : -expense.amount) : (expense.type == type ? expense.amount : 0))
        })
        
        return convertNumberToPrice(value: value)
    }
    
    func convertDateToString() -> String{
            return startDate.formatted(date: .abbreviated, time: .omitted) + " - " + endDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    func convertNumberToPrice(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: value)) ?? "$0"
    }
    
    func clearData() {
        date = Date()
        type = .all
        remark = ""
        amount = ""
    }
    
    func saveData(env: EnvironmentValues) {
        print("Save")
        let amountInDouble = (amount as NSString).doubleValue
        let colors = ["Yellow", "Red", "Purple", "Green"]
        let expense = Expense(remark: remark, amount: amountInDouble, date: date, type: type, color: colors.randomElement() ?? "Yellow")
        withAnimation{expenses.append(expense)}
        expenses = expenses.sorted(by: { first, second in
            return second.date > first.date
        })
        env.dismiss()
    }
}
