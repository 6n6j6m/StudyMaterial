import SwiftUI

// MARK: - 1. Model Data Sederhana
struct Profile: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

// MARK: - 2. Komponen Kartu Tunggal
struct SwipeCardView: View {
    var profile: Profile
    var onSwipe: (_ isLiked: Bool) -> Void // Closure untuk mengirim aksi ke Parent
    
    // Menyimpan posisi pergeseran jari
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(profile.color)
                .shadow(radius: 5)
            
            Text(profile.name)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
        }
        .frame(width: 300, height: 450)
        // A. Pindahkan kartu sesuai gesekan jari
        .offset(x: offset.width, y: offset.height * 0.4) // Y dikali 0.4 agar geseran vertikal tidak terlalu liar
        // B. Putar kartu sedikit berdasarkan jarak gesekan X
        .rotationEffect(.degrees(Double(offset.width / 20)))
        // C. Tambahkan Gesture
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    // Saat jari bergeser, update posisi
                    offset = gesture.translation
                }
                .onEnded { _ in
                    // Saat jari dilepas, beri animasi pegas
                    withAnimation(.spring()) {
                        let swipeThreshold: CGFloat = 150
                        
                        if offset.width > swipeThreshold {
                            // Geser Kanan (Like) -> Lempar kartu jauh ke kanan
                            offset = CGSize(width: 500, height: 0)
                            onSwipe(true)
                        } else if offset.width < -swipeThreshold {
                            // Geser Kiri (Nope) -> Lempar kartu jauh ke kiri
                            offset = CGSize(width: -500, height: 0)
                            onSwipe(false)
                        } else {
                            // Batal geser -> Kembalikan ke tengah
                            offset = .zero
                        }
                    }
                }
        )
    }
}

// MARK: - 3. Tampilan Utama (Tumpukan Kartu)
struct ContenView: View {
    @State private var profiles: [Profile] = [
        Profile(name: "Dian", color: .purple),
        Profile(name: "Budi", color: .blue),
        Profile(name: "Siti", color: .green),
        Profile(name: "Andi", color: .orange)
    ]
    
    var body: some View {
        VStack {
            Text("Pencarian Match")
                .font(.title)
                .bold()
                .padding()
            
            ZStack {
                if profiles.isEmpty {
                    Text("Tidak ada profil lagi.")
                        .foregroundColor(.gray)
                }
                
                // Gunakan reversed() agar index 0 (Dian) berada di tumpukan paling atas
                ForEach(profiles.reversed()) { profile in
                    SwipeCardView(profile: profile) { isLiked in
                        // Hapus profil dari array setelah di-swipe
                        handleSwipe(for: profile, isLiked: isLiked)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func handleSwipe(for profile: Profile, isLiked: Bool) {
        // Beri sedikit jeda waktu (0.3 detik) agar animasi "terlempar" terlihat sebelum kartu benar-benar dihapus dari memori
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            profiles.removeAll { $0.id == profile.id }
            print(isLiked ? "Kamu menyukai \(profile.name)" : "Kamu melewati \(profile.name)")
        }
    }
}

#Preview {
    ContenView()
}
