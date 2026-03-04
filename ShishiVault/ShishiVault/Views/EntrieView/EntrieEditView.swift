import SwiftUI

struct EntrieEditView: View {
    // MARK: - Environments
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - ViewModels
    @EnvironmentObject var entrieViewModel: EntriesViewModel
    @EnvironmentObject var shishiViewModel: ShishiViewModel
    
    // MARK: - State: Alerts & Sheets
    @State private var savedAlert: Bool = false
    @State private var isEmptyFieldsAlert: Bool = false
    @State private var isEmptyOptFieldsAlert: Bool = false
    @State private var isDeleteAlert: Bool = false
    @State private var customFieldSheet: Bool = false
    @State private var pwGeneratorSheet: Bool = false
    @State private var pwnedAlert: Bool = false
    @State private var passwordPwnedState: Int = 0
    
    // MARK: - Bindings & Properties
    @Binding var entrieEditView: Bool
    var entry: EntryData?
    
    // MARK: - State: Entry Data
    @State private var title: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var notes: String = ""
    @State private var website: String = ""
    @State private var customFields: [CustomField] = []
    
    var body: some View {
        ScrollView {
            VStack {
                // MARK: - Section: Basic Information
                Group {
                    TextField(title, text: $title)
                        .customTextField()
                    headerLabel("Bezeichnung")
                    
                    TextField(username, text: $username)
                        .customTextField()
                    headerLabel("Benutzername")
                    
                    TextField(email, text: $email)
                        .customTextField()
                    headerLabel("E-Mail Adresse")
                    
                    TextField(website, text: $website)
                        .customTextField()
                    headerLabel("Website")
                    
                    TextEditor(text: $notes)
                        .customTextFieldNotes()
                    headerLabel("Notizen")
                }
                
                Divider().padding(.vertical, 10)
                
                // MARK: - Section: Password & Security
                securitySection
                
                Divider().padding(.vertical, 10)
                
                // MARK: - Section: Custom Fields
                customFieldsSection
                
                Spacer()
                
                // MARK: - Action: Update Button
                updateButton
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .toolbar { toolbarContent }
        .sheet(isPresented: $customFieldSheet) { customFieldSheetContent }
        .sheet(isPresented: $pwGeneratorSheet) { passwordGeneratorSheetContent }
        .alert("Hinweis", isPresented: $savedAlert, actions: { alertActions }, message: { alertMessage })
        .onAppear { setupView() }
        .onChange(of: customFieldSheet) { _, isPresented in handleCustomFieldSheetChange(isPresented) }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Bearbeiten")
        .foregroundStyle(Color.ShishiColorBlue)
    }
}

// MARK: - View Components
private extension EntrieEditView {
    
    func headerLabel(_ text: String) -> some View {
        HStack {
            Text(text)
                .customTextFieldTextLow()
            Spacer()
        }
    }
    
    var securitySection: some View {
        VStack {
            PWLevelColorView(password: $password)
                .padding(.vertical, 20)
            
            HStack {
                TextField(password, text: $password)
                    .customPasswordField()
                    .onTapGesture { passwordPwnedState = 0 }
                
                pwnedCheckButton
                passwordRotationButton
            }
            headerLabel("Passwort vergeben")
        }
    }
    
    var pwnedCheckButton: some View {
        Button(action: {
            Task {
                do {
                    passwordPwnedState = try await APIhaveibeenpwned().checkPasswordPwned(password: password)
                    if passwordPwnedState == 1 { pwnedAlert = true }
                } catch { /* TODO: Connection? */ }
            }
        }) {
            securityIcon.foregroundColor(securityIconColor)
                .scaleEffect(1.4)
                .padding(.horizontal, 15)
        }
        .frame(width: 20).padding(.horizontal, 10)
    }
    
    var securityIcon: Image {
        Image(systemName: "shield.lefthalf.filled.badge.checkmark")
    }
    
    var securityIconColor: Color {
        switch passwordPwnedState {
        case 1: return .ShishiColorRed_
        case 2: return .ShishiColorGreen
        default: return .ShishiColorGray
        }
    }
    
    var passwordRotationButton: some View {
        Button(action: {
            Task {
                password = CryptHelper.shared.randomPasswordMaker()
                do {
                    passwordPwnedState = try await APIhaveibeenpwned().checkPasswordPwned(password: password)
                    if passwordPwnedState == 1 { pwnedAlert = true }
                } catch { /* TODO: Connection? */ }
            }
        }) {
            Image(systemName: "lock.rotation")
                .foregroundColor(.ShishiColorBlue).scaleEffect(1.4)
        }
        .frame(width: 20).padding(.horizontal, 10)
    }
    
    var customFieldsSection: some View {
        ForEach($customFields, id: \.id) { $customField in
            VStack {
                HStack {
                    TextField(customField.name, text: $customField.value)
                        .customTextField()
                    Button {
                        customFields.removeAll(where: { $0.id == customField.id })
                    } label: {
                        Image(systemName: "x.circle")
                            .foregroundStyle(Color.ShishiColorRed).scaleEffect(1.2)
                    }
                }
                headerLabel(customField.name)
            }
        }
    }
    
    var updateButton: some View {
        Button {
            handleUpdateAction()
        } label: {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.ShishiColorRed).frame(height: 50).padding().foregroundColor(.white)
                .overlay(
                    Text("Aktualisieren")
                        .font(.title3).bold().foregroundColor(.white))
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { dismiss() } label: {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("Zurück")
                }.foregroundColor(.ShishiColorBlue)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            HStack {
                Button { customFieldSheet = true } label: {
                    Image(systemName: "rectangle.badge.plus").foregroundStyle(Color.ShishiColorBlue)
                }
                Button { pwGeneratorSheet.toggle() } label: {
                    Image(systemName: "lock.square").foregroundColor(.ShishiColorBlue).scaleEffect(1.1)
                }
            }
        }
    }
}

// MARK: - Logic & Actions
private extension EntrieEditView {
    
    func setupView() {
        print("CustomField Daten wurden zurückgesetzt")
        entrieViewModel.deleteCustomField()
        
        if let entriesLoaded = entry {
            self.title = entriesLoaded.title
            self.username = entriesLoaded.username ?? ""
            self.email = entriesLoaded.email
            self.password = entriesLoaded.password
            self.notes = entriesLoaded.notes ?? ""
            self.website = entriesLoaded.website ?? ""
            self.customFields = entriesLoaded.customFields
        }
    }
    
    func handleUpdateAction() {
        switch entrieViewModel.entrieUpdateButtomnCheck(title: title, username: username, email: email, password: password) {
        case "mindestLeer": isEmptyFieldsAlert.toggle()
        case "wahlLeer": isEmptyOptFieldsAlert.toggle()
        case "ok":
            Task {
                do {
                    passwordPwnedState = try await APIhaveibeenpwned().checkPasswordPwned(password: password)
                    if passwordPwnedState == 2 {
                        if let _ = shishiViewModel.loginKey, let entryID = entry?.id {
                            await entrieViewModel.updateEntry(
                                id: entryID,
                                title: title,
                                username: username,
                                email: email,
                                password: password,
                                notes: notes,
                                website: website,
                                customFields: customFields
                            )
                            savedAlert.toggle()
                        }
                    } else if passwordPwnedState == 1 {
                        pwnedAlert = true
                    }
                } catch { /* TODO: Connection? */ }
            }
        default: break
        }
    }
    
    func handleCustomFieldSheetChange(_ isPresented: Bool) {
        if !isPresented {
            customFields.append(contentsOf: entrieViewModel.customFieldsForEntrie)
            entrieViewModel.deleteCustomField()
        }
    }
    
    var alertActions: some View {
        Group {
            Button("Aktualisieren", role: .destructive) {
                // Hinweis: Die eigentliche updateEntry Logik wird nun im Button oben via savedAlert.toggle() vorbereitet.
                // In deinem ursprünglichen Code war hier redundanter Save-Code.
                entrieViewModel.deleteCustomField()
                dismiss()
            }
            Button("Abbrechen", role: .cancel) {}
        }
    }
    
    var alertMessage: some View {
        Text("Die Aktualisierung der Daten kann nicht rückgängig gemacht werden!. Möchten Sie die Daten wirklich aktualisieren?")
    }
    
    var customFieldSheetContent: some View {
        CustomFieldAddView(customFieldSheet: $customFieldSheet)
            .environmentObject(entrieViewModel)
    }
    
    var passwordGeneratorSheetContent: some View {
        PWGeneratorView(customFieldSheet: $customFieldSheet)
            .environmentObject(entrieViewModel)
    }
}
