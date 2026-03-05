import SwiftUI

struct PWLevelColorView: View {
    @Binding var password: String
    
    func levelValue(for password: String) -> CGFloat {
        var value: CGFloat = 0
        
        if password.count < 3 {
            value = 10
        } else if password.count >= 3 && password.count < 5 {
            value =  40
        } else if password.count >= 5 && password.count < 7 {
            value =  150
        } else if password.count >= 7 && password.count < 10 {
            value =  230
        } else if password.count >= 10 && password.count < 16 {
            value =  330
        }
        return value
    }
    
    func levelColor(for password: String) -> Color {
        var color = Color.gray
        if password.count <= 4 {
            color = .ShishiColorRed_
        } else if password.count > 4 && password.count <= 6 {
            color = .orange
        } else if password.count > 6 {
            color = .ShishiColorGreen
        }
        return color
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Capsule().frame(width: .infinity, height: 15).foregroundStyle(Color.gray.opacity(0.35))
                Capsule().frame(width: levelValue(for: password), height: 14).foregroundStyle(levelColor(for: password))
            }
        }
    }
}

#Preview {
    PWLevelColorView(password: .constant("25456"))
}
