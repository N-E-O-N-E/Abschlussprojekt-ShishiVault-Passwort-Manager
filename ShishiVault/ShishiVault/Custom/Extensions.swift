//
//  Colors.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 12.11.24.
//

import SwiftUI

// Shishi Vault spezifische Farben für Komponenten
extension Color {
    static let ShishiColorRed = Color(red: 0.71, green: 0, blue: 0.21)
    static let ShishiColorBlue = Color(red: 0.15, green: 0.35, blue: 0.50)
    static let ShishiColorDarkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let ShishiColorGray = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let ShishiColorBlack = Color(red: 0.0, green: 0.0, blue: 0.0)
    static let ShishiColorPanelBackground = Color(red: 245/255, green: 250/255, blue: 255/255)
    static let ShishiColorPanelBackground_backup = Color(red: 205/255, green: 240/255, blue: 255/255)
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

extension Text {
    func ueberschriftLargeBold() -> some View {
        self
            .font(.largeTitle).bold()
            .foregroundStyle(Color.ShishiColorBlack)
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
    }
}

extension Text {
    func ueberschriftenText() -> some View {
        self
            .font(.title3)
            .foregroundStyle(Color.ShishiColorDarkGray)
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
    }
}

extension Text {
    func ueberschriftenTextBold() -> some View {
        self
            .font(.title3).bold()
            .foregroundStyle(Color.ShishiColorDarkGray)
            .padding(.horizontal, 20)
            .padding(.vertical, 1)
    }
}

extension TextField {
    func customTextField() -> some View {
        self
            .frame(height: 25)
            .textFieldStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ShishiColorGray, lineWidth: 1 ))
            .padding(1)
            .disableAutocorrection(true)
    }
}
extension Text {
    func customTextFieldText() -> some View {
        self
            .font(.caption)
            .foregroundStyle(Color.ShishiColorDarkGray)
            .padding(.horizontal, 20)
    }
}



extension TextField {
    func customPasswordField() -> some View {
        self
            .frame(height: 25)
            .textFieldStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ShishiColorGray, lineWidth: 1))
            .padding(1)
            .disableAutocorrection(true)
    }
}
extension SecureField {
    func customSecureField() -> some View {
        self
            .frame(height: 25)
            .textFieldStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ShishiColorGray, lineWidth: 1))
            .padding(1)
            .disableAutocorrection(true)
    }
}
