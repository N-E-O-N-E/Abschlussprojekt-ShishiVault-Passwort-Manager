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
    @Binding var customFieldsForEntrie: [CustomField]
    @State private var name: String = ""
    @State private var textIsEmptyAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Neue Eingabefeld")
                .font(.title3)
                .foregroundStyle(Color.ShishiColorDarkGray)
                .padding(.horizontal, 20)
                .padding(.vertical, 1)
            
            TextField("Feldname", text: $name )
                .frame(height: 25)
                .textFieldStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .border(Color.ShishiColorDarkGray, width: 1)
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            HStack {
                Text(name)
                    .font(.caption)
                    .foregroundStyle(Color.ShishiColorDarkGray)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            
            Button {
                if !name.isEmpty {
                    customFieldsForEntrie.append(CustomField(name: name, value: ""))
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
            
            .presentationDetents([.fraction(0.3)])
        } .padding(.horizontal).padding(.vertical, 5)
            .alert("Eingabe fehlt!", isPresented: $textIsEmptyAlert) {
                Button("OK") {
                    textIsEmptyAlert.toggle()
                }
            } message: {
                Text("Das Textfeld für die Bezeichnung darf nicht leer sein!")
            }

        
        
    }
}
