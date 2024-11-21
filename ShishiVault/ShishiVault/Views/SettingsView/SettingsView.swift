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
    @Environment(\.dismiss) private var dismiss
    
    @State private var isLogoutAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
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
                    .padding(.vertical, 10)
            }
            Divider()
            
            VStack(alignment: .leading) {
                Text("Unverschlüsselter Export der Daten")
                Button {
                    //
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed)
                        .frame(width: 180, height: 30)
                        .foregroundColor(.white)
                        .overlay(
                            Text("Export")
                                .font(.title3).bold()
                                .foregroundColor(.white))
                }.padding(.vertical, 10)
                
                Divider()
                
                Text("Syncronisieren Sie Ihre Daten mit der iCloud")
                
                HStack {
                    Button {
                        //
                    } label: {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.ShishiColorRed)
                            .frame(width: 180, height: 30)
                            .foregroundColor(.white)
                            .overlay(
                                Text("Upload")
                                    .font(.title3).bold()
                                    .foregroundColor(.white))
                    }.padding(.vertical, 10)
                    Button {
                        //
                    } label: {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.ShishiColorRed)
                            .frame(width: 180, height: 30)
                            .foregroundColor(.white)
                            .overlay(
                                Text("Download")
                                    .font(.title3).bold()
                                    .foregroundColor(.white))
                    }.padding(.vertical, 10)
                }

                
            }.padding(20)
        
        
       
            
            
            Spacer()
            
                .navigationBarBackButtonHidden(true)
            // .navigationTitle("Einstellungen")
        }.padding(.vertical, 20)
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
                        isLogoutAlert.toggle()
                    } label: {
                        Image(systemName: "door.left.hand.open")
                            .foregroundStyle(Color.ShishiColorRed)
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
    }
}

#Preview {
    
    SettingsView()
        .environmentObject(ShishiViewModel())
}
