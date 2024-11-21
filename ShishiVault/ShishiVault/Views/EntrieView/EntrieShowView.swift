//
//  EntrieAddView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 15.11.24.
//

import SwiftUI

struct EntrieShowView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    
    @Binding var entrieShowView: Bool
    @State var entrieEditView: Bool = false
    var entry: EntryData
    
    @State private var isDeleteAlert: Bool = false
    @State private var isPasswordVisible: Bool = false
    
    @State private var title: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    @State private var notes: String = ""
    @State private var website: String = ""
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(entry.title)
                    .textFieldAlsText()
                HStack {
                    Text("Title")
                        .customTextFieldText()
                    Spacer()
                }
                
                Text(entry.username ?? "")
                    .textFieldAlsText()
                HStack {
                    Text("Nutzername")
                        .customTextFieldText()
                    Spacer()
                }
                
                Text(entry.email)
                    .textFieldAlsText()
                HStack {
                    Text("E-Mail")
                        .customTextFieldText()
                    Spacer()
                }
                
                Text(entry.website ?? "")
                    .textFieldAlsText()
                HStack {
                    Text("Website")
                        .customTextFieldText()
                    Spacer()
                }
                
                HStack {
                    Text(isPasswordVisible ? entry.password : "*********")
                        .textFieldAlsText()
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(isPasswordVisible ? Color.ShishiColorDarkGray : Color.ShishiColorGray)
                            .scaleEffect(1.2)
                    }
                    .frame(width: 25)
                    .padding(.horizontal, 10)
                }
                      
                HStack {
                    Text("Passwort")
                        .customTextFieldText()
                    Spacer()
                }
                
                Text(entry.notes ?? "")
                    .notizenText()
                HStack {
                    Text("Notizen")
                        .customTextFieldText()
                    Spacer()
                }
                
                ForEach(entry.customFields ) { fields in
                    Text(fields.value)
                        .textFieldAlsText()
                    HStack {
                        Text(fields.name)
                            .customTextFieldText()
                        Spacer()
                    }
                }
                
                Divider()
                Text("\nErstellt am: \(entry.created.formatted(.dateTime))")
                    .customTextFieldText()
                
            }
        }.padding(.horizontal).padding(.vertical, 5)
        
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
                    entrieEditView = true
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(Color.ShishiColorBlue)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isDeleteAlert.toggle()
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(Color.ShishiColorRed)
                }
            }
        }
        
        .alert("Hinweis\n", isPresented: $isDeleteAlert, actions: {
            Button("Löschen", role: .destructive) {
                entrieViewModel.deleteEntry(entrie: entry)
                Task {
                    if let key = shishiViewModel.symetricKey {
                        JSONHelper.shared.deleteEntiresFromJSON(
                            key: key, entrie: entry)
                        JSONHelper.shared.saveEntriesToJSON(
                            key: key, entries: entrieViewModel.entries)
                        
                    }
                }
                entrieShowView = false
                dismiss()
            }
            Button("Abbrechen", role: .cancel) {
                isDeleteAlert.toggle()
            }
        }, message: {
            Text("Sind sie sich sicher, dass sie diesen Eintrag löschen möchten?\nDiese Aktion kann nicht rückgängig gemacht werden. Möchten Sie fortfahren?")
                
        })
        
        .navigationDestination(isPresented: $entrieEditView, destination: {
            EntrieEditView(entrieEditView: $entrieEditView, entry: entry)
                .environmentObject(shishiViewModel)
                .environmentObject(entrieViewModel)
        })
        
        .navigationBarBackButtonHidden(true)
        .navigationTitle(entry.title)
        .foregroundStyle(Color.ShishiColorBlue)
    }
}
