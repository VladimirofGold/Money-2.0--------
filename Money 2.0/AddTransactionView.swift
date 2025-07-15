//
//  AddTransactionView.swift
//  Money 2.0
//
//  Created by Vladimir on 14.07.2025.
//

import SwiftUI

struct AddTransactionView: View {
    @ObservedObject var financeManager: FinanceManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var amount = ""
    @State private var selectedType = Transaction.TransactionType.income
    @State private var note = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Сумма").foregroundColor(.gray)) {
                    TextField("0.00", text: $amount)
                        .keyboardType(.decimalPad)
                        .font(.system(.body, design: .rounded))
                }
                
                Section(header: Text("Тип").foregroundColor(.gray)) {
                    Picker("Тип", selection: $selectedType) {
                        ForEach(Transaction.TransactionType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Заметка").foregroundColor(.gray)) {
                    TextField("Описание", text: $note)
                        .font(.system(.body, design: .rounded))
                }
            }
            .navigationTitle("Новая транзакция")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        saveTransaction()
                    }
                    .disabled(amount.isEmpty)
                }
            }
        }
        .accentColor(.white)
    }
    
    private func saveTransaction() {
        if let amountValue = Double(amount) {
            financeManager.addTransaction(
                amount: amountValue,
                type: selectedType,
                note: note.isEmpty ? "Без описания" : note
            )
            presentationMode.wrappedValue.dismiss()
        }
    }
}
