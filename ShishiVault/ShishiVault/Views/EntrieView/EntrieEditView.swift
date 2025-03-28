//
//  EntrieAddView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 15.11.24.
//

import SwiftUI

struct EntrieEditView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    
    @State private var savedAlert: Bool = false
    @State private var connectionAlert: Bool = false
    @State private var isEmptyFieldsAlert: Bool = false
    @State private var isEmptyOptFieldsAlert: Bool = false
    @State private var isDeleteAlert: Bool = false
    @State private var customFieldSheet: Bool = false
    @State private var pwGeneratorSheet: Bool = false
    @State private var pwnedAlert: Bool = false
    @State private var passwordPwnedState: Int = 0
    @Binding var entrieEditView: Bool
    
    var entry: EntryData?
    
    @State private var title: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var notes: String = ""
    @State private var website: String = ""
    @State private var customFields: [CustomField] = []
    
    var body: some View {
        ScrollView {
            VStack {
                TextField(title, text: $title)
                    .customTextField()
                HStack {
                    Text("Bezeichnung")
                        .customTextFieldTextLow()
                    Spacer()
                }
                TextField(username, text: $username)
                    .customTextField()
                HStack {
                    Text("Benutzername")
                        .customTextFieldTextLow()
                    Spacer()
                }
                TextField(email, text: $email)
                    .customTextField()
                HStack {
                    Text("E-Mail Adresse")
                        .customTextFieldTextLow()
                    Spacer()
                }
                TextField(website, text: $website)
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
                
                PWLevelColorView(password: $password)
                    .padding(.vertical, 20)
                
                HStack {
                    TextField(password, text: $password)
                        .customPasswordField()
                        .onTapGesture {
                            passwordPwnedState = 0
                        }
                    
                    Button(action: {
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
                                    .foregroundColor(Color.ShishiColorRed_).scaleEffect(1.4).padding(.horizontal, 15)
                            case 2:
                                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                    .foregroundColor(Color.ShishiColorGreen).scaleEffect(1.4).padding(.horizontal, 15)
                            case 0:
                                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                    .foregroundColor(Color.ShishiColorGray).scaleEffect(1.4).padding(.horizontal, 15)
                            default:
                                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                    .foregroundColor(Color.ShishiColorGray).scaleEffect(1.4).padding(.horizontal, 15)
                        }
                    }
                    .frame(width: 20).padding(.horizontal, 10)
                    
                    Button(action: {
                        Task {
                            password = CryptHelper.shared.randomPasswordMaker()
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
                            .foregroundColor(Color.ShishiColorBlue).scaleEffect(1.4)
                    }
                    .frame(width: 20).padding(.horizontal, 10)
                }
                HStack {
                    Text("Passwort vergeben")
                        .customTextFieldTextLow()
                    Spacer()
                }
                
                Divider().padding(.vertical, 10)
                
                // CustomFields ------------------------------------------------------------------------------------------
                
                ForEach($customFields, id: \.id) { $customField in
                    HStack {
                        TextField(customField.name, text: $customField.value)
                            .customTextField()
                        Button {
                            customFields.removeAll(where: { $0.id == customField.id })
                        } label: {
                            Image(systemName: "x.circle")
                                .foregroundStyle(Color.ShishiColorRed).scaleEffect(1.2)
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
                    switch entrieViewModel.entrieUpdateButtomnCheck(
                        title: title, username: username, email: email, password: password) {
                            
                        case "mindestLeer":
                            isEmptyFieldsAlert.toggle()
                            
                        case "wahlLeer":
                            isEmptyOptFieldsAlert.toggle()
                            
                        case "ok":
                            Task {
                                do {
                                    passwordPwnedState = try await APIhaveibeenpwned().checkPasswordPwned(password: password)
                                    if passwordPwnedState == 2 {
                                        savedAlert.toggle()
                                    } else if passwordPwnedState == 1 {
                                        pwnedAlert = true
                                    }
                                } catch {
                                    connectionAlert.toggle()
                                }
                            }
                        default:
                            break
                    }
                    
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed).frame(height: 50).padding().foregroundColor(.white)
                        .overlay(
                            Text("Aktualisieren")
                                .font(.title3).bold().foregroundColor(.white))
                }
            }
        }
        .padding(.horizontal).padding(.vertical, 5)
        
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
                        customFieldSheet = true
                        
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
         
        .alert("Hinweis", isPresented: $savedAlert, actions: {
            Button("Aktualisieren", role: .destructive) {
                if let oldEntry = entry {
                    let newEntrie = EntryData(
                        id: oldEntry.id, title: title, username: username, email: email, password: password,
                        notes: notes, website: website, customFields: customFields)
                    entrieViewModel.updateEntry(newEntrie: newEntrie)
                }
                Task {
                    if let key = KeychainHelper.shared.loadCombinedSymmetricKeyFromKeychain(keychainKey: shishiViewModel.symmetricKeychainString) {
                        JSONHelper.shared.saveEntriesToJSON(key: key, entries: entrieViewModel.entries)
                    } else {
                        print("JSON save failed")
                    }
                }
                entrieViewModel.deleteCustomField()
                dismiss()
            }
            
            Button("Abbrechen", role: .cancel) {}
        }, message: { Text("Die Aktualisierung der Daten kann nicht rückgängig gemacht werden!. Möchten Sie die Daten wirklich aktualisieren?") })
        
        
        .alert("Fehler", isPresented: $isEmptyFieldsAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: { Text("Bitte füllen Sie die Pflichtfelder Titel und Passwort aus.") })
        
        .alert("Fehler", isPresented: $isEmptyOptFieldsAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: { Text("Bitte füllen Sie das Feld Username oder E-Mail aus.") })
        
        .alert("Passwort unsicher!\n", isPresented: $pwnedAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: { Text("Das gewählte Passwort ist kompromittiert! Bitte wählen Sie ein anderes Passwort.") })
        
        .alert("Kein Internet!\n", isPresented: $connectionAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: { Text("Kein Internet zur Überprüfung des Passworts vorhanden!\n\nDer Eintrag wird möglicherweise mit einem unsicheren Passwort aktualisiert!") })
        
        .onAppear {
            print("CustomField Daten wurden zurückgesetzt")
            entrieViewModel.deleteCustomField()
            
            if let entriesLoaded = entry {
                self.title = entriesLoaded.title
                self.username = entriesLoaded.username ?? ""
                self.email = entriesLoaded.email
                self.password = entriesLoaded.password
                self.notes = entriesLoaded.notes ?? ""
                self.website = entriesLoaded.website ?? ""
                self.customFields = entriesLoaded.customFields
            }
        }
        
        .onChange(of: customFieldSheet) { _, isPresented in
            if !isPresented {
                customFields.append(contentsOf: entrieViewModel.customFieldsForEntrie)
                entrieViewModel.deleteCustomField()
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Bearbeiten")
        .foregroundStyle(Color.ShishiColorBlue)
    }
}

#Preview {
    EntrieEditView(entrieEditView: .constant(true))
        .environmentObject(EntriesViewModel(symmetricKeyString: .init([])))
        .environmentObject(ShishiViewModel())
}
