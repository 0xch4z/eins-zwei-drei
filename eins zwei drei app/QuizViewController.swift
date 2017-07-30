//
//  QuizViewController.swift
//  eins zwei drei app
//
//  Created by Charles Kenney on 7/29/17.
//  Copyright © 2017 Charles Kenney. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    static let placeholder = QuizQuestion(question: "default", answer: "default")
    
    var timerIsRunning = false
    var score = Int() {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    var seconds = Int() {
        didSet {
            timerLabel.text = "⏰ \(seconds)s"
        }
    }
    var timer = Timer()
    
    var currentQuestion = placeholder {
        didSet {
            questionLabel.text = "Translate \(currentQuestion.question) to German"
        }
    }
    var pendingQuestions = [QuizQuestion]()
    
    var numberCorrect = Int()
    var numberIncorrect = Int()

    @IBAction func checkAnswer(_ sender: UITextField) {
        
        if (currentQuestion.answerQuestion(sender.text!)) {
            
            // clear answer field
            sender.text = ""
            
            // increment score
            score += 1
            
            // get next question
            serveQuestion()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerField.becomeFirstResponder()

        // Reset stats
        seconds = 60
        numberCorrect = 0
        numberIncorrect = 0
        score = 0
        
        // load questions from json
        let jsonFile = Bundle.main.path(forResource: "Questions", ofType: "json")
        let jsonString = try? String(contentsOfFile: jsonFile!, encoding: String.Encoding.utf8)
        let json = jsonString?.data(using: String.Encoding.utf8)
        pendingQuestions = try! JSONDecoder().decode([QuizQuestion].self, from: json!)
        
        // Serve initial question
        serveQuestion()
        
        // Start initial timer
        startTimer()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(QuizViewController.updateTime)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        if (seconds == 0) {
            timer.invalidate()
            endGame()
        } else {
            seconds -= 1
            print("\(seconds) seconds remaining...")
        }
    }
    
    func endGame() {
        
        questionLabel.text = "Gameover!"
        print("game over")
        self.view.endEditing(true)
        answerField.isUserInteractionEnabled = false
    }
    
    func serveQuestion() {
        
        let rand = Int(arc4random_uniform(UInt32(pendingQuestions.count)))
        currentQuestion = pendingQuestions[rand]
        pendingQuestions.remove(at: rand)
        print("new question: \(currentQuestion.question); new answer: \(currentQuestion.answer)")
    }
}
