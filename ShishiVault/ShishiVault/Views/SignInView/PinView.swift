//
//  PinView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 06.12.24.
//

import SwiftUI

struct PinView: View {
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var enteredPIN: String = ""
    
    var body: some View {
        VStack {
            Image("ShishiLogo_600")
                .resizable().scaledToFit().frame(width: 250).clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text("\n\nBitte PIN eingeben")
                .ueberschriftenTextBold()
            
            TextField("PIN", text: $enteredPIN)
                .customTextField().padding(.horizontal, 20).padding(.vertical, 30)
            
            Button(action: {
                if shishiViewModel.unlockApp(with: enteredPIN) {
                    print("App entsperrt")
                    shishiViewModel.isLocked = false
                } else {
                    print("Falscher PIN!")
                    shishiViewModel.isLocked = true
                }
            }) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.ShishiColorBlue).frame(height: 50).padding().foregroundColor(.white)
                    .overlay(
                        Text("Entsperren")
                            .font(.title3).bold()
                            .foregroundColor(.white))
                
            }.padding(.horizontal, 20)
            
            Button(action: {
                shishiViewModel.logout()
                dismiss()
            }) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.ShishiColorRed).frame(height: 50).padding().foregroundColor(.white)
                    .overlay(
                        Text("Abmelden")
                            .font(.title3).bold()
                            .foregroundColor(.white))
                
            }.padding(.horizontal, 20)
            
        }
    }
}

#Preview {
    PinView()
}
