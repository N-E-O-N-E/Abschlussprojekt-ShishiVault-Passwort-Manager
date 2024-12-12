//
//  HelpView.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 03.12.24.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text("Hilfe")
                    .ueberschriftLargeBold()
                Spacer()
                Image("ShishiLogo_600")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 85)
                    .clipShape(.rect(cornerRadius: 15))
                    .padding(.horizontal, 25)
            }.padding(.vertical, 15)
            
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Über Shishi Vault")
                            .ueberschriftenTextBold()
                        Text("Mit der Shishi Vault App speichern Sie Ihre sensiblen Daten verschlüsselt und sicher auf Ihrem Gerät und in der iCloud. Shishi Vault gewährleistet die Sicherheit und Vertraulichkeit Ihrer Daten und schützt vor Datenmissbrauch durch Dritte.")
                            .normalerText()
                        Image("screen_login")
                            .helpPictures()
                        Divider()
                        
                        Text("\nNach der Anmeldung")
                            .ueberschriftenTextBold()
                        Text("Nach der Anmeldung haben Sie ein Master-Passwort vergeben. Hinterlegen Sie dieses Passwort sicher und geschützt vor Dritten an einem Ort außerhalb Ihres Geräts. Dieses Passwort dient in Kombination mit Ihrer Apple-ID, welche bei der Anmeldung ausgelesen wurde, als Key-Value-Paar zur AES-Datenverschlüsselung der gesamten Daten und ist für die Wiederherstellung notwendig.")
                            .normalerText()
                        Image("screen_masterkey")
                            .helpPictures()
                        Divider()
                        
                        Text("\nDaten und Datenexport")
                            .ueberschriftenTextBold()
                        Text("Alle Daten dieser App werden verschlüsselt in einer JSON-Datei auf Ihrem Gerät gespeichert. In den Einstellungen haben Sie jederzeit die Möglichkeit, diese Daten auch als 'Klartext' zu exportieren. Nutzen Sie diese Option nur bedingt, um die Daten bei Bedarf außerhalb Ihres Geräts unverschlüsselt und auf eigenes Risiko zu verwenden.")
                            .normalerText()
                        Image("screen_settings")
                            .helpPictures()
                        
                        Text("Nutzen Sie regelmäßig die Cloud-Synchronisation, um die Daten auf einem anderen Gerät zu synchronisieren oder bei Bedarf wiederherzustellen. Der Upload sowie der Download erfolgen nicht automatisiert!")
                            .normalerText()
                        Divider()
                        
                        Text("\nHomeScreen")
                            .ueberschriftenTextBold()
                        Text("Auf dem Homescreen finden Sie in der oberen Navigation den Hilfebildschirm, in dem Sie sich gerade befinden, sowie den Zugang zu den Einstellungen. Im mittleren Bereich haben Sie die Möglichkeit, Einträge anhand ihres Titels zu durchsuchen oder die Sortierung der Einträge nach Titel oder nach dem zuletzt aktualisierten Datum vorzunehmen. Durch einen Klick auf einen Eintrag gelangen Sie in dessen Vorschaubereich, in dem Sie auch die Möglichkeit zum Bearbeiten oder Löschen haben. Nutzen Sie den grünen Add-Button, um einen neuen Eintrag über den Homescreen zu erstellen.")
                            .normalerText()
                        Image("screen_home")
                            .helpPictures()
                        Divider()
                        
                        Text("\nEinträge anzeigen")
                            .ueberschriftenTextBold()
                        Text("Über die Seite 'Hinzufügen' haben Sie die Möglichkeit, neben den Standardfeldern auch eigene Felder hinzuzufügen, um jeden Eintrag individuell gestalten zu können. Nutzen Sie die QuickIcons, um z. B. ein 12-stelliges Passwort nach dem Zufallsprinzip zu generieren oder um das eingegebene Passwort über eine externe API auf einen möglichen Kompromittierungsstatus prüfen zu lassen.")
                            .normalerText()
                        
                        Image("screen_add")
                            .helpPictures()
                        Divider()
                        
                        Text("\nPasswort-Generator")
                            .ueberschriftenTextBold()
                        Text("Nutzen Sie jederzeit den über die Toolbar erreichbaren Passwort-Generator. Der Passwort-Generator nutzt eine externe API und generiert auf Basis der zuvor eingestellten Parameter sichere Passwörter. Gleichzeitig wird auch dieses Passwort auf dessen Kompromittierungsstatus geprüft.")
                            .normalerText()
                        Image("screen_generator")
                            .helpPictures()
                        Divider()
                        
                    }.padding(.horizontal, 20)
                    Spacer()
                }
            }
        }
        
        Spacer()
        
            .navigationBarBackButtonHidden(true)
        
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color.ShishiColorBlue)
                        Text("Zurück")
                            .foregroundColor(Color.ShishiColorBlue)
                    }
                }
            }
    }
}

#Preview {
    HelpView()
}
