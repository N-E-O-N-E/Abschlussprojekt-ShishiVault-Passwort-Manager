//
//  Colors.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 12.11.24.
//

import SwiftUI

// Shishi Vault spezifische Farben, Text- und TextFeld formatierungen

extension Color {
    static let ShishiColorRed_ = Color(red: 0.71, green: 0, blue: 0.21)
    static let ShishiColorRed =
    Gradient(colors: [Color(red: 0.71, green: 0, blue: 0.21, opacity: 0.85),
                      Color(red: 0.71, green: 0, blue: 0.21)])
    static let ShishiColorGreen = Color(red: 0.15, green: 0.55, blue: 0.20)
    static let ShishiColorBlue = Color(red: 0.15, green: 0.35, blue: 0.50)
    static let ShishiColorDarkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let ShishiColorGray = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let ShishiColorBlack = Color(red: 0.0, green: 0.0, blue: 0.0)
    static let ShishiColorPanelBackground = Color(.white)// Color(red: 240/255, green: 245/255, blue: 255/255)
    static let ShishiColorPanelBackground_ =
    Gradient(colors: [Color(red: 235/255, green: 245/255, blue: 255/255),
                      Color(red: 245/255, green: 250/255, blue: 255/255)])
}

// Formatierung Text für Warnhinweise in Rot
extension Text {
    func warningTextLarge() -> some View {
        self
            .font(.body)
            .foregroundStyle(Color.ShishiColorRed_)
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
    }
}

extension Text {
    func ueberschriftLarge() -> some View {
        self
            .font(.largeTitle)
            .foregroundStyle(Color.ShishiColorBlack)
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
    }
}

// Formatierung Text für fette Überschrift Groß
extension Text {
    func ueberschriftLargeBold() -> some View {
        self
            .font(.largeTitle).bold()
            .foregroundStyle(Color.ShishiColorBlack)
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
    }
}

// Formatierung Text für Überschrift
extension Text {
    func ueberschriftenText() -> some View {
        self
            .font(.title3)
            .foregroundStyle(Color.black)
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
    }
}

// Formatierung Text für fette Überschrift
extension Text {
    func ueberschriftenTextBold() -> some View {
        self
            .font(.title3).bold()
            .foregroundStyle(Color.black)
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
    }
}

// Formatierung Text für normalen Fließtext
extension Text {
    func normalerText() -> some View {
        self
            .font(.callout)
            .foregroundStyle(Color.ShishiColorBlack)
            .padding(.horizontal, 20)
            .padding(.vertical, 2)
    }
}

// Formatierung Text für Fließtext in Fett
extension Text {
    func normalerTextBold() -> some View {
        self
            .font(.callout).bold()
            .foregroundStyle(Color.ShishiColorBlack)
            .padding(.horizontal, 20)
            .padding(.vertical, 2)
    }
}

// Formatierung Text für Paneltext in Fett
extension Text {
    func panelTextBold() -> some View {
        self
            .font(.callout).bold()
            .foregroundStyle(Color.ShishiColorBlack)
            .padding(.horizontal, 1)
            .padding(.vertical, 0)
    }
}
// Formatierung Text für Paneltext
extension Text {
    func panelText() -> some View {
        self
            .font(.footnote)
            .foregroundStyle(Color.ShishiColorBlack)
            .padding(.horizontal, 1)
            .padding(.vertical, 0.1)
    }
}

// Formatierung Text für die Anzeige der Daten mit Rahmen ohne Bearbeitungsfunktion
extension Text {
    func textFieldAlsText() -> some View {
        self
            .frame(maxWidth: 400, maxHeight: 25, alignment: .topLeading)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ShishiColorGray, lineWidth: 1 ))
            .foregroundStyle(Color.ShishiColorGray)
            .padding(1)
    }
}

// Formatierung Text für die Notizen mit Rahmen
extension Text {
    func notizenText() -> some View {
        self
            .frame(maxWidth: 400, maxHeight: 75, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ShishiColorGray, lineWidth: 1 ))
            .padding(1)
    }
}
   
// Texteingabe Multiline
extension TextEditor {
    func customTextFieldNotes() -> some View {
        self
            .frame(height: 50, alignment: .topLeading)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ShishiColorGray, lineWidth: 1 ))
            .padding(1)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .textEditorStyle(.plain)
            .multilineTextAlignment(.leading)
    }
}

// Texteingabe für Daten
extension TextField {
    func customTextField() -> some View {
        self
            .frame(height: 20, alignment: .leading)
            .textFieldStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ShishiColorGray, lineWidth: 1 ))
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .padding(0.5)
    }
}

// Texteingabe für das Suchefeld im HomeScreen
extension TextField {
    func customSearchField() -> some View {
        self
            .frame(height: 20, alignment: .leading)
            .textFieldStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ShishiColorGray, lineWidth: 1 ))
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            
    }
}


// Passender kleiner Text für Textfelder
extension Text {
    func customTextFieldTextLow() -> some View {
        self
            .font(.caption)
            .foregroundStyle(Color.ShishiColorDarkGray)
            .padding(.horizontal, 20)
    }
}

// Passender kleiner Text für Beschreibungen
extension Text {
    func customTextFieldTextMid() -> some View {
        self
            .font(.caption2)
            .foregroundStyle(Color.ShishiColorDarkGray)
            .padding(.horizontal, 20)
    }
}


// Passwortfeld klartext
extension TextField {
    func customPasswordField() -> some View {
        self
            .frame(height: 20)
            .textFieldStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ShishiColorGray, lineWidth: 1))
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .padding(0.5)
    }
}


// Passwortfeld mit Sichtschutz
extension SecureField {
    func customSecureField() -> some View {
        self
            .frame(height: 20)
            .textFieldStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ShishiColorGray, lineWidth: 1))
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .padding(0.5)
    }
}


/**
 
TextField("Titel", text: $title)
    .customTextField()
HStack {
    Text("Bezeichnung")
        .customTextFieldText()
    Spacer()
}


TextEditor(text: $notes)
    .customTextFieldNotes()
HStack {
    Text("Notizen")
        .customTextFieldText()
    Spacer()
}

TextEditor(text: $notes)
    .customTextFieldNotes()
HStack {
    Text("Notizen")
        .customTextFieldText()
    Spacer()
}


Button {
    
    
} label: {
    RoundedRectangle(cornerRadius: 25)
        .fill(Color.ShishiColorRed)
        .frame(height: 50)
        .padding()
        .foregroundColor(.white)
        .overlay(
            Text("Eintrag speichern")
                .font(.title3).bold()
                .foregroundColor(.white))
}
.padding(.horizontal).padding(.vertical, 5)


**/
