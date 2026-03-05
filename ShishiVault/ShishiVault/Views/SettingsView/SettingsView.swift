import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isLogoutAlert = false
    
    var body: some View {
        Image("ShishiLogo_600")
            .resizable().scaledToFit().frame(maxWidth: 150).clipShape(.rect(cornerRadius: 15)).padding(.horizontal, 25)
        Divider()
        
        ScrollView {
            VStack {
                Button {
                    isLogoutAlert.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed).frame(width: 350, height: 35).foregroundColor(.white)
                        .overlay(
                            Text("Jetzt abmelden   \(Image(systemName: "door.left.hand.open"))")
                                .font(.subheadline).bold()
                                .foregroundColor(.white))
                }.padding(.horizontal, 20).padding(.vertical, 10)
                
                Text("Wenn Sie sich Abmelden, werden keine Daten gelöscht! Lediglich Ihre gespeicherten Anmeldedaten, sowie das hinterlegte Master-Passwort wird gelöscht. Sie können Ihre Daten durch eine erneute Anmeldung mit der Apple-ID und dem gültigen Master-Passwort wiederherstellen!")
                    .customTextFieldTextMid()
                
                    
            }
        }
        .navigationTitle("Einstellungen")
        .navigationBarTitleDisplayMode(.inline)
        
        
        
        .alert("Abmelden\n", isPresented: $isLogoutAlert, actions: {
            Button("Abmelden", role: .destructive) {
                shishiViewModel.logout()
            }
            Button("Abbrechen", role: .cancel) {
                isLogoutAlert = false
            }
        }, message: { Text("Sind Sie sicher, dass Sie sich abmelden möchten?\n") })
        
        
        
    }
}

#Preview {
    SettingsView()
        .environmentObject(ShishiViewModel())
}
