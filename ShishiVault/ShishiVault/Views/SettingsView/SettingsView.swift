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
    
    @State private var isLogoutAlert: Bool = false
    @State private var isExportAlert: Bool = false
    @State private var isEraseAll: Bool = false
    
    var body: some View {
            HStack {
                Text("Einstellungen")
                    .ueberschriftLargeBold()
                Spacer()
                Image("ShishiLogo_600")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 85)
                    .clipShape(.rect(cornerRadius: 15))
                    .padding(.horizontal, 25)
            }.padding(.vertical, 15)
            
        VStack(alignment: .leading) {

                Text("Unverschlüsselte Sicherung")
                    .ueberschriftenTextBold()
                
                Button {
                    isExportAlert.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed)
                        .frame(width: 350, height: 35)
                        .foregroundColor(.white)
                        .overlay(
                            Text("Export in Dokumente  \(Image(systemName: "square.and.arrow.up.trianglebadge.exclamationmark.fill"))")
                                .font(.title3).bold()
                                .foregroundColor(.white))
                }.padding(20)
                
                Text("Alle Daten werden '_unverschlüsselt_' als JSON-Datei in Ihrem Dokumentenverzeichnis gespeichert.")
                    .customTextFieldTextMid()
            
            
            Divider()
            

                Text("Speichern in der iCloud")
                    .ueberschriftenTextBold()
                
                HStack {
                    Button {
                        //
                    } label: {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.ShishiColorGray)
                            .frame(width: 170, height: 35)
                            .foregroundColor(.white)
                            .overlay(
                                Text("Upload  \(Image(systemName: "square.and.arrow.up.fill"))")
                                    .font(.title3).bold()
                                    .foregroundColor(.white))
                    }.padding(.vertical, 10)
                        .disabled(true)
                    
                    Button {
                        //
                    } label: {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.ShishiColorGray)
                            .frame(width: 170, height: 35)
                            .foregroundColor(.white)
                            .overlay(
                                Text("Download   \(Image(systemName: "square.and.arrow.down.fill"))")
                                    .font(.title3).bold()
                                    .foregroundColor(.white))
                    }.padding(.vertical, 10)
                        .disabled(true)
                    
                }.padding(.horizontal, 20)
                
                Text("Laden oder Speichern Sie die verschlüsselten Daten als JSON-Datei aus Ihrer iCloud. Vergewissern Sie sich, dass Sie die iCloud Datenspeicherung auf ihrem Gerät aktivieren haben.")
                    .customTextFieldTextMid()
                
            Divider()
            

                Text("Alle Daten löschen")
                    .ueberschriftenTextBold()
                
                Button {
                    isEraseAll.toggle()
                    
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed)
                        .frame(width: 350, height: 35)
                        .foregroundColor(.white)
                        .overlay(
                            Text("Alles löschen   \(Image(systemName: "exclamationmark.triangle"))")
                                .font(.title3).bold()
                                .foregroundColor(.white))
                }.padding(20)
                
                Text("Alle Daten werden auf dem Gerät unwiederruflich gelöscht - jedoch nicht in der Cloud!")
                    .customTextFieldTextMid()

            
            Divider()
            

                Text("Abmelden")
                    .ueberschriftenTextBold()
                
                Button {
                    isLogoutAlert.toggle()
                    
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed)
                        .frame(width: 350, height: 35)
                        .foregroundColor(.white)
                        .overlay(
                            Text("Abmelden   \(Image(systemName: "door.left.hand.open"))")
                                .font(.title3).bold()
                                .foregroundColor(.white))
                }.padding(20)
                
                Text("Wenn sie sich Abmelden, werden keine Daten gelöscht. Sie können Ihre Daten durch eine erneute Anmeldung wieder einsehen.")
                    .customTextFieldTextMid()
                

            Divider()
            
            
            Spacer()
            
                .navigationBarBackButtonHidden(true)
            // .navigationTitle("Einstellungen")
            
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
                }
                Button("Abbrechen", role: .cancel) {
                    isLogoutAlert = false
                }
            }, message: {
                Text("Sind sie sicher, dass sie sich abmelden möchten?\n")
                
            })
        
            .alert("Alle Daten Löschen\n", isPresented: $isEraseAll, actions: {
                Button("Alles Löschen", role: .destructive) {
                     JSONHelper.shared.eraseJSONFile()
                }
                Button("Abbrechen", role: .cancel) {
                    isLogoutAlert = false
                }
            }, message: {
                Text("Alle Daten werden auf dem Gerät unwiederruflich gelöscht - jedoch nicht in der Cloud!\nSind sie sicher, dass sie alle Daten löschen möchten?\n")
                
            })
        
            .alert("! Unverschlüsselter Export !\n", isPresented: $isExportAlert, actions: {
                Button("Exportieren", role: .destructive) {
                    if let key = KeychainHelper.shared.loadSymmetricKeyFromKeychain(keychainKey: shishiViewModel.symmetricKeyString) {
                        Task {
                            JSONHelper.shared.saveEntriesToJSONDecrypted(key: key, entries: entrieViewModel.entries)
                        }
                    } else {
                        print("JSON save failed")
                    }
                }
                Button("Abbrechen", role: .cancel) {}
            }, message: {
                Text("Möchten Sie alle Einträge unverschlüsselt exportieren?\n")
            })
        
    }
}

#Preview {
    
    SettingsView()
        .environmentObject(ShishiViewModel())
}
