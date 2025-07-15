//
//  TransactionModel.swift
//  Money 2.0
//
//  Created by Vladimir on 14.07.2025.
//

import Foundation

// Модель для хранения информации о транзакции
struct Transaction: Identifiable, Codable {
    let id: UUID
    let amount: Double
    let type: TransactionType
    let date: Date
    let note: String
    
    enum TransactionType: String, Codable, CaseIterable {
        case income = "Доход"
        case expense = "Расход"
    }
}

// Класс для управления финансовыми данными
class FinanceManager: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    var balance: Double {
        transactions.reduce(0) { result, transaction in
            transaction.type == .income ? result + transaction.amount : result - transaction.amount
        }
    }
    
    var sortedTransactions: [Transaction] {
            transactions.sorted { $0.date > $1.date } // Сортируем по дате (новые сверху)
        }
    

    init() {
        loadTransactions()
    }
    
    func addTransaction(amount: Double, type: Transaction.TransactionType, note: String) {
        let newTransaction = Transaction(
            id: UUID(),
            amount: amount,
            type: type,
            date: Date(),
            note: note
        )
        transactions.append(newTransaction)
        saveTransactions()
    }
    
    func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: "transactions")
        }
    }
    func deleteTransactions(withIDs ids: [UUID]) {
        transactions.removeAll { ids.contains($0.id) }
        saveTransactions()
    }
    
    private func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: "transactions"),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
    }
}
