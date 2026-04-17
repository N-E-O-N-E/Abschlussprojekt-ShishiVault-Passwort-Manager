import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isLogoutAlert = false
    @State private var isResetAlert = false
    @State private var isCloudWipeAlert = false
    
    var body: some View {
        VStack {
            Image("ShishiLogo_600")
                .resizable().scaledToFit().frame(maxWidth: 150).clipShape(.rect(cornerRadius: 15)).padding(.horizontal, 25)
            Divider()
            
            ScrollView {
                VStack {
                    Section {
                        HStack {
                            Image(systemName: "faceid")
                                .foregroundColor(.ShishiColorBlue)
                            Toggle("FaceID / TouchID nutzen", isOn: Binding(
                                get: { shishiViewModel.useBiometry },
                                set: { shishiViewModel.toggleBiometry(enabled: $0) }
                            ))
                            .tint(.ShishiColorBlue)
                        }
                        .padding(.horizontal, 25).padding(.top, 20)
                        
                        Text("Ermöglicht das schnelle Entsperren des Tresors ohne Passworteingabe.")
                            .customTextFieldTextMid()
                            .padding(.bottom, 20)
                    }
                    
                    
                    Divider()
                    
                    Section {
                        HStack {
                            Image(systemName: "icloud")
                                .foregroundColor(.ShishiColorBlue)
                            Toggle("iCloud Sync (in Arbeit)", isOn: Binding(
                                get: { shishiViewModel.isCloudSyncEnabled },
                                set: { shishiViewModel.toggleCloudSync(enabled: $0) }
                            ))
                            .tint(.ShishiColorBlue)
                            .disabled(true)
                        }
                        .padding(.horizontal, 25).padding(.top, 20)
                        
                        Text("Sichert Ihre verschlüsselten Einträge in Ihrer privaten iCloud. Deaktivieren löscht keine Daten in der Cloud.")
                            .customTextFieldTextMid()
                        
                        Button {
                            isCloudWipeAlert = true
                        } label: {
                            Text("Daten aus iCloud löschen")
                                .font(.caption)
                                .foregroundColor(.ShishiColorRed_)
                                .padding(.top, 5)
                        }
                        .padding(.horizontal, 25)
                        .padding(.bottom, 20)
                        .disabled(true)
                    }
                    
                    
                    Divider()
                    
                    Section {
                        Button {
                            isLogoutAlert.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.ShishiColorBlue).frame(height: 45).foregroundColor(.white)
                                .overlay(
                                    Text("Abmelden   \(Image(systemName: "door.left.hand.open"))")
                                        .font(.subheadline).bold()
                                        .foregroundColor(.white))
                        }.padding(.horizontal, 20).padding(.top, 10)
                        
                        Text("Beim Abmelden bleibt Ihr Tresor verschlüsselt auf dem Gerät gespeichert. Sie können sich jederzeit wieder mit Ihrem Master-Passwort anmelden.")
                            .customTextFieldTextMid()
                            .padding(.bottom, 30)
                    }
                    
                    Divider()
                    
                    Section {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.ShishiColorRed_)
                            Text("Gefahrenzone")
                                .font(.headline)
                                .foregroundColor(.ShishiColorRed_)
                            Spacer()
                        }.padding(.horizontal, 25).padding(.top, 20)
                        
                        Button {
                            isResetAlert.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.ShishiColorRed_).frame(height: 45).foregroundColor(.white)
                                .overlay(
                                    Text("Alles löschen & App zurücksetzen")
                                        .font(.subheadline).bold()
                                        .foregroundColor(.white))
                        }.padding(.horizontal, 20).padding(.top, 5)
                        
                        Text("Diese Aktion löscht unwiderruflich alle gespeicherten Passwörter, den Master-Key und setzt die App in den Auslieferungszustand zurück.")
                            .customTextFieldTextMid()
                            .foregroundColor(.ShishiColorRed_)
                    }
                }
            }
        }
        .navigationTitle("Einstellungen")
        .navigationBarTitleDisplayMode(.inline)
        
        .alert("Abmelden", isPresented: $isLogoutAlert) {
            Button("Abmelden", role: .destructive) { shishiViewModel.logout() }
            Button("Abbrechen", role: .cancel) {}
        } message: {
            Text("Möchten Sie sich wirklich abmelden?")
        }
        
        .alert("App vollständig zurücksetzen?", isPresented: $isResetAlert) {
            Button("ALLES LÖSCHEN", role: .destructive) {
                shishiViewModel.performFullReset()
                dismiss()
            }
            Button("Abbrechen", role: .cancel) {}
        } message: {
            Text("ACHTUNG: Alle Daten werden unwiderruflich gelöscht. Stellen Sie sicher, dass Sie ein Backup Ihrer Passwörter haben!")
        }
        .alert("iCloud-Daten löschen?", isPresented: $isCloudWipeAlert) {
            Button("JETZT LÖSCHEN", role: .destructive) {
                Task {
                    await shishiViewModel.wipeCloudData()
                }
            }
            Button("Abbrechen", role: .cancel) {}
        } message: {
            Text("Möchten Sie alle im CloudKit gespeicherten Daten unwiderruflich löschen? Lokale Daten bleiben erhalten.")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ShishiViewModel())
}
