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
        HStack {
            Text("OnBoarding")
                .ueberschriftLargeBold()
            Spacer()
            Image("ShishiLogo_600")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 85)
                .clipShape(.rect(cornerRadius: 15))
                .padding(.horizontal, 25)
        }.padding(.vertical, 15)
        
        
        List(content: {
            NavigationLink("Hilfe zu Punkt 1") {
                
            }
        })
        
        
            
            
        
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
