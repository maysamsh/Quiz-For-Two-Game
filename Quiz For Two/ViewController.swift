//
//  ViewController.swift
//  Quiz For Two
//
//  Created by Bartek Bugajski on 10/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var service = Service.shared
    var questions = [Question]()
    
    var counter = 0
//    var questionResults = [Question]()
//    var questionResult: Question! {
//        didSet {
//            questionLabel.text = questionResult.question
//
//            }
//        }
//
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var btnA: UIButton!
    
    @IBOutlet weak var btnB: UIButton!
    
    @IBOutlet weak var btnC: UIButton!
    
    @IBOutlet weak var btnD: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       fetchQuestions()
       
    }
    
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
//
                        let questionResults = questionResult.results
                      print(questionResults)
   
                        DispatchQueue.main.async {
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

