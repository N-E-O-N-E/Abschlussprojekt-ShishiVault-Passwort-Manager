//
//  HelpView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 03.12.24.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text("Hilfe")
                    .ueberschriftLargeBold()
                Spacer()
                Image("ShishiLogo_600")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 85)
                    .clipShape(.rect(cornerRadius: 15))
                    .padding(.horizontal, 25)
            }.padding(.vertical, 15)
            
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        
                        
                        Text("Über Shishi Vault")
                            .ueberschriftenTextBold()
                        Image("pic1")
                            .helpPictures()
                        Text("Mit dem Shishi Vault Passwortmanager speichern die ihre Daten sicher und schnell. Shishi Vault gewährleistet die Sicherheit und Vertraulichkeit der schützeswerten Daten, indem er sensible Daten verschlüsselt speichert und so vor Datenmissbrauch durch dritte schüzt.")
                            .normalerText()
                        Divider()
                        
                        Text("\nSicherheit")
                            .ueberschriftenTextBold()
                        Text("Beschreibungstextdsadhjksdhjsakhdsjadhsajdhsakjdhsakjdhsajkdhasjkdhk")
                            .normalerText()
                        Divider()
                        
                        Text("\nDatenexport")
                            .ueberschriftenTextBold()
                        Text("Beschreibungstextdsadhjksdhjsakhdsjadhsajdhsakjdhsakjdhsajkdhasjkdhk")
                            .normalerText()
                        Divider()
                        
                        Text("\nPasswort-Generator")
                            .ueberschriftenTextBold()
                        Text("Beschreibungstextdsadhjksdhjsakhdsjadhsajdhsakjdhsakjdhsajkdhasjkdhk")
                            .normalerText()
                        Divider()
                        
                        Text("\nPasswort-Verifikation")
                            .ueberschriftenTextBold()
                        Text("Beschreibungstextdsadhjksdhjsakhdsjadhsajdhsakjdhsakjdhsajkdhasjkdhk")
                            .normalerText()
                        Divider()
                        
                        
                        
                        
                        
                        
                    }.padding(.horizontal, 20)
                    Spacer()
                }
            }
        }
        
        Spacer()
        
            .navigationBarBackButtonHidden(true)
        
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
    }
}

#Preview {
    HelpView()
}
