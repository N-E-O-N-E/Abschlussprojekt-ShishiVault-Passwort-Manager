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
    @State private var showAddEntrieView: Bool = false
    @State private var entrieShowView: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var showHelpView: Bool = false
    @State var sortByDate: Bool = false
    @State private var searchText: String = ""
    
    init() {
        let key = ShishiViewModel().symmetricKeychainString
        _entrieViewModel = StateObject(wrappedValue: EntriesViewModel(symmetricKeyString: key))
    }
    
    var body: some View {
        VStack {
            Image("ShishiLogo_HomeBeta")
                .resizable().scaledToFit().shadow(radius: 2, x: 0, y: 2).padding(0)
            
            VStack {
                HStack {
                    TextField("\(Image(systemName: "magnifyingglass")) Suche (z.B. \"Apple\")", text: $searchText)
                        .customSearchField()
                    Button {
                        sortByDate.toggle()
                    } label: {
                        Text(sortByDate ? "DATUM" : "TITEL")
                            .panelText().opacity(0.5)
                        Image(systemName: sortByDate ? "arrow.up.arrow.down.square.fill" : "arrow.up.arrow.down.square")
                            .padding(1)
                    }
                }
            }.padding(.horizontal).padding(.vertical, 5)
            
            ScrollView {
                VStack {
                    if entrieViewModel.entries.isEmpty {
                        VStack(alignment: .center) {
                            Text("\n\nKeine Daten zum Laden vorhanden!\n\n")
                                .bold()
                            Text("Warnung: Wenn Sie die App zuvor installiert hatten, sollten sie sich über die Einstellungen 'Abmelden' um einen neuen Masterkey vergeben zu können. Standardmäßig werden die Anmeldedaten in ihrer Keychain mit dem zuletzt vergebenen Master-Passwort nicht gelöscht auch wenn sie die APP deinstallieren!\n\n")
                                .warningTextLarge().multilineTextAlignment(.center)
                        }.padding()
                        
                    } else {
                        if sortByDate {
                            ForEach(entrieViewModel.entries.filter { entry in
                                searchText.isEmpty || entry.title.lowercased().contains(searchText.lowercased())
                            }.sorted(by: { $0.created > $1.created }) ) { entry in
                                NavigationLink {
                                    EntrieShowView(entrieShowView: $entrieShowView, entry: entry)
                                        .environmentObject(entrieViewModel)
                                        .environmentObject(shishiViewModel)
                                } label: {
                                    EntrieListItem(title: entry.title, email: entry.email,
                                                   created: entry.created, website: entry.website ?? "")
                                }
                            }
                        } else {
                            ForEach(entrieViewModel.entries.filter { entry in
                                searchText.isEmpty || entry.title.lowercased().contains(searchText.lowercased())
                            }.sorted(by: { $0.title < $1.title }) ) { entry in
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
                    }
                } // End VStack
                
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showHelpView.toggle()
                        } label: {
                            Image(systemName: "info.bubble.rtl")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSettingsView.toggle()
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
                    .foregroundColor(.white).padding().background(Color.ShishiColorGreen).opacity(0.75).clipShape(Circle())
                    .scaleEffect(1.3).shadow(radius: 1)
            }
                .padding(.bottom, 20).padding(.trailing, 50),
            alignment: .bottomTrailing)
        
        .navigationDestination(isPresented: $showAddEntrieView, destination: {
            EntrieAddView(showAddEntrieView: $showAddEntrieView)
                .environmentObject(entrieViewModel)
                .environmentObject(shishiViewModel) })
        .navigationDestination(isPresented: $showSettingsView, destination: {
            SettingsView()
                .environmentObject(shishiViewModel)
                .environmentObject(entrieViewModel) })
        .navigationDestination(isPresented: $showHelpView, destination: {
            HelpView() })
        
        .onAppear {
            Task {
                await entrieViewModel.reloadEntries()
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .foregroundStyle(Color.ShishiColorBlue)
    }
}

#Preview {
    HomeView()
        .environmentObject(ShishiViewModel())
}
