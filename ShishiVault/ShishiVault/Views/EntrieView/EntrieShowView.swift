//
//  EntrieAddView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 15.11.24.
//

import SwiftUI

struct EntrieAddView: View {
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    
    @State private var isPasswordVisible: Bool = false
    @State private var isSavedAlert: Bool = false
    @State private var isEmptyFieldsAlert: Bool = false
    @State private var isEmptyOptFieldsAlert: Bool = false
    @State private var isDiffPassAlert: Bool = false
    @State private var customFieldSheet: Bool = false
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
                Divider().padding(.vertical, 10)
                HStack {
                    if isPasswordVisible {
                        TextField("Passwort", text: $password)
                            .customPasswordField()
                    } else {
                        SecureField("Passwort", text: $password)
                            .customSecureField()
                    }
                    Button(action: {
                        if !password.isEmpty {
                            isPasswordVisible.toggle()
                        }
                    }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(isPasswordVisible ? Color.ShishiColorDarkGray : Color.ShishiColorRed)
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
                
                HStack {
                    if isPasswordVisible {
                        TextField("PasswortConfirm", text: $passwordConfirm)
                            .customTextField()
                    } else {
                        SecureField("PasswortConfirm", text: $passwordConfirm)
                            .customSecureField()
                    }
                    Button(action: {
                        if !password.isEmpty {
                            // ggf. Passwort Random erstellen lassen
                        }
                    }) {
                        Image(systemName: "lock.rotation")
                            .foregroundColor(Color.ShishiColorDarkGray)
                            .scaleEffect(1.5)
                    }
                    .frame(width: 25)
                    .padding(.horizontal, 10)
                }
                HStack {
                    Text("Passwort bestätigen")
                        .customTextFieldText()
                    Spacer()
                }
                Divider().padding(.vertical, 10)
                
                // CustomFields ----------------------------
                ForEach($entrieViewModel.customFieldsForEntrie) { $customField in
                    TextField(customField.name, text: $customField.value )
                        .customTextField()
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
                            entrieViewModel.createCustomFieldToSave()
                            
                            entrieViewModel.createEntry(
                                title: title,
                                username: username,
                                email: email,
                                password: password,
                                passwordConfirm: passwordConfirm,
                                notes: notes,
                                website: website,
                                customFields: entrieViewModel.customFieldsForEntrieToSave)
                            
                            entrieViewModel.deleteCustomField()
                            entrieViewModel.deleteCustomFieldToSave()
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
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    customFieldSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        
        .sheet(isPresented: $customFieldSheet) {
            CustomFieldAddView(customFieldSheet: $customFieldSheet)
                .environmentObject(entrieViewModel)
        }
        
        .alert("Gespeichert", isPresented: $isSavedAlert, actions: {
            Button("OK", role: .cancel) {
                showAddEntrieView.toggle()
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
        
        .alert("Fehler", isPresented: $isDiffPassAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text("Die Passwörter stimmen nicht überein")
        })
        
        .navigationTitle("Eintrag hinzufügen")
        
        
        .onAppear {
            entrieViewModel.deleteCustomField()
            entrieViewModel.deleteCustomFieldToSave()
            print("CustomField Daten wurden zurückgesetzt")
        }
    }
}

#Preview {
    EntrieAddView(showAddEntrieView: .constant(true))
        .environmentObject(EntriesViewModel())
}
