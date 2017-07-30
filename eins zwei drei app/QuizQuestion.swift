//
//  QuizQuestion.swift
//  eins zwei drei
//
//  Created by Charles Kenney on 7/29/17.
//  Copyright © 2017 Charles Kenney. All rights reserved.
//

import Foundation

public struct QuizQuestion: Decodable {
    
    public let question: String
    public let answer: String
    private var validator: String {
        
        let characters = Array(answer.characters).map{String($0)}
        var pattern = String()
        
        for char in characters {
            switch (char) {
            case " ":
                pattern += "[\\s-_]"
                break
            case "ü":
                pattern += "[uü]"
                break
            case "ö":
                pattern += "[oö]"
                break
            case "ß":
                pattern += "(ss|ß)"
                break
            default:
                pattern += char
                break
            }
        }
        return pattern
    }
    
    public init(question: String, answer: String) {
        
        self.question = question
        self.answer = answer
    }
    
    public func answerQuestion(_ answer: String) -> Bool {
        
        return answer.range(of: validator, options: [.regularExpression, .caseInsensitive, .anchored]) != nil
    }
}
