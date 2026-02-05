import SwiftUI
import CryptoKit
import SwiftData

struct HomeView: View {
    let vaultContext: VaultContext
    @Environment(\.modelContext) private var modelContext
    
    @Query private var rawEntries: [EntryModel]
    
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    
    @State private var showAddEntrieView: Bool = false
    @State private var entrieShowView: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var showHelpView: Bool = false
    @State private var sortByDate: Bool = false
    @State private var searchText: String = ""
    
    var filteredEntries: [EntryData] {
        entrieViewModel.entries.filter { entry in
            searchText.isEmpty || entry.title.lowercased().contains(searchText.lowercased())
        }
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
                            Text("\n\n\nKeine Daten zum Laden vorhanden!\n\n")
                            Text("\n\nVielleicht haben Sie Datensicherungen zum einlesen??\n\n")
                        }.padding().multilineTextAlignment(.center)
                        
                    } else {
                        
                        
                        
                        ForEach(filteredEntries) { entry in
                            NavigationLink {
                                // Erst beim Klick wird das Modell in das Klartext-Struct umgewandelt
                                
                                EntrieShowView(entrieShowView: .constant(true), entry: entry)
                                    .environmentObject(entrieViewModel)
                                    .environmentObject(shishiViewModel)
                                
                            } label: {
                                // Für die Liste entschlüsseln wir nur Titel/Mail (bereits im Modell vorhanden)
                                EntrieListItem(title: entry.title,
                                               email: entry.email,
                                               created: entry.created,
                                               website: entry.website ?? "")
                            }
                        }
                    }
                }
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
                }
            }
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
                await entrieViewModel.reloadEntries(
                    modelContext: modelContext,
                    vaultContext: vaultContext
                )
            }
        }
        .onChange(of: rawEntries) { reloadEntries() }
        
        .navigationBarBackButtonHidden(true)
        .foregroundStyle(Color.ShishiColorBlue)
    }
    
    private func reloadEntries() {
        Task {
            await entrieViewModel.reloadEntries(modelContext: modelContext, vaultContext: vaultContext)
        }
    }
    
    private func decrypt(model: EntryModel) -> EntryData? {
        let key = SymmetricKey(data: vaultContext.loginKey)
        do {
            let passData = try CryptHelper.shared.decrypt(cipherText: model.encryptedPassword, key: key)
            let notesData = try CryptHelper.shared.decrypt(cipherText: model.encryptedNotes, key: key)
            
            return EntryData(
                id: model.id,
                title: model.title,
                username: model.username,
                email: model.email,
                password: String(data: passData, encoding: .utf8) ?? "",
                notes: String(data: notesData, encoding: .utf8),
                website: model.website
            )
        } catch {
            print("Entschlüsselung fehlgeschlagen")
            return nil
        }
    }
}
