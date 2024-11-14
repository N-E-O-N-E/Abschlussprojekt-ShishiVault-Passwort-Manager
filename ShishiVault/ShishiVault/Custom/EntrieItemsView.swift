//
//  EntireItemsView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 14.11.24.
//

import SwiftUI

struct EntireItemsView: View {
    
    var titel: String
    var username: String
    var email: String
    var created: Date
    var website: String?
    
    var body: some View {
        
        List {
        // Einträge-Element
        ZStack {
            Rectangle()
                .foregroundStyle(Color.ShishiColorPanelBackground)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 2, x: 0, y: 2)
            
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundStyle(Color.ShishiColorBlue)
                    .scaleEffect(2.5)
                    .padding(15)
                
                VStack(alignment: .leading) {
                    Text(titel)
                        .font(.title3)
                        .foregroundStyle(Color.ShishiColorBlack)
                        .bold()
                        .padding(0)
                    Text("Mail: \(email.count > 30 ? String(email.prefix(30)) + " ..." : email)")
                        .font(.footnote)
                        .foregroundStyle(Color.ShishiColorBlack)
                        .padding(0)
                    Text("Web: \(website.count > 30 ? String(website.prefix(30)) + " ..." : website)")
                        .font(.footnote)
                        .foregroundStyle(Color.ShishiColorBlack)
                        .padding(0)
                    
                    Divider()
                    Text("Aktualisiert am: \(created.formatted())")
                        .font(.caption2)
                        .foregroundStyle(Color.ShishiColorDarkGray)
                        .padding(0)
                }
                Spacer()
                Image(systemName: "info.circle")
                    .scaleEffect(1)
                    .foregroundColor(Color.ShishiColorDarkGray)
                    .padding(10)
                
            }.padding(8)
        }.padding()
    }
        
        
    }
}

#Preview {
    EntireItemsView(titel: "", username: "", email: "", created: Date(), website: "")
}
