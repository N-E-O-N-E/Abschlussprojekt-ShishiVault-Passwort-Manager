//
//  ContentView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 11.11.24.
//

import SwiftUI

struct ComponentsExampleView: View {
    // Exemplarisches Einbinden des ViewModels zur Anmeldung mit Apple ID
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    // Testdaten
    @State private var text: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var entries: [EntryData] = [
        EntryData(title: "Amazon Shopping", email: "max1988@meinedomain.com", password: "", website: "http://www.meinedomain.com/login/users/id=32132164")
    ]
    
    
    var body: some View {
            
            // Standardschriften ------------------------------------------------------
            
            Text("Angemeldet: \(signInViewModel.userNameKeyPublic)")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color.ShishiColorBlack)
                .padding(.horizontal, 20)
                .padding(.vertical, 1)
            
            Text("Bereichsbeschreibung")
                .font(.title3)
                .foregroundStyle(Color.ShishiColorDarkGray)
                .padding(.horizontal, 20)
                .padding(.vertical, 1)
            
            Text("Normaler Text")
                .font(.callout)
                .foregroundStyle(Color.ShishiColorBlack)
                .padding(.horizontal, 20)
                .padding(.vertical, 2)
            
            Text("Kleiner Text für unter Textfelder")
                .font(.caption)
                .foregroundStyle(Color.ShishiColorDarkGray)
                .padding(.horizontal, 20)
                .padding(.vertical, 1)
            
            Divider()
            
            // Standard-Logo und Farbe -----------------------------------------
            
            Image("ShishiLogo_600")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
                .clipShape(.rect(cornerRadius: 25))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            Divider()
            
        ScrollView {
            
            // Standard-Listelemente -----------------------------------------
            ForEach(entries) { entry in
                NavigationLink {
                    ComponentsExampleView()
                } label: {
                    EntrieListItem(
                        titel: entry.title,
                        email: entry.email,
                        created: entry.created,
                        website: entry.website ?? "")
                }
            }
            
            Divider()
            
            // Standard-Textfeld und Password -----------------------------------------
            
            VStack {
                TextField("Textfeld", text: $text)
                    .frame(height: 30)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.ShishiColorDarkGray, lineWidth: 1))
                
                HStack {
                    Text("Benutzereingabe")
                        .font(.caption)
                        .foregroundStyle(Color.ShishiColorDarkGray)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
            } .padding(.horizontal).padding(.vertical, 5)
            
            
            VStack {
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $text)
                            .frame(height: 30)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Color.ShishiColorDarkGray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.ShishiColorDarkGray, lineWidth: 1))
                    } else {
                        SecureField("Password", text: $text)
                            .frame(height: 30)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Color.ShishiColorDarkGray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.ShishiColorDarkGray, lineWidth: 1))
                    }
                    Button(action: {
                        if !text.isEmpty {
                            isPasswordVisible.toggle()
                        }
                    }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(isPasswordVisible ? Color.ShishiColorBlue : Color.ShishiColorRed)
                    }
                    .padding(.horizontal).padding(.vertical, 5)
                }
                HStack {
                    Text("Passworteinagabe")
                        .font(.caption)
                        .foregroundStyle(Color.ShishiColorDarkGray)
                        .padding(.horizontal, 20)
                    Spacer()
                }
            } .padding()
            
            
            Divider()
            
            
            // Standard-Button -----------------------------------------
            
            Button {
                signInViewModel.logout()
            } label: {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.ShishiColorRed)
                    .frame(height: 50)
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        Text("Logout Test")
                            .font(.title3).bold()
                            .foregroundColor(.white)
                    )
            }
            
            // .navigationBarBackButtonHidden(true)
            .navigationTitle("Einstellungen")
        }
        
    }
}


#Preview {
    
    ComponentsExampleView()
        .environmentObject(SignInViewModel())
}
