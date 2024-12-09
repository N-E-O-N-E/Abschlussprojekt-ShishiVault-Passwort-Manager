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
        ZStack {
            Rectangle()
                .foregroundStyle(Color.ShishiColorPanelBackground).clipShape(.rect(cornerRadius: 10))
                .shadow(color: .ShishiColorBlue, radius: 3, x: 0, y: 4).opacity(0.2)
            HStack {
                Text(title.prefix(1))
                    .frame(width: 30, alignment: .center).font(.largeTitle).bold().foregroundStyle(Color.ShishiColorBlue.opacity(0.2))
                    .scaleEffect(1.9).padding(.horizontal, 15)
                
                VStack(alignment: .leading) {
                    Text(title.count > 30 ? String(title.prefix(30)) + " ..." : title)
                        .panelTextBold()
                    HStack {
                        Text("Mail:")
                            .panelText()
                        Text(email.count > 30 ? String(email.prefix(30)) + " ..." : email)
                            .panelText()
                        Spacer()
                    }
                    HStack {
                        Text("Link:")
                            .panelText()
                        Text(website.count > 30 ? String(website.prefix(30)) + " ..." : website)
                            .panelText()
                        Spacer()
                    }
                    Divider()
                    Text("Aktualisiert am: \(created.formatted())")
                        .font(.caption2).foregroundStyle(Color.ShishiColorDarkGray).padding(0)
                }
               
                Spacer()
                
            }
            .padding(10)
        }
        .padding(.horizontal).padding(.vertical, 1)
    }
}

#Preview {
    EntrieListItem(title: "Amazon Shopping", email: "markus@meinedomain.com", created: Date(), website: "http://www.meinedomain.com")
}
