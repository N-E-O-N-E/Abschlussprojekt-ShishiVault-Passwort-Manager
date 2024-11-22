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
    
    @State private var isPasswordVisible: Bool = false
    @State private var isSavedAlert: Bool = false
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
    
    var body: some View {
        ScrollView {
            VStack {
                
                TextField("Titel", text: $title)
                    .customTextField()
                HStack {
                    Text("Bezeichnung")
                        .customTextFieldText()
                    Spacer()
                }
                
                TextField("Benutzername", text: $username)
                    .customTextField()
                HStack {
                    Text("Benutzername")
                        .customTextFieldText()
                    Spacer()
                }
                
                TextField("E-Mail", text: $email)
                    .customTextField()
                HStack {
                    Text("E-Mail Adresse")
                        .customTextFieldText()
                    Spacer()
                }
                
                TextField("Website", text: $website)
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
                
                Divider()
                    .padding(.vertical, 15)
                
                HStack {
                    
                    if isPasswordVisible {
                        TextField("Passwort", text: $password)
                            .customPasswordField()
                    } else {
                        SecureField("Passwort", text: $password)
                            .customSecureField()
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(isPasswordVisible ? Color.ShishiColorBlue : Color.ShishiColorDarkGray)
                            .scaleEffect(1.2)
                    }
                    .frame(width: 20)
                    .padding(.horizontal, 5)
                    
                    
                    
                    Button(action: {
                        password = CryptHelper.shared.randomPasswordMaker()
                        passwordConfirm = password
                        
                    }) {
                        Image(systemName: "lock.rotation")
                            .foregroundColor(Color.ShishiColorBlue)
                            .scaleEffect(1.4)
                    }
                    .frame(width: 20)
                    .padding(5)
                    
                }
                HStack {
                    Text("Passworteinagabe")
                        .customTextFieldText()
                    Spacer()
                }
                
                
                
                HStack {
                    if isPasswordVisible {
                        TextField("PasswortConfirm", text: $passwordConfirm)
                            .customTextField()
                    } else {
                        SecureField("PasswortConfirm", text: $passwordConfirm)
                            .customSecureField()
                    }
                }
                HStack {
                    Text("Passwort bestätigen")
                        .customTextFieldText()
                    Spacer()
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                
                
                
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
                            .customTextFieldText()
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
                            entrieViewModel.createEntry(
                                title: title,
                                username: username,
                                email: email,
                                password: password,
                                passwordConfirm: passwordConfirm,
                                notes: notes,
                                website: website,
                                customFields: entrieViewModel.customFieldsForEntrie)
                            
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
                            Text("Eintrag speichern")
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
        .environmentObject(EntriesViewModel(key: .init(data: [])))
        .environmentObject(ShishiViewModel())
}
