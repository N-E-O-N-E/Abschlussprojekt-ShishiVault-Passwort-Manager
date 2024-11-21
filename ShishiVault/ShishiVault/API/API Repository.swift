//
//  API Repository.swift
//  ShishiVault
//
//  Created by Markus Wirtz on 21.11.24.
//

import Foundation

func makeURLForRequest(lenght: Int, lowerCase: Bool, upperCase: Bool, numbers: Bool, symbols: Bool) -> String {
    let urlMain = "https://random-password-generator5.p.rapidapi.com/random-password/index.php"
    let length = "lenght\(lenght)"
    let lowerCase = "lower_case\(lowerCase)"
    let upperCase = "upper_case\(upperCase)"
    let numbers = "numbers\(numbers)"
    let symbols = "symbols\(symbols)"
    
    let url = "\(urlMain)?\(length)&\(lowerCase)&\(upperCase)&\(numbers)&\(symbols)"
    return url
}

func APIRequest(bakedURL: String) async throws -> APIData {
    guard let url = URL(string: bakedURL) else {
        throw APIError.invalidUrl
    }
    
    let headers = [
        "x-rapidapi-key": "b66eeaaea8msha9deb190fad247ap1b7fe9jsnd8d053a90485",
        "x-rapidapi-host": "random-password-generator5.p.rapidapi.com"
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
   
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(APIData.self, from: data)
}
