//
//  HomeView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 15.11.24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    @StateObject var entrieViewModel: EntriesViewModel
    
    @State private var showAddEntrieView: Bool = false
    @State private var entrieShowView: Bool = false
    @State private var showComponentsView: Bool = false
    @State private var searchText: String = ""
    let zufall = Range(0...100)
    
    init() {
        let key = ShishiViewModel().symetricKey
        _entrieViewModel = StateObject(wrappedValue: EntriesViewModel(key: key))
    }
    
    var body: some View {
        VStack {
            TextField("Suche", text: $searchText)
                .customSearchField()
        }.padding(.horizontal).padding(.vertical, 5)
        
        ScrollView {
            VStack {
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
            } // End VStack
            .frame(maxWidth: .infinity)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showComponentsView.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        entrieViewModel.createEntry(
                            title: "Testeintrag \(zufall.randomElement() ?? 0)",
                            username: "Max Mustermann", email: "text@meineDomain.com",
                            password: "1234", passwordConfirm: "1234", notes: "TestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotesTestnotes",
                            website: "http://testserver.com/", customFields: [])
                        
                        if let key = shishiViewModel.symetricKey {
                            Task {
                                await JSONHelper.shared.saveEntriesToJSON(
                                    key: key,
                                    entries: entrieViewModel.entries)
                            }
                        }
                        
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            } // End Toolbar
            
        } // End ScrollView
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
            ComponentsExampleView()
        })
        
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Shishi Vault")
        
        .onAppear {
            Task {
                await entrieViewModel.reloadEntries()
            }
        }
        
    }
}

#Preview {
    HomeView()
        .environmentObject(ShishiViewModel())
        .environmentObject(EntriesViewModel(key: .init(nilLiteral: ())))
}
