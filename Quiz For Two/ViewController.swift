//
//  ViewController.swift
//  Quiz For Two
//
//  Created by Bartek Bugajski on 10/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

import UIKit

struct Answer {
    let title: String
    let isCorrect: Bool
}

class ViewController: UIViewController {
    
    var service = Service.shared
    var questions = [Question]()
    var activeAnswers = [Answer]()
    var defaultBackgroundColor: UIColor?
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    @IBOutlet weak var nextQuestion: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchQuestions()
    }
    
    func configureUI(){
        self.defaultBackgroundColor = btnD.backgroundColor
        for item in [btnA, btnB, btnC, btnD] {
            item?.isEnabled = false
        }
        nextQuestion.isEnabled = false
    }
    
    func resetButtonTags(){
        btnA.tag = 0
        btnB.tag = 0
        btnC.tag = 0
        btnD.tag = 0
        for item in [btnA, btnB, btnC, btnD] {
            item?.backgroundColor = self.defaultBackgroundColor
        }
    }
    
    func enableButtons(){
        for item in [btnA, btnB, btnC, btnD] {
            item?.isEnabled = true
        }
    }
    
    func fetchQuestions() {
        service.fetchQuestions { (result) in
            DispatchQueue.main.async {
                self.enableButtons()
            }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                self.questions = response.results
                self.assignAnswers()
            }
        }
    }
    
    func assignAnswers(){
        if !self.questions.isEmpty {
            if let last = questions.popLast() {
                var answers = [Answer]()
                
                // Adding answers
                answers.append(Answer(title: last.correct_answer, isCorrect: true))
                for item in last.incorrect_answers {
                    answers.append(Answer(title: item, isCorrect: false))
                }
                // Shuffle the array
                answers.shuffle()
                self.activeAnswers = answers
                
                DispatchQueue.main.async {
                    self.nextQuestion.isEnabled = true
                    self.resetButtonTags()
                    
                    self.questionLabel.text = last.question
                    // Make sure the index is not out of range
                    self.btnA.setTitle(answers[0].title, for: .normal)
                    if answers[0].isCorrect { self.btnA.tag = 1 }
                    self.btnB.setTitle(answers[1].title, for: .normal)
                    if answers[1].isCorrect { self.btnB.tag = 1 }
                    self.btnC.setTitle(answers[2].title, for: .normal)
                    if answers[2].isCorrect { self.btnC.tag = 1 }
                    self.btnD.setTitle(answers[3].title, for: .normal)
                    if answers[3].isCorrect { self.btnD.tag = 1 }
                    
                }
            }
        }else{
            DispatchQueue.main.async {
                self.nextQuestion.isEnabled = false
            }
        }
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            sender.backgroundColor = .green
        }else{
            sender.backgroundColor = .red
        }
    }
    
    @IBAction func showNext(_ sender: UIButton) {
        assignAnswers()
    }
}

