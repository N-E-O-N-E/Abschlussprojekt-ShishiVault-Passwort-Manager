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
    
    private var statusWidthFromCount: CGFloat {
        var value: CGFloat = 0
        if userSaltInput.count < 3 {
            value = 10
        } else if userSaltInput.count >= 3 && userSaltInput.count < 5 {
            value =  50
        } else if userSaltInput.count >= 5 && userSaltInput.count < 7 {
            value =  150
        } else if userSaltInput.count >= 7 && userSaltInput.count < 10 {
            value =  230
        } else if userSaltInput.count >= 10 && userSaltInput.count < 16 {
        value =  330
    }
    return value
}
    private var statusColor: Color {
        if userSaltInput.count <= 4 {
            return Color.ShishiColorRed_
        } else if userSaltInput.count > 4 && userSaltInput.count <= 6 {
            return Color.orange
        } else if userSaltInput.count > 6 {
            return Color.ShishiColorGreen
        }
        return Color.gray
    }
    
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
                
                VStack {
                    ZStack(alignment: .leading) {
                        Capsule().frame(width: 330, height: 20).foregroundStyle(Color.gray.opacity(0.2))
                        Capsule().frame(width: statusWidthFromCount, height: 20).foregroundStyle(statusColor)
                    }
                }.padding(.horizontal, 20)
                
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
    }
}

#Preview {
    SetSaltKeyView(shishiViewModel: ShishiViewModel())
        .environmentObject(ShishiViewModel())
}
