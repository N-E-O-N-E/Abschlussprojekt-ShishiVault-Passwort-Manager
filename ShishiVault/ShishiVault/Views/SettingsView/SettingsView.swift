//
//  ContentView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//

import SwiftUI

struct SettingsView: View {
    // Exemplarisches Einbinden des ViewModels zur Anmeldung mit Apple ID
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    @Environment(\.dismiss) private var dismiss
    private let jsonHelper = JSONHelper.shared
    private let kchainHelper = KeychainHelper.shared
    
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    @State private var isLogoutAlert: Bool = false
    @State private var isExportAlert: Bool = false
    @State private var pinAlertPWEmpty: Bool = false
    @State private var pinAlertDelete: Bool = false
    @State private var isEraseAll: Bool = false
    @State private var pinLockDisable: Bool = true
    @State private var pinLock: Bool = false
    @State private var iCloudAlert: Bool = false
    @State private var pin: String = ""
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Einstellungen")
                    .ueberschriftLargeBold()
                Spacer()
                Image("ShishiLogo_600")
                    .resizable().scaledToFit().frame(maxWidth: 80).clipShape(.rect(cornerRadius: 15)).padding(.horizontal, 25)
            }.padding(.vertical, 5)
            
            VStack(alignment: .leading) {
                Text("App sperren")
                    .ueberschriftenText()
                
                HStack {
                    TextField("\(pin)", text: $pin)
                        .customTextField()
                        .frame(width: 230)
                        .onChange(of: pin) { _, newValue in
                            if !newValue.isEmpty {
                                pinLockDisable = false
                            }
                        }
                    
                    Toggle("", isOn: $pinLock)
                        .disabled(pinLockDisable)
                        .onChange(of: pinLock) { oldValue, newValue in
                            if !pin.isEmpty {
                                if oldValue != newValue {
                                    if !newValue {
                                        kchainHelper.delPin()
                                        pinAlertDelete.toggle()
                                        
                                    } else if newValue {
                                        kchainHelper.savePin(pin: pin)
                                    }
                                }
                            } else {
                                pinAlertPWEmpty = true
                                pinLock = false
                            }
                        }
                        .padding(.horizontal, 20)
                }.padding(.horizontal, 20)
                
                HStack {
                    Text("App-Sperre für hinterlegten PIN aktivieren!")
                        .customTextFieldTextLow()
                    Spacer()
                }
                
                Button {
                    if !pin.isEmpty {
                        kchainHelper.savePin(pin: self.pin)
                        shishiViewModel.lockApp()
                        dismiss()
                        
                    } else {
                        pinAlertPWEmpty = true
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorBlue).frame(width: 350, height: 35).foregroundColor(.white)
                        .overlay(
                            Text("Sperren  \(Image(systemName: "exclamationmark.lock"))")
                                .font(.subheadline).bold()
                                .foregroundColor(.white))
                }.padding(.horizontal, 20).padding(.vertical, 10)
                
                Text("Sperrt die APP mit ihrer vergebenen PIN.")
                    .customTextFieldTextMid()
                
                Divider()
                
                Text("iCloud synchronisation")
                    .ueberschriftenText()
                
                HStack {
                    Button {
                        Task {
                            jsonHelper.backupToiCloud { success in
                                if success {
                                    self.alertTitle = "Upload erfolgreich!"
                                    alertMessage = "Das Backup wurde erfolgreich in der iCloud gespeichert."
                                    iCloudAlert.toggle()
                                    print("JSON file upload successfully.")
                                    
                                } else {
                                    alertTitle = "Upload fehlgeschlagen!"
                                    alertMessage = "Es konnten keine Daten in der iCloud gesichert werden. Bitte prüfen Sie die Internetverbindung oder die iCloud Einstellungen auf ihrem Gerät!"
                                    iCloudAlert.toggle()
                                    print("Failed to upload JSON file.")
                                }
                            }
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.ShishiColorRed).frame(width: 170, height: 35).foregroundColor(.white)
                            .overlay(
                                Text("Upload  \(Image(systemName: "icloud.and.arrow.up.fill"))")
                                    .font(.subheadline).bold()
                                    .foregroundColor(.white))
                    }
                    
                    Button {
                        Task {
                            jsonHelper.restoreFromiCloud { success in
                                if success {
                                    alertTitle = "Download erfolgreich!"
                                    alertMessage = "Die letzte Datensicherung wurde erfolgreich aus der iCloud geladen."
                                    iCloudAlert.toggle()
                                    print("JSON file downloaded successfully.")
                                } else {
                                    alertTitle = "Download fehlgeschlagen!"
                                    alertMessage = "Es konnte keine Datensicherung gefunden bzw. geladen werden. Bitte prüfen Sie die Internetverbindung oder die iCloud Einstellungen auf ihrem Gerät!"
                                    iCloudAlert.toggle()
                                    print("Failed to download JSON file.")
                                }
                            }
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.ShishiColorRed).frame(width: 170, height: 35).foregroundColor(.white)
                            .overlay(
                                Text("Download  \(Image(systemName: "icloud.and.arrow.down.fill"))")
                                    .font(.subheadline).bold()
                                    .foregroundColor(.white))
                    }
                }.padding(.horizontal, 22).padding(.vertical, 10)
                
                Text("Speichern sie ihre Daten regelmäßig sicher in der iCloud.")
                    .customTextFieldTextMid()
                
                Divider()
                
                Text("Datensicherung unverschlüsselt")
                    .ueberschriftenText()
                
                Button {
                    isExportAlert.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed).frame(width: 350, height: 35).foregroundColor(.white)
                        .overlay(
                            Text("Export in Dokumente  \(Image(systemName: "square.and.arrow.up.trianglebadge.exclamationmark.fill"))")
                                .font(.subheadline).bold()
                                .foregroundColor(.white))
                }.padding(.horizontal, 20).padding(.vertical, 10)
                
                Text("Alle Daten werden in Klartext als JSON-Datei im Dokumenteverzeichnis des Gerätes gespeichert.")
                    .customTextFieldTextMid()
                
                Divider()
                
                Text("Datenbereinigung")
                    .ueberschriftenText()
                
                Button {
                    isEraseAll.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed).frame(width: 350, height: 35).foregroundColor(.white)
                        .overlay(
                            Text("Unwiederruflich löschen   \(Image(systemName: "exclamationmark.triangle"))")
                                .font(.subheadline).bold()
                                .foregroundColor(.white))
                }.padding(.horizontal, 20).padding(.vertical, 10)
                
                Text("Löscht die JSON-Datendatei auf diesem Gerät unwiederruflich. Sie bleiben weiter angemeldet und können neue Daten speichern.")
                    .customTextFieldTextMid()
                
                Divider()
                
                Text("Benutzer abmelden")
                    .ueberschriftenText()
                
                Button {
                    isLogoutAlert.toggle()
                    
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed).frame(width: 350, height: 35).foregroundColor(.white)
                        .overlay(
                            Text("Abmelden   \(Image(systemName: "door.left.hand.open"))")
                                .font(.subheadline).bold()
                                .foregroundColor(.white))
                }.padding(.horizontal, 20).padding(.vertical, 10)
                
                Text("Wenn sie sich Abmelden, werden keine Daten gelöscht! Es werden ihre gespeicherten Benutzerdaten, sowie das hinterlegte Master-Passwort gelöscht. Sie können Ihre Daten durch eine erneute Anmeldung mit der AppleID und dem gültigen Master-Passwort wiederherstellen!")
                    .customTextFieldTextMid()
                
                Divider()
                
                Spacer()
                
                    .navigationBarBackButtonHidden(true)
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color.ShishiColorBlue)
                    Text("Zurück")
                        .foregroundColor(Color.ShishiColorBlue)
                }
            }
        }
        
        .alert("Abmelden\n", isPresented: $isLogoutAlert, actions: {
            Button("Abmelden", role: .destructive) {
                shishiViewModel.logout()
                dismiss()
            }
            Button("Abbrechen", role: .cancel) {
                isLogoutAlert = false
            }
        }, message: { Text("Sind sie sicher, dass sie sich abmelden möchten?\n") })
        
        .alert("Alle Daten Löschen\n", isPresented: $isEraseAll, actions: {
            Button("Alles Löschen", role: .destructive) {
                jsonHelper.eraseJSONFile()
                dismiss()
            }
            Button("Abbrechen", role: .cancel) {
                isLogoutAlert = false
            }
        }, message: { Text("Alle Daten werden auf dem Gerät unwiederruflich gelöscht - jedoch nicht in der Cloud!\nSind sie sicher, dass sie alle Daten löschen möchten?\n") })
        
        .alert("! Unverschlüsselter Export !\n", isPresented: $isExportAlert, actions: {
            Button("Exportieren", role: .destructive) {
                if let key = kchainHelper.loadCombinedSymmetricKeyFromKeychain(keychainKey: shishiViewModel.symmetricKeychainString) {
                    Task {
                        jsonHelper.saveEntriesToJSONDecrypted(key: key, entries: entrieViewModel.entries)
                    }
                } else {
                    print("JSON save failed")
                }
            }
            Button("Abbrechen", role: .cancel) {}
        }, message: { Text("Möchten Sie alle Einträge unverschlüsselt exportieren?\n") })
        
        .alert("Lock nicht möglich\n", isPresented: $pinAlertPWEmpty, actions: {
            Button("OK") {}
        }, message: { Text("Sie haben keinen PIN vergeben!\n") })
        
        .alert("PIN-Lock\n", isPresented: $pinAlertDelete, actions: {
            Button("OK") {
                dismiss()
            }
        }, message: { Text("Sie haben den PIN-Lock deaktiviert!\n") })
        
        .alert(alertTitle, isPresented: $iCloudAlert, actions: {
            Button("Schließen") {
                dismiss()
            }
        }, message: { Text("\(alertMessage)") })
        
        .onAppear {
            if let readedPin = kchainHelper.readPin() {
                self.pin = readedPin
                self.pinLock = true
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ShishiViewModel())
}
