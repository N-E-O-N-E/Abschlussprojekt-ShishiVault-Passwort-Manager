//
//  API Repository.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 21.11.24.
//

import Foundation

final class APIRepository {
    
    func getPasswordHashes() {
        
        // Passwort entgegen nehmen
        // Passwort in einen Hash SHA-1 umwandeln
        
        // Die ersten 5 Zeichen an die URL hängen
        // GET https://api.pwnedpasswords.com/range/{first 5 hash chars}
        
        // Suffix mit Treffern wird zurückgegeben und muss iteriert werden
        
        // Es wird der komplette SHA1 String des passwortes auf ein Match geprüft.
        
        // Gibt es ein Treffer ist das Passwort kompromitiert
        
    }
    
    func getPassword(length: Int, lowerCase: Bool, upperCase: Bool, numbers: Bool, symbols: Bool) async throws -> APIData {
        let baseURL = "https://random-password-generator5.p.rapidapi.com/random-password/index.php"
        let length = "length=\(length)"
        let lowerCase = "lower_case=\(lowerCase)"
        let upperCase = "upper_case=\(upperCase)"
        let numbers = "numbers=\(numbers)"
        let symbols = "symbols=\(symbols)"
        
        let stringURL = "\(baseURL)?\(length)&\(lowerCase)&\(upperCase)&\(numbers)&\(symbols)"
        print("\(stringURL)")
        
        guard let url = URL(string: stringURL) else {
            throw APIError.invalidUrl
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.allHTTPHeaderFields = [
            "x-rapidapi-key": APIKey.apiKeyPWGen,
            "x-rapidapi-host": "random-password-generator5.p.rapidapi.com"
        ]
        
        let data = try await self.handleDataResponse(forRequest: urlRequest)

        let results = try JSONDecoder().decode(APIData.self, from: data)

        return results
    }
    
    private func handleDataResponse(forRequest request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        guard !data.isEmpty else {
            throw APIError.dataNotFound
        }

        return data
    }
    
    
}
