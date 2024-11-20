//
//  EntireItemsView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 14.11.24.

import SwiftUI

struct EntrieListItem: View {
    
    var title: String = ""
    var email: String = ""
    var created = Date()
    var website: String = ""
    
    var body: some View {
        // Einträge-Element
        ZStack {
            Rectangle()
                .foregroundStyle(Color.ShishiColorPanelBackground)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 2, x: 0, y: 2)
            
            HStack {
                Image(systemName: "lock.document.fill")
                    .foregroundStyle(Color.ShishiColorBlue)
                    .scaleEffect(2.2)
                    .padding(.horizontal, 15)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .panelTextBold()
                    HStack {
                        Text("Mail:")
                            .panelText()
                        Text(email.count > 25 ? String(email.prefix(25)) + " ..." : email)
                            .panelText()
                        Spacer()
                    }
                    HStack {
                        Text("Link:")
                            .panelText()
                        Text(website.count > 26 ? String(website.prefix(26)) + " ..." : website)
                            .panelText()
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    Text("Aktualisiert am: \(created.formatted())")
                        .font(.caption2)
                        .foregroundStyle(Color.ShishiColorDarkGray)
                        .padding(0)
                }
                Spacer()
                
                Image(systemName: "info.circle")
                    .scaleEffect(1.2)
                    .foregroundColor(Color.ShishiColorDarkGray)
                    .padding(10)
                
            }
            .padding(10)
            
        }
        .padding(.horizontal)
        .padding(.vertical, 1)
        
    }
}

#Preview {
    EntrieListItem(title: "Amazon Shopping", email: "markus@meinedomain.com", created: Date(), website: "http://www.meinedomain.com")
}
