//
//  EntrieAddView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 15.11.24.
//

import SwiftUI

struct EntrieAddView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    
    @State private var isPasswordVisible: Bool = false
    @State private var isSavedAlert: Bool = false
    
    @State private var title: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    @State private var notes: String = ""
    @State private var website: String = ""
    @State private var customFields: [CustomField] = []
    
    var body: some View {
        
        VStack {
            
            TextField("Titel", text: $title)
                .frame(height: 25)
                .textFieldStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .border(Color.ShishiColorDarkGray, width: 1)
            
            HStack {
                Text("Bezeichnung")
                    .font(.caption)
                    .foregroundStyle(Color.ShishiColorDarkGray)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
        }.padding(.horizontal).padding(.vertical, 5)
        
        VStack {
            TextField("Benutzername", text: $username)
                .frame(height: 25)
                .textFieldStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .border(Color.ShishiColorDarkGray, width: 1)
            
            HStack {
                Text("Benutzername")
                    .font(.caption)
                    .foregroundStyle(Color.ShishiColorDarkGray)
                    .padding(.horizontal, 20).padding(.vertical, 5)
                
                Spacer()
            }
        } .padding(.horizontal)
        
        VStack {
            TextField("E-Mail", text: $email)
                .frame(height: 25)
                .textFieldStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .border(Color.ShishiColorDarkGray, width: 1)
            
            HStack {
                Text("E-Mail Adresse")
                    .font(.caption)
                    .foregroundStyle(Color.ShishiColorDarkGray)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
        } .padding(.horizontal).padding(.vertical, 5)
        
        VStack {
            HStack {
                if isPasswordVisible {
                    TextField("Passwort", text: $password)
                        .frame(height: 25)
                        .textFieldStyle(.plain)
                        .foregroundStyle(Color.ShishiColorDarkGray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .border(Color.ShishiColorDarkGray, width: 1)
                } else {
                    SecureField("Passwort", text: $password)
                        .frame(height: 25)
                        .textFieldStyle(.plain)
                        .foregroundStyle(Color.ShishiColorDarkGray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .border(Color.ShishiColorDarkGray, width: 1)
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
                    .font(.caption)
                    .foregroundStyle(Color.ShishiColorDarkGray)
                    .padding(.horizontal, 20)
                Spacer()
            }
        } .padding(.horizontal).padding(.vertical, 5)
        
        VStack {
            HStack {
                if isPasswordVisible {
                    TextField("PasswortConfirm", text: $passwordConfirm)
                        .frame(height: 25)
                        .textFieldStyle(.plain)
                        .foregroundStyle(Color.ShishiColorDarkGray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .border(Color.ShishiColorDarkGray, width: 1)
                } else {
                    SecureField("PasswortConfirm", text: $passwordConfirm)
                        .frame(height: 25)
                        .textFieldStyle(.plain)
                        .foregroundStyle(Color.ShishiColorDarkGray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .border(Color.ShishiColorDarkGray, width: 1)
                }
                Button(action: {
                    if !password.isEmpty {
                        //
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
                    .font(.caption)
                    .foregroundStyle(Color.ShishiColorDarkGray)
                    .padding(.horizontal, 20)
                Spacer()
            }
        } .padding(.horizontal).padding(.vertical, 5)
        
        
        
        Button {
            
            
            isSavedAlert.toggle()
            
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
        .alert("Gespeichert", isPresented: $isSavedAlert, actions: {
            Text("Der Eintrag wurde gespeichert.")
            Button("OK") {
                isSavedAlert.toggle()
            }
        })
        
    
        
        .navigationTitle("Eintrag hinzufügen")

    }
}

#Preview {
    EntrieAddView()
        .environmentObject(EntriesViewModel())
}
