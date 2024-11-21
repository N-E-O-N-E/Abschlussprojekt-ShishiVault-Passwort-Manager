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
    
    @State private var isPasswordVisible: Bool = false
    @State private var isSavedAlert: Bool = false
    @State private var isEmptyFieldsAlert: Bool = false
    @State private var isEmptyOptFieldsAlert: Bool = false
    @State private var customFieldSheet: Bool = false
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
                        .customTextFieldText()
                    Spacer()
                }
                TextField(username, text: $username)
                    .customTextField()
                HStack {
                    Text("Benutzername")
                        .customTextFieldText()
                    Spacer()
                }
                TextField(email, text: $email)
                    .customTextField()
                HStack {
                    Text("E-Mail Adresse")
                        .customTextFieldText()
                    Spacer()
                }
                TextField(website, text: $website)
                    .customTextField()
                HStack {
                    Text("Website")
                        .customTextFieldText()
                    Spacer()
                }
                TextEditor(text: $notes)
                    .customTextFieldNotes()
                HStack {
                    Text("Notizen")
                        .customTextFieldText()
                    Spacer()
                }
                Divider().padding(.vertical, 10)
                HStack {
                    if isPasswordVisible {
                        TextField(password, text: $password)
                            .customPasswordField()
                    } else {
                        SecureField(password, text: $password)
                            .customSecureField()
                    }
                    Button(action: {
                        if !password.isEmpty {
                            isPasswordVisible.toggle()
                        }
                    }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(isPasswordVisible ? Color.ShishiColorBlue : Color.ShishiColorDarkGray)
                            .scaleEffect(1.2)
                        
                    }
                    .frame(width: 25)
                    .padding(.horizontal, 10)
                }
                HStack {
                    Text("Passworteinagabe")
                        .customTextFieldText()
                    Spacer()
                }
                
                Divider().padding(.vertical, 10)
                
                // CustomFields ----------------------------
                
                ForEach($customFields, id: \.id) { $customField in
                    TextField(customField.name, text: $customField.value)
                        .customTextField()
                    HStack {
                        Text(customField.name)
                            .customTextFieldText()
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
                            customFields.append(contentsOf: entrieViewModel.customFieldsForEntrie)
                            
                            if let oldEntry = entry {
                                let newEntrie = EntryData(
                                    id: oldEntry.id,
                                    title: title,
                                    username: username,
                                    email: email,
                                    password: password,
                                    notes: notes,
                                    website: website,
                                    customFields: customFields)
                                entrieViewModel.updateEntry(newEntrie: newEntrie)
                            }
                            
                            if let key = shishiViewModel.symetricKey {
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
                            Text("Eintrag aktualisieren")
                                .font(.title3).bold()
                                .foregroundColor(.white))
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
                Button {
                    customFieldSheet.toggle()
                } label: {
                    HStack {
                        Image(systemName: "rectangle.badge.plus")
                            .foregroundStyle(Color.ShishiColorBlue)
                    }
                }
            }
        }
        
        .sheet(isPresented: $customFieldSheet) {
            CustomFieldAddView(customFieldSheet: $customFieldSheet)
                .environmentObject(entrieViewModel)
        }
        
        .alert("Gespeichert", isPresented: $isSavedAlert, actions: {
            Button("OK", role: .cancel) {
                entrieEditView.toggle()
            }
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
        
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Eintrag bearbeiten")
        .foregroundStyle(Color.ShishiColorBlue)
        
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
        .onChange(of: entrieViewModel.customFieldsForEntrie) { _, newFields in
            customFields.append(contentsOf: newFields)
            
        }
        
    }
}

#Preview {
    EntrieEditView(entrieEditView: .constant(true))
        .environmentObject(EntriesViewModel(key: .init(data: [])))
        .environmentObject(ShishiViewModel())
}
