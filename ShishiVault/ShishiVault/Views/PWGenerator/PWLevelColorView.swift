import SwiftUI

struct PWLevelColorView: View {
    @Binding var password: String
    
    func levelProgress(for password: String) -> Double {
        if password.count < 3 { return 0.1 }
        else if password.count < 5 { return 0.2 }
        else if password.count < 7 { return 0.4 }
        else if password.count < 10 { return 0.6 }
        else if password.count < 16 { return 0.8 }
        else { return 1.0 }
    }
    
    func levelColor(for password: String) -> Color {
        if password.count <= 4 { return .ShishiColorRed_ }
        else if password.count <= 6 { return .orange }
        else { return .ShishiColorGreen }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: 15)
                    .foregroundStyle(Color.gray.opacity(0.35))
                
                Capsule()
                    .frame(width: geometry.size.width * levelProgress(for: password), height: 14)
                    .foregroundStyle(levelColor(for: password))
            }
        }
        .frame(height: 15)
        .padding(.horizontal)
    }
}

#Preview {
    PWLevelColorView(password: .constant("4562456"))
}
