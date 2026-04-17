//
//  CobaGridView.swift
//  ProjectIseng
//
//  Created by Muhammad Najmi Rahmani  on 14/04/26.
//

import SwiftUI

struct GridExampleView: View {
    // 1. Data dummy untuk ditampilkan (misal 50 item)
    let items = 1...50
    
    // 2. Tentukan aturan kolom
    // Minimum lebar tiap item adalah 100 poin
    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 15)
    ]
    
    var body: some View {
        NavigationStack {
            // 3. Gunakan ScrollView karena LazyVGrid tidak bisa scroll sendiri
            ScrollView {
                // 4. Panggil LazyVGrid dan masukkan aturan kolomnya
                LazyVGrid(columns: columns, spacing: 15) {
                    
                    // 5. Looping data Anda
                    ForEach(items, id: \.self) { item in
                        // Click on the item to navigate
                        NavigationLink {
                            Text("Detail Item \(item)") // Action/Destination/Inside
                        } label: {
                            // Desain tampilan untuk setiap kotak (Cell)
                            VStack {
                                Image(systemName: "wallet.bifold")
                                    .font(.largeTitle)
                                    .foregroundColor(.blue)
                                Text("Wallet \(item)")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding() // Jarak grid dari tepi layar
            }
            .navigationTitle("Galeri Grid")
        }
    }
}
#Preview {
    GridExampleView()
}
