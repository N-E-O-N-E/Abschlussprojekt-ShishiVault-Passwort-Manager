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
    @State private var uploadConfirm: Bool = false
    @State private var downloadConfirm: Bool = false
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
                Text("PIN-Sperre")
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
                    Text("PIN eingeben um die Sperre zu aktivieren!")
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
                
                Text("iCloud-Synchronisation")
                    .ueberschriftenText()
                
                HStack {
                    Button {
                        uploadConfirm.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.ShishiColorRed).frame(width: 170, height: 35).foregroundColor(.white)
                            .overlay(
                                Text("Upload  \(Image(systemName: "icloud.and.arrow.up.fill"))")
                                    .font(.subheadline).bold()
                                    .foregroundColor(.white))
                    }
                    
                    Button {
                        downloadConfirm.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.ShishiColorRed).frame(width: 170, height: 35).foregroundColor(.white)
                            .overlay(
                                Text("Download  \(Image(systemName: "icloud.and.arrow.down.fill"))")
                                    .font(.subheadline).bold()
                                    .foregroundColor(.white))
                    }
                }.padding(.horizontal, 22).padding(.vertical, 10)
                
                Text("Sichern der Daten in der iCloud.")
                    .customTextFieldTextMid()
                
                Divider()
                
                Text("Datenexport")
                    .ueberschriftenText()
                
                Button {
                    isExportAlert.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed).frame(width: 350, height: 35).foregroundColor(.white)
                        .overlay(
                            Text("Unverschlüsselt  \(Image(systemName: "square.and.arrow.up.trianglebadge.exclamationmark.fill"))")
                                .font(.subheadline).bold()
                                .foregroundColor(.white))
                }.padding(.horizontal, 20).padding(.vertical, 10)
                
                Text("Die Daten werden in Klartext als JSON-Datei im Dokumenteverzeichnis des Gerätes gespeichert.")
                    .customTextFieldTextMid()
                
                Divider()
                
                Text("Bereinigung")
                    .ueberschriftenText()
                
                Button {
                    isEraseAll.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed).frame(width: 350, height: 35).foregroundColor(.white)
                        .overlay(
                            Text("Daten löschen   \(Image(systemName: "exclamationmark.triangle"))")
                                .font(.subheadline).bold()
                                .foregroundColor(.white))
                }.padding(.horizontal, 20).padding(.vertical, 10)
                
                Text("Löscht die JSON-Daten auf diesem Gerät unwiederruflich. Clouddaten werden nicht gelöscht.")
                    .customTextFieldTextMid()
                
                Divider()
                
                Text("Abmelden")
                    .ueberschriftenText()
                
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
        }, message: { Text("Sind Sie sicher, dass Sie sich abmelden möchten?\n") })
        
        .alert("Alle Daten löschen\n", isPresented: $isEraseAll, actions: {
            Button("Alles löschen", role: .destructive) {
                jsonHelper.eraseJSONFile()
                dismiss()
            }
            Button("Abbrechen", role: .cancel) {
                isLogoutAlert = false
            }
        }, message: { Text("Alle Daten auf dem Gerät werden unwiederruflich gelöscht, jedoch nicht in der Cloud!\n\nSind sie sicher, dass Sie alle Daten löschen möchten?\n") })
        
        .alert("Export unverschlüsselter!\n", isPresented: $isExportAlert, actions: {
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
        
        .alert("PIN-Sperre nicht möglich\n", isPresented: $pinAlertPWEmpty, actions: {
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
        
        .alert("Upload bestätigen", isPresented: $uploadConfirm, actions: {
            Button("Einverstanden", role: .destructive) {
                Task {
                    jsonHelper.backupToiCloud { success in
                        if success {
                            self.alertTitle = "Upload erfolgreich!"
                            alertMessage = "Die Daten wurden erfolgreich in der iCloud gespeichert."
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
            }
            Button("Abbrechen", role: .cancel) {}
        }, message: { Text("Möchten Sie die Daten ihres Gerätes nun in die iCloud sichern? Bereits existierende Sicherungen in der Cloud werden mit den Daten auf ihrem Gerät überschrieben!") })
        
        .alert("Download bestätigen", isPresented: $downloadConfirm, actions: {
            Button("Einverstanden", role: .destructive) {
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
            }
            Button("Abbrechen", role: .cancel) {}
        }, message: { Text("Sie sind gerade dabei Daten aus der iCloud zu laden. Damit überschreiben Sie alle Daten auf Ihrem Gerät. Sind Sie sicher das Sie diese Aktion ausführen wollen?") })
        
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
