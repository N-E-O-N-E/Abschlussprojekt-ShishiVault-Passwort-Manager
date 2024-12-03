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
                        Text("Mit der Shishi Vault App speichern sie ihre sensiblen Daten verschlüsselt und sicher auf dem Gerät. Shishi Vault gewährleistet die Sicherheit und Vertraulichkeit ihrer Daten und schützt vor Datenmissbrauch durch dritte.")
                            .normalerText()
                        Image("pic3")
                            .helpPictures()
                        Divider()
                        
                        Text("\nNach der Anmeldung")
                            .ueberschriftenTextBold()
                        Text("Nach der Anmeldung haben Sie ein Master-Passwort vegeben. Hinterlegen sie dieses Passwort sicher und geschützt vor dritten an einem Ort außerhalb ihres Geräts. Dieses Passwort dient in Kombination mit Ihrer Apple-ID welches bei der Anmeldung ausgelesen wurde als KeyValue-Paar zur AES-Datenverschlüsselung der Daten.")
                            .normalerText()
                        Image("pic2")
                            .helpPictures()
                        Divider()
                        
                        Text("\nDaten und Datenexport")
                            .ueberschriftenTextBold()
                        Text("Alle Daten dieser App werden verschlüsselt in einer JSON Datei auf Ihrem Gerät gespeichert. In den Einstellungen haben sie jederzeit die Möglichkeit diese Daten auch als 'Klartext' zu exportieren. Nutzen Sie diese Möglichkeit um die Daten in regelmäßigen Abständen außerhalb des Gerätes zu sichern, z.B. in einem Datensafe oder auf einem gesicherten externen Speichermedium.")
                            .normalerText()
                        Image("pic4")
                            .helpPictures()
                        Text("In der aktuellen Version ist die Cloudspeicherung und synchronisation nicht aktiv. Dieses Feature wird ggf. in den weiteren Entwicklungen dieser App implementiert.")
                            .normalerText()
                        Divider()
                        
                        Text("\nHomeScreen")
                            .ueberschriftenTextBold()
                        Text("Auf dem Homescreen finden sie die obere Navigation zum Hilfebildschirm indem sie sich gerade befinden und zu den Einstellungen. Im mittleren Bereich haben sie die Möglichkeit Einträge nach Textinhalt über den Titel zu suchen oder die Sortierung der Einträge nach Titel oder nach zuletzt Aktualisiert zu wählen. Durch einen Klick auf die jeweiligen Einträge gelangen sie in den Vorschaubereich des einzelnen Eintrages, so sie auch die Möglichkeit zum Bearbeiten oder Löschen finden. Nutzen sie den 'grünen# Add Button um einen neuen Eintrag über den Homescreen zu erstellen.")
                            .normalerText()
                        Image("pic1")
                            .helpPictures()
                        Divider()
                        
                        Text("\nEinträge verwalten")
                            .ueberschriftenTextBold()
                        Text("Über die Seite 'Eintrag hinzufügen' haben sie die Möglichkeit neben den Standardfeldern auch eigene Felder hinzuzufügen, umso jeden Eintrag entsprechend individuell gestalten zu können. Nutzen die die QuickIcons um z.B. ein 12 stelliges Passwort nach dem Zufall zu erstellen oder um das eingegebene Passwort über eine externe API auf dessen Kompromitierungsstatus hin zu prüfen.")
                            .normalerText()
                        
                        Image("pic6")
                            .helpPictures()
                        Divider()
                        
                        Text("\nPasswort-Generator")
                            .ueberschriftenTextBold()
                        Text("Nutzen sie jederzeit den über die Toolbar erreichbaren Passwort-Generator. Der Passwort-Generator nutzt eine externe API und generiert auf Basis der zuvor eingestellten Parameter sichere passwörter. Gleichzeitig wird auch dieses Passwort einer Prüfung auf desses Kompromitierungsstatus durchgeführt.")
                            .normalerText()
                        Image("pic7")
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
