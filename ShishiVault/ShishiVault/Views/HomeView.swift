//
//  HomeView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 15.11.24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    @State private var showAddEntrieView: Bool = false
    @State private var showComponentsView: Bool = false
    
    var body: some View {
        
        ScrollView {
            VStack {
                ForEach(entrieViewModel.entries) { entry in
                    NavigationLink {
                        // View()
                        
                    } label: {
                        EntrieListItem(
                            titel: entry.title,
                            email: entry.email,
                            created: entry.created,
                            website: entry.website ?? "")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showComponentsView.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
        } .overlay(
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
        })
        .navigationDestination(isPresented: $showComponentsView, destination: {
            ComponentsExampleView()
        })
        
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Shishi Vault")
    }
}

#Preview {
    HomeView()
        .environmentObject(SignInViewModel())
        .environmentObject(EntriesViewModel())
}
