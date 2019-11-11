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
    func fetchQuestions() {
                let urlString = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple"
                guard let url = URL(string: urlString) else { return }
                
                //fetch data from internet
                URLSession.shared.dataTask(with: url) { (data, resp, err) in
                    if let jsonErr = err {
                        print("Failed to fetch questions:", jsonErr)
    //                    completion([], jsonErr)
                        return
                    }
                    
        //            //success
        //            print(data)
        //            print(String(data: data!, encoding: .utf8))
                    
                    guard let data = data else { return }
                    
                    do {
                         let questionResult = try JSONDecoder().decode(QuestionResult.self, from: data)
                       
                        questionResult.results.forEach({
                            print($0.question, $0.correct_answer, $0.incorrect_answers)
                        })
                        
                        self.questionResults = questionResult.results
                        
                        DispatchQueue.main.async {
                            
                         //    self.collectionView.reloadData()
                                                                        }
    //                    completion(questionResult.results, nil)
                        
    //                    DispatchQueue.main.async {
    //                        self.collectionView.reloadData()
    //                    }
                        
                    } catch let jsonErr {
                        print("Failed to decode json:", jsonErr)
    //                    completion([], jsonErr)
                    }
          
                }.resume() //fires off the request
                
            }
}
