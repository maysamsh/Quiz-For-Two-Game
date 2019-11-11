//
//  Service.swift
//  SuperheroMoviesQuiz
//
//  Created by Bartek Bugajski on 10/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

import Foundation

class Service {
    static let shared = Service() //singleton
    var questionResults = [Question]()
    func fetchQuestions (handler: @escaping (Swift.Result<QuestionResult, Error>) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple"
        guard let url = URL(string: urlString) else {
            handler(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let jsonErr = err {
                handler(.failure(jsonErr))
                return
            }
            
            guard let data = data else {
                handler(.failure(NetworkError.invalidResponse))
                return
                
            }
            
            do {
                let questionResult = try JSONDecoder().decode(QuestionResult.self, from: data)
                
                handler(.success(questionResult))
                
                
            } catch let error {
                handler(.failure(error))
            }
            
        }.resume()
        
    }
}

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The requested URL is invalid.", comment: "")
        case .invalidResponse:
            return NSLocalizedString("URL components are invalid or malformed.", comment: "")
        }
    }
}



