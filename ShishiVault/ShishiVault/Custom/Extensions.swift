//
//  Colors.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 12.11.24.
//

import SwiftUI

// Shishi Vault spezifische Farben, Text- und TextFeld formatierungen

extension Color {
    static let ShishiColorRed = Color(red: 0.71, green: 0, blue: 0.21)
    static let ShishiColorGreen = Color(red: 0.15, green: 0.55, blue: 0.20)
    static let ShishiColorBlue = Color(red: 0.15, green: 0.35, blue: 0.50)
    static let ShishiColorDarkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let ShishiColorGray = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let ShishiColorBlack = Color(red: 0.0, green: 0.0, blue: 0.0)
    static let ShishiColorPanelBackground = Color(red: 240/255, green: 250/255, blue: 255/255)
    static let ShishiColorPanelBackground_backup = Color(red: 205/255, green: 240/255, blue: 255/255)
}

// Formatierung Text für fette Überschrift
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
            .foregroundStyle(Color.ShishiColorDarkGray)
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
    }
}

// Formatierung Text für fette Überschrift
extension Text {
    func ueberschriftenTextBold() -> some View {
        self
            .font(.title3).bold()
            .foregroundStyle(Color.ShishiColorDarkGray)
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
            .padding(.vertical, 0.5)
    }
}
// Formatierung Text für Paneltext
extension Text {
    func panelText() -> some View {
        self
            .font(.footnote)
            .foregroundStyle(Color.ShishiColorBlack)
            .padding(.horizontal, 1)
            .padding(.vertical, 0.5)
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
            .padding(1)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
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
            .padding(1)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
    }
}


// Passender kleiner Text für Textfelder
extension Text {
    func customTextFieldText() -> some View {
        self
            .font(.caption)
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
            .padding(1)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
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
            .padding(1)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
    }
}
