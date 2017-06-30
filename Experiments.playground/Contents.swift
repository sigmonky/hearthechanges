//: Playground - noun: a place where people can play

import UIKit

let MIDIC = 60

extension Bool: IntValue {
    func intValue() -> Int {
        if self {
            return 1
        }
        return 0
    }
}

protocol IntValue {
    func intValue() -> Int
}


func getChord(input:Array<Int>, offset:Int = 0,flat:Bool = false)->[String] {
    
    return input.map({ (value:Int) -> String in
        
        let chordIdentity = [["I"],["#I","b2"],["II"],["#2","bIII"],["III"],["IV"],["#IV","bV"],["V"],["#V","bVI"],["VI"],["#VI","bVII"],["VII"]]
        
        var adjustedOffset = (value + offset) % 12
        
        if adjustedOffset < 0 {
            adjustedOffset = 12 + adjustedOffset
        }
        
        var currentSolfege:String = ""
        if adjustedOffset >= 0 && adjustedOffset < chordIdentity.count {
            if chordIdentity[adjustedOffset].count > 1 {
               currentSolfege =  chordIdentity[adjustedOffset][0 + flat.intValue()]
            } else {
                currentSolfege =  chordIdentity[adjustedOffset][0]
            }
        }
        
        return currentSolfege
    })
    
}

getChord(input: [0,4,7],offset:0)


enum ColorName: String {
    case black, silver, gray, white, maroon, red, purple, fuchsia, green, lime, olive, yellow, navy, blue, teal, aqua
}


let x:String = ColorName.teal.rawValue

enum ChordQuality {
    case Major
    case Minor
    case Diminished
    case Augmented
    case Dominant
    case Suspended
    
    func members() -> [Int] {
        var returnArray:[Int] = [0]
        switch theChord {
        case .Major:
            returnArray += [4,7]
        case .Minor:
            returnArray += [3,7]
        case .Diminished:
            returnArray +=  [3,6]
        case .Augmented:
            returnArray += [4,8]
        case .Dominant:
            returnArray += [4,7,10]
        case.Suspended:
            returnArray += [5,7]
        }
        
        return returnArray
        
        
    }
}





var theChord = ChordQuality.Dominant
let offset = 63
let transpose = {$0 + offset}
let renderedChord = theChord.members().map(transpose)
print(renderedChord)

/* do {
 try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
 print("AVAudioSession Category Playback OK")
 do {
 try AVAudioSession.sharedInstance().setActive(true)
 print("AVAudioSession is Active")
 } catch let error as NSError {
 print(error.localizedDescription)
 }
 } catch let error as NSError {
 print(error.localizedDescription)
 }*/


