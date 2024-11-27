//
//  HomeView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 15.11.24.
//

import SwiftUI
import CryptoKit

struct HomeView: View {
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    @StateObject var entrieViewModel: EntriesViewModel
    
    @State private var viewSetSaltKey: Bool = false
    @State private var showAddEntrieView: Bool = false
    @State private var entrieShowView: Bool = false
    @State private var showComponentsView: Bool = false
    @State private var searchText: String = ""
    let zufall = Range(0...100)
    
    init() {
        let key = ShishiViewModel().symmetricKeychainString
        _entrieViewModel = StateObject(wrappedValue: EntriesViewModel(symmetricKeyString: key))
    }
    
    var body: some View {
            VStack {
                Image("ShishiLogo_Home")
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 2, x: 0, y: 2)
                    .padding(0)
                
                VStack {
                    TextField("\(Image(systemName: "magnifyingglass")) Suche (z.B. \"Apple\")", text: $searchText)
                        .customSearchField()
                }.padding(.horizontal).padding(.vertical, 5)
                
                ScrollView {
                    VStack {
                        if entrieViewModel.entries.isEmpty {
                            Text("\n\n\nNoch keine Daten gespeichert.")
                                .warningTextLarge()
                        } else {
                            ForEach(entrieViewModel.entries.filter { entry in
                                searchText.isEmpty || entry.title.lowercased().contains(searchText.lowercased())
                            }) { entry in
                                NavigationLink {
                                    EntrieShowView(entrieShowView: $entrieShowView, entry: entry)
                                        .environmentObject(entrieViewModel)
                                        .environmentObject(shishiViewModel)
                                } label: {
                                    EntrieListItem(title: entry.title, email: entry.email,
                                                   created: entry.created, website: entry.website ?? "")
                                }
                            }
                        }
                    } // End VStack
                    .frame(maxWidth: .infinity)
                    
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("") {
                                entrieViewModel.createEntry(
                                    title: "Testeintrag \(zufall.randomElement() ?? 0)",
                                    username: "Max Mustermann", email: "text@meineDomain.com",
                                    password: "1234", passwordConfirm: "1234", notes: "TestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotes",
                                    website: "http://testserver.com/",
                                    customFields: [
                                        CustomField(name: "C1", value: "Test1"),
                                        CustomField(name: "C2", value: "Test2"),
                                        CustomField(name: "C3", value: "Test3")
                                    ])
                                
                                if let key = KeychainHelper.shared.loadCombinedSymmetricKeyFromKeychain(keychainKey: shishiViewModel.symmetricKeychainString) {
                                    Task {
                                        JSONHelper.shared.saveEntriesToJSON(
                                            key: key,
                                            entries: entrieViewModel.entries)
                                    }
                                }
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showComponentsView.toggle()
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                    } // End Toolbar
                    
                } // End ScrollView
            }
        .overlay(
            Button(action: {
                showAddEntrieView.toggle()
                
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.ShishiColorRed)
                    .clipShape(Circle())
                    .scaleEffect(1.3)
                    .shadow(radius: 5)
            }
                .padding(.bottom, 40)
                .padding(.trailing, 50),
            alignment: .bottomTrailing
        )
        
        .navigationDestination(isPresented: $showAddEntrieView, destination: {
            EntrieAddView(showAddEntrieView: $showAddEntrieView)
                .environmentObject(entrieViewModel)
                .environmentObject(shishiViewModel)
        })
        .navigationDestination(isPresented: $showComponentsView, destination: {
            SettingsView()
                .environmentObject(shishiViewModel)
                .environmentObject(entrieViewModel)
        })
        
        
        .onAppear {
            Task {
                await entrieViewModel.reloadEntries()
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .foregroundStyle(Color.ShishiColorBlue)
        
        .navigationDestination(isPresented: $viewSetSaltKey) {
            SetSaltKeyView(viewSetSaltKey: $viewSetSaltKey)
                .environmentObject(shishiViewModel)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ShishiViewModel())
}
