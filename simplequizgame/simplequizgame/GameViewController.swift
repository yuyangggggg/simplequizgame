//
//  GameViewController.swift
//  simplequizgame
//
//  Created by YY Tan on 2022-12-31.
//

import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var allQuestions = [Question]()
    var currentQuestion: Question?
    
    @IBOutlet var label: UILabel!
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        setupQuestions()
        configureUI(question: allQuestions.first!)
    }
    
    
    /*
     configures the UI by setting the label text, assigning currentQuestion to the question, and reloads the table to show the answers
     */
    private func configureUI(question: Question) {
        label.text = question.text
        currentQuestion = question
        table.reloadData()
    }
    
    /* Checks if the answer is the correct answer */
    private func checkAnswer(answer: Answer, question: Question) -> Bool {
        // question might not be necessary since answer has bool variable, just to be safe
        return question.answers.contains(where: { $0.text == answer.text }) && answer.correct
    }
    
    /* Creates questions, answers for each question, and appends to allQuestions array that stores all questions.*/
    private func setupQuestions() {
        allQuestions.append(Question(text: "How many bones are there in the human body?", answers: [
            Answer(text: "206", correct: true),
            Answer(text: "207", correct: false),
            Answer(text: "199", correct: false),
            Answer(text: "201", correct: false)
        
        ]))
        allQuestions.append(Question(text: "What is 3 x 3?", answers: [
            Answer(text: "8", correct: false),
            Answer(text: "23", correct: false),
            Answer(text: "9", correct: true),
            Answer(text: "44", correct: false)
        
        ]))
        allQuestions.append(Question(text: "Which of the following is a mammal?", answers: [
            Answer(text: "Shark", correct: false),
            Answer(text: "Python", correct: false),
            Answer(text: "Platypus", correct: true),
            Answer(text: "Acorn", correct: false)
        
        ]))
    }
    
    // tableview functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion?.answers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath )
        cell.textLabel?.text = currentQuestion?.answers[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let question = currentQuestion else {
            return
        }
        
        let answer = question.answers[indexPath.row]
        if (checkAnswer(answer: answer, question: question)) {
            // correct: move to next question or end the game if all questions have been answered
            if let index = allQuestions.firstIndex(where: {$0.text == question.text}) {
                if index < (allQuestions.count - 1) {
                    // next question
                    let nextQuestion = allQuestions[index + 1]
                    configureUI(question: nextQuestion)
                    table.reloadData()
                } else {
                    // end the game
                    let alert = UIAlertController(title: "Game completed", message: "Congratulations! You have completed the game :)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    present(alert, animated: true)
                }
            }
        }
        else {
            // wrong answer, alert player
            let alert = UIAlertController(title: "WRONG", message: "Wrong answer :(", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }

}

struct Question {
    var text: String
    var answers: [Answer]
}

struct Answer {
    var text: String
    var correct: Bool
}
