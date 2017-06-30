//
//  MainDisplaySupporPaneExtensions.swift
//  iHearChangesSwift
//
//  Created by Randy Weinstein on 6/30/17.
//  Copyright © 2017 fakeancient. All rights reserved.
//

import UIKit
import MIKMIDI

//MARK: - PlaybackPane
extension MainDisplay:PlaybackPaneDelegate {
    
    func playSequence() {
        
        currentMeasure = -1
        
        midiManager.sequencer.stop()
        
        initializeMeasureStates()
        updateMeasureStates()
        
        collectionView.reloadData()
        
        let piano = Player()
        let bass = Player()
        
        if ( !startup ) {
            progression = sequenceTemplate?.generateProgression()
            updateMeasureStates()
            if (currentViewController is PlaybackPane) {
                
                let playbackPanel = self.currentViewController as?PlaybackPane
                playbackPanel!.setSequenceLength(newLength: (progression?.chordProgression.count)!)
            }
        } else {
            startup = false
        }
        
        collectionView.reloadData()
        
        piano.instrument = "piano"
        piano.midiInstrument = 13
        midiManager.loopRange = progression!.chordProgression.count * 4
        piano.performance = progression?.voicedChordProgression()
        
        
        
        bass.instrument = "bass"
        bass.midiInstrument = 32
        bass.performance = progression?.bassLine()
        
        midiManager.renderProgressionToMidi(piano: piano, bass: bass)
        midiManager.sequencer.setCommandScheduler(self, for: midiManager.sequence.tracks[5])
        
        midiManager.sequencer.startPlayback()
        
        
    }
    
    func setLoopStatus() {
        
        loopStart = newLoopStart
        midiManager.loopRange = midiManager.newLoopRange
        lastCurrentMeasure = currentMeasure
        currentMeasure = loopStart
        
        if midiManager.loopRange == 0 {
            midiManager.loopRange = 4
        }
        
        //print("now looping from \(newLoopStart * 4) to \(loopRange)")
        midiManager.sequencer.stop()
        var reloadedCells:[IndexPath] = []
        reloadedCells.append(IndexPath(row:self.currentMeasure, section: 0))
        midiManager.sequencer.setLoopStartTimeStamp(MusicTimeStamp(loopStart * 4), endTimeStamp: MusicTimeStamp(midiManager.loopRange))
        self.currentMeasure = -1
        
        self.collectionView.reloadItems(at: reloadedCells)
        loopResetRequested = false
        midiManager.sequencer.startPlayback(atTimeStamp: MusicTimeStamp(loopStart * 4))
        
    }
    
    func setStartLoop(loopPosition position:Float) {
        
        var startLoop = position
        
        if ( startLoop  > currentAppState.loopSettings[1]) {
            startLoop = currentAppState.loopSettings[1]
        }
        currentAppState.loopSettings[0] = startLoop
        
        newLoopStart =  Int(Float(progression!.chordProgression.count ) * startLoop)
        if newLoopStart >= progression!.chordProgression.count {
            newLoopStart = progression!.chordProgression.count - 1
        }
        
        print("new loop start is \(newLoopStart)")
        
    }
    
    func setEndLoop(loopPosition position:Float) {
        
        var endLoop = position
        
        if ( endLoop  > currentAppState.loopSettings[1]) {
            endLoop = currentAppState.loopSettings[1]
        }
        
        midiManager.newLoopRange =  (Int(Float(progression!.chordProgression.count ) * endLoop) * 4)
        
        if midiManager.newLoopRange == 0 {
            midiManager.newLoopRange = 4
        }
        
        currentAppState.loopSettings[1] = endLoop
        
        print("loopRange is \(midiManager.newLoopRange)")
        
    }
    
    func updateMeasureStates() {
        
        for measure in 0..<progression!.chordProgression.count {
            
            if let currentChord = progression?.chordProgression[measure] as? Chord {
                measureStates[measure].rightAnswer = currentChord.chordSymbol()
                print("\(measureStates[measure].rightAnswer) \(currentChord.chordSymbol())")
            }
            
        }
        
    }
}


//MARK: MixPane
extension MainDisplay: MixPaneDelegate {
    func muteUnmuteVoice(_ sender:MixPane, voiceToChange:Int, voiceState:Bool) {
        print("mute/unmute voice \(voiceToChange) -- \(voiceState)")
        currentAppState.voiceStates[voiceToChange - 1] = voiceState
        let track = midiManager.sequence.tracks[voiceToChange - 1]
        track.isMuted = !track.isMuted
    }
}

//MARK: AnswerPane
extension MainDisplay: AnswerPaneDelegate {
    func didProvideAnswer(_ sender:AnswerPane) {
        currentAnswer = sender.theAnswer
        measureStates[selectedIndexPath!.row].display = currentAnswer
        
        if (measureStates[selectedIndexPath!.row].rightAnswer == currentAnswer) {
            measureStates[selectedIndexPath!.row].answerStatus = .correct
        } else {
            measureStates[selectedIndexPath!.row].answerStatus = .wrong
        }
        collectionView.reloadItems(at: [selectedIndexPath!])
    }
}


