//
//  AppStatusModels.swift
//  iHearChangesSwift
//
//  Created by Randy Weinstein on 6/30/17.
//  Copyright © 2017 fakeancient. All rights reserved.
//

import Foundation

//MARK: model classes
struct AppState {
    var voiceStates:[Bool]
    var loopSettings:[Float]
}

enum AnswerState {
    case unanswered
    case wrong
    case correct
    
}

struct MeasureState {
    var display:String
    var rightAnswer:String
    var answerStatus:AnswerState
    var selected:Bool
}
