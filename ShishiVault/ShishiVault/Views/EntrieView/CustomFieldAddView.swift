//
//  CustomFieldAddView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 15.11.24.
//

import SwiftUI

struct CustomFieldAddView: View {
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    
    @Binding var customFieldSheet: Bool
    
    @State private var name: String = ""
    @State private var textIsEmptyAlert: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Neues Eingabefeld")
                .ueberschriftenTextBold()
            
            TextField("Feldname", text: $name )
                .customTextField()
            HStack {
                Text(name)
                    .customTextFieldText()
                
                Spacer()
            }
            
            Button {
                if !name.isEmpty {
                    entrieViewModel.createCustomField(customField: CustomField(name: name, value: ""))
                    customFieldSheet.toggle()
                } else {
                    textIsEmptyAlert.toggle()
                }
                
                
            } label: {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.ShishiColorRed)
                    .frame(height: 50)
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        Text("Speichern")
                            .font(.title3).bold()
                            .foregroundColor(.white)
                    )
            }
            
        }.padding(.horizontal).padding(.vertical, 5)
            .alert("Eingabe fehlt!", isPresented: $textIsEmptyAlert) {
                Button("OK") {
                    textIsEmptyAlert.toggle()
                }
            } message: {
                Text("Das Textfeld für die Bezeichnung darf nicht leer sein!")
            }
        
            .presentationDetents([.fraction(0.35)])
        
    }
}
