//
//  EntrieAddView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 15.11.24.
//

import SwiftUI

struct EntrieAddView: View {
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    //    @State private var isPasswordVisible: Bool = false
    @State private var isSavedAlert: Bool = false
    @State private var pwnedAlert: Bool = false
    @State private var connectionAlert: Bool = false
    @State private var isEmptyFieldsAlert: Bool = false
    @State private var isEmptyOptFieldsAlert: Bool = false
    @State private var isDiffPassAlert: Bool = false
    @State private var customFieldSheet: Bool = false
    @State private var pwGeneratorSheet: Bool = false
    @Binding var showAddEntrieView: Bool
    
    @State private var title: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    @State private var notes: String = ""
    @State private var website: String = ""
    @State private var passwordPwnedState: Int = 0
    
    var body: some View {
        ScrollView {
            VStack {
                
                TextField("Titel", text: $title)
                    .customTextField()
                HStack {
                    Text("Bezeichnung")
                        .customTextFieldTextLow()
                    Spacer()
                }
                
                TextField("Benutzername", text: $username)
                    .customTextField()
                HStack {
                    Text("Benutzername")
                        .customTextFieldTextLow()
                    Spacer()
                }
                
                TextField("E-Mail", text: $email)
                    .customTextField()
                HStack {
                    Text("E-Mail Adresse")
                        .customTextFieldTextLow()
                    Spacer()
                }
                
                TextField("Website", text: $website)
                    .customTextField()
                HStack {
                    Text("Website")
                        .customTextFieldTextLow()
                    Spacer()
                }
                
                TextEditor(text: $notes)
                    .customTextFieldNotes()
                HStack {
                    Text("Notizen")
                        .customTextFieldTextLow()
                    Spacer()
                }
                
                
                
                
                
                Divider()
                    .padding(.vertical, 1)
                
                PWLevelColorView(password: $password)
                    .padding(.vertical, 15)
                
                
                
                
                
                HStack {
                    TextField("Passwort", text: $password)
                        .customPasswordField()
                        .onTapGesture {
                            passwordPwnedState = 0
                        }
                    
                    Button(action: {
                        password = CryptHelper.shared.randomPasswordMaker()
                        passwordConfirm = password
                        passwordPwnedState = 0
                        
                        Task {
                            do {
                                passwordPwnedState = try await APIhaveibeenpwned().checkPasswordPwned(password: password)
                                if passwordPwnedState == 1 {
                                    pwnedAlert = true
                                }
                            } catch {
                                connectionAlert.toggle()
                            }
                        }
                    }) {
                        switch passwordPwnedState {
                            case 1:
                                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                    .foregroundColor(Color.ShishiColorRed_)
                                    .scaleEffect(1.4)
                                    .padding(.horizontal, 10)
                            case 2:
                                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                    .foregroundColor(Color.ShishiColorGreen)
                                    .scaleEffect(1.4)
                                    .padding(.horizontal, 10)
                            case 0:
                                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                    .foregroundColor(Color.ShishiColorGray)
                                    .scaleEffect(1.4)
                                    .padding(.horizontal, 10)
                            default:
                                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                    .foregroundColor(Color.ShishiColorGray)
                                    .scaleEffect(1.4)
                                    .padding(.horizontal, 10)
                        }
                    }
                    .padding(5)
                    .padding(.horizontal, 10)
                    
                    
                    
                    
                    
                    
                    Button(action: {
                        password = CryptHelper.shared.randomPasswordMaker()
                        passwordConfirm = password
                        passwordPwnedState = 0
                        
                        Task {
                            do {
                                passwordPwnedState = try await APIhaveibeenpwned().checkPasswordPwned(password: password)
                                if passwordPwnedState == 1 {
                                    pwnedAlert = true
                                }
                            } catch {
                                connectionAlert.toggle()
                            }
                        }
                        
                    }) {
                        Image(systemName: "lock.rotation")
                            .foregroundColor(Color.ShishiColorBlue)
                            .scaleEffect(1.4)
                    }
                    .padding(5)
                    .padding(.horizontal, 10)
                    
                    
                    
                    
                    
                }
                HStack {
                    Text("Passworteinagabe")
                        .customTextFieldTextLow()
                    Spacer()
                }
                HStack {
                    TextField("PasswortConfirm", text: $passwordConfirm)
                        .customTextField()
                }
                HStack {
                    Text("Passwort bestätigen")
                        .customTextFieldTextLow()
                    Spacer()
                }
                
                
                
                
                
                Divider()
                    .padding(.vertical, 5)
                
                
                
                
                // CustomFields ----------------------------
                ForEach($entrieViewModel.customFieldsForEntrie) { $customField in
                    HStack {
                        TextField(customField.name, text: $customField.value)
                            .customTextField()
                        Button {
                            entrieViewModel.deleteCustomFieldForID(forID: $customField.id)
                        } label: {
                            Image(systemName: "x.circle")
                                .foregroundStyle(Color.ShishiColorRed)
                                .scaleEffect(1.2)
                        }
                    }
                    HStack {
                        Text(customField.name)
                            .customTextFieldTextLow()
                        Spacer()
                    }
                }
                
                
                
                Spacer()
                
                
                
                Button {
                    switch entrieViewModel.entrieSaveButtomnCheck(
                        title: title, username: username,
                        email: email, password: password, passwordConfirm: passwordConfirm) {
                            
                        case "mindestLeer":
                            isEmptyFieldsAlert.toggle()
                            
                        case "wahlLeer":
                            isEmptyOptFieldsAlert.toggle()
                            
                        case "passConfirm":
                            isDiffPassAlert.toggle()
                            
                        case "ok":
                            
                            Task {
                                do {
                                    passwordPwnedState = try await APIhaveibeenpwned().checkPasswordPwned(password: password)
                                } catch {
                                    connectionAlert.toggle()
                                }
                            }
                            if passwordPwnedState == 2 {
                                entrieViewModel.createEntry(
                                    title: title,
                                    username: username,
                                    email: email,
                                    password: password,
                                    passwordConfirm: passwordConfirm,
                                    notes: notes,
                                    website: website,
                                    customFields: entrieViewModel.customFieldsForEntrie)
                                
                                if let key = KeychainHelper.shared.loadCombinedSymmetricKeyFromKeychain(keychainKey: shishiViewModel.symmetricKeychainString) {
                                    Task {
                                        JSONHelper.shared.saveEntriesToJSON(
                                            key: key,
                                            entries: entrieViewModel.entries)
                                    }
                                } else {
                                    print("JSON save failed")
                                }
                                
                                entrieViewModel.deleteCustomField()
                                isSavedAlert.toggle()
                                
                            } else if passwordPwnedState == 1 {
                                pwnedAlert = true
                            }
                            
                        default:
                            break
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed)
                        .frame(height: 50)
                        .padding()
                        .foregroundColor(.white)
                        .overlay(
                            Text("Eintrag speichern")
                                .font(.title3).bold()
                                .foregroundColor(.white))
                }
            }
        }
        .padding(.horizontal).padding(.vertical, 15)
        
        
        
        
        
        
        
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
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        customFieldSheet.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.badge.plus")
                                .foregroundStyle(Color.ShishiColorBlue)
                        }
                    }
                    Button(action: {
                        pwGeneratorSheet.toggle()
                        
                    }) {
                        Image(systemName: "lock.square")
                            .foregroundColor(Color.ShishiColorBlue)
                            .scaleEffect(1.1)
                    }
                }
            }
        }
        
        
        
        
        
        
        
        .sheet(isPresented: $customFieldSheet) {
            CustomFieldAddView(customFieldSheet: $customFieldSheet)
                .environmentObject(entrieViewModel)
        }
        .sheet(isPresented: $pwGeneratorSheet) {
            PWGeneratorView(customFieldSheet: $customFieldSheet)
                .environmentObject(entrieViewModel)
        }
        
        
        
        
        
        
        .alert("Gespeichert", isPresented: $isSavedAlert, actions: {
            Button("OK", role: .cancel) {
                showAddEntrieView.toggle()
            }
        }, message: {
            Text("Die Daten wurden erfolgreich gespeichert.")
        })
        
        .alert("Fehler", isPresented: $isEmptyFieldsAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text("Bitte füllen Sie die Pflichtfelder Titel und Passwort aus.")
        })
        
        .alert("Fehler", isPresented: $isEmptyOptFieldsAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text("Bitte füllen Sie die Felder Username oder E-Mail aus.")
        })
        
        .alert("Fehler", isPresented: $isDiffPassAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text("Die Passwörter stimmen nicht überein")
        })
        
        .alert("Passwort unsicher!\n", isPresented: $pwnedAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text("Das gewählte Passwort ist kompromittiert! Bitte wählen Sie ein anderes Passwort.")
        })
        
        .alert("Kein Internet!\n", isPresented: $connectionAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text("Kein Internet zur Prüfung des Passwortes vorhanden! Eintrag wird ggf. mit unsicherem Passwort aktualisiert!")
        })
        
        
        
        
        
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Eintrag hinzufügen")
        .foregroundStyle(Color.ShishiColorBlue)
        
        
        
        .onAppear {
            entrieViewModel.deleteCustomField()
            print("CustomField data array cleared")
        }
        
        
        
    }
}

#Preview {
    EntrieAddView(showAddEntrieView: .constant(true))
        .environmentObject(EntriesViewModel(symmetricKeyString: .init([])))
        .environmentObject(ShishiViewModel())
}
