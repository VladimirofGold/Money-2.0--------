//
//  TransactionHistoryView.swift
//  Money 2.0
//
//  Created by Vladimir on 14.07.2025.
//

import SwiftUI

struct TransactionHistoryView: View {
    @ObservedObject var financeManager: FinanceManager
    
    var body: some View {
        ZStack {
            // Фон как на главном экране
            LinearGradient(
                gradient: Gradient(colors: [Color(white: 0.15), Color(white: 0.25)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Список транзакций
            List {
                ForEach(financeManager.sortedTransactions) { transaction in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            // Иконка в зависимости от типа
                            Image(systemName: transaction.type == .income ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                                .foregroundColor(transaction.type == .income ? .green : .red)
                            
                            // Сумма с цветом
                            Text("\(transaction.amount, specifier: "%.2f") ₽")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(transaction.type == .income ? .green : .red)
                            
                            Spacer()
                            
                            // Дата
                            Text(transaction.date, style: .date)
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.gray)
                        }
                        
                        // Заметка если есть
                        if !transaction.note.isEmpty {
                            Text(transaction.note)
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear) // Прозрачный фон для ячейки
                }
                .onDelete { indexSet in // Возможность удаления
                    let idsToDelete = indexSet.map { financeManager.sortedTransactions[$0].id }
                        financeManager.deleteTransactions(withIDs: idsToDelete)
                    }
            }
            .listStyle(PlainListStyle()) // Убираем стандартные стили списка
        }
        .navigationTitle("История операций")
    }
}
