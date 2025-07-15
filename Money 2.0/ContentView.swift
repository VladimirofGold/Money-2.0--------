//
//  ContentView.swift
//  Money 2.0
//
//  Created by Vladimir on 14.07.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var financeManager = FinanceManager()
    @State private var showingAddTransaction = false
    @State private var showingHistory = false // Состояние для отображения истории
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(white: 0.03), Color(white: 0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Text("Ваш баланс")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                        
                        Text("\(financeManager.balance, specifier: "%.2f") ₽")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 50)
                    
                    VStack(spacing: 15) {
                        Button(action: { showingAddTransaction = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Добавить транзакцию")
                            }
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(15)
                        }
                        
                        Button(action: { showingHistory = true }) {
                            HStack {
                                Image(systemName: "list.bullet")
                                Text("История операций")
                            }
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Финансы")
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView(financeManager: financeManager)
            }
            .sheet(isPresented: $showingHistory) {
                NavigationView {
                    TransactionHistoryView(financeManager: financeManager)
                }
                .accentColor(.white)
            }
        }
        .accentColor(.white)
    }
}
