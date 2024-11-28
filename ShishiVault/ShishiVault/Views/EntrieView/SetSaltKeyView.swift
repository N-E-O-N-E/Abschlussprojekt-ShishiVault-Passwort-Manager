//
//  viewSetSaltKey.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 27.11.24.
//

import SwiftUI

struct SetSaltKeyView: View {
    @ObservedObject var shishiViewModel: ShishiViewModel
    @State private var userSaltInput: String = ""
    @State private var keyAlert: Bool = false
    
    var body: some View {
        VStack {
            Image("ShishiLogo_600")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.vertical, 20)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Ihr persönlicher Master-Key")
                    .ueberschriftenTextBold()
                    .padding(.vertical, 15)
                
                PWLevelColorView(password: $userSaltInput)
                
                TextField("", text: $userSaltInput )
                    .customTextField()
                    .padding(.vertical, 15)
                
                Text("Achtung!")
                    .warningTextLarge().bold()
                
                Text("Bitte notieren Sie sich den Master-Key an einem sicheren und für dritte nicht einsehbaren Ort.\n\nDer Verlust dieses Schlüssels bedeutet, dass Sie Ihre Daten nicht wiederherstellen können.\n\nDer Master-Key erzeugt in Verbindung mit Ihrer AppleID den Schlüssel für den Zugriff auf alle Daten!")
                    .normalerText()
                
                Spacer()
                
                Button {
                    if !userSaltInput.isEmpty {
                        Task {
                            do {
                                let userInputHash = try CryptHelper.shared.generateSaltedHash(from: userSaltInput)
                                shishiViewModel.saveTempUserSalt(data: userInputHash)
                            } catch {
                                print("Error while generating hash: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        print("Salt is empty?")
                        keyAlert.toggle()
                    }
                    
                } label: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.ShishiColorRed)
                        .frame(height: 50)
                        .padding()
                        .foregroundColor(.white)
                        .overlay(
                            Text("Speichern")
                                .font(.title3).bold()
                                .foregroundColor(.white)
                        )
                }
            }.padding(.horizontal).padding(.vertical, 5)
        }
        .navigationBarBackButtonHidden()
        
        .alert("Master-Key\n", isPresented: $keyAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
                Text("Der MasterKey darf nicht leer sein!")
        })
    }
}

#Preview {
    SetSaltKeyView(shishiViewModel: ShishiViewModel())
        .environmentObject(ShishiViewModel())
}
