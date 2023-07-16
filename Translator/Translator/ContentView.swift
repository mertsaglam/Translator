import SwiftUI

struct ContentView: View {
    @State private var inputWord = ""
    @State private var sourceLanguage = "English"
    @State private var targetLanguage = "Spanish"
    @State private var translatedWord = ""
    @State private var responseText = ""
    
    @State private var languages = [String]()
    
    var body: some View {
        VStack {
            TextField("Enter a word", text: $inputWord)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Text("Source Language:")
                Picker("Source Language", selection: $sourceLanguage) {
                    ForEach(languages, id: \.self) { language in
                        Text(language)
                    }
                }
            }
            .padding()
            
            HStack {
                Text("Target Language:")
                Picker("Target Language", selection: $targetLanguage) {
                    ForEach(languages, id: \.self) { language in
                        Text(language)
                    }
                }
            }
            .padding()
            
            Button(action: {
                translate()
            }) {
                Text("Translate")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text("Translation: \(translatedWord)")
                .font(.title)
                .padding()
            
            Spacer()
        }
        .onAppear {
            fetchSupportedLanguages()
        }
    }
    
    func fetchSupportedLanguages() {
        TranslationManager.shared.fetchSupportedLanguages { success in
            if success {
                DispatchQueue.main.async {
                    languages = TranslationManager.shared.supportedLanguages.compactMap { $0.name }
                }
            } else {
                print("Failed to fetch supported languages")
            }
        }
    }
    
    func translate() {
        TranslationManager.shared.textToTranslate = inputWord
        if let sourceLanguage = TranslationManager.shared.supportedLanguages.first(where: { $0.name == sourceLanguage }) {
                TranslationManager.shared.sourceLanguageCode = sourceLanguage.code
            } else {
                print("Invalid source language selection")
                return
            }
        if let targetLanguage = TranslationManager.shared.supportedLanguages.first(where: { $0.name == targetLanguage }) {
                TranslationManager.shared.targetLanguageCode = targetLanguage.code
            } else {
                print("Invalid target language selection")
                return
            }
        
        TranslationManager.shared.translate { translations in
            if let translations = translations {
                if let translation = translations.first {
                    print(translation)
                    DispatchQueue.main.async {
                        translatedWord = translations
                    }
                }
            } else {
                print("Translation failed")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
