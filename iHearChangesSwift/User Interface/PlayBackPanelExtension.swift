//
//  PlayBackPanelExtension.swift
//  iHearChangesSwift
//
//  Created by Randy Weinstein on 6/30/17.
//  Copyright © 2017 fakeancient. All rights reserved.
//

import UIKit

//MARK: - PlaybackPane
extension MainDisplay:PlaybackPaneDelegate {
    
    func playSequence() {
        
        currentMeasure = -1
        
        midiManager.sequencer.stop()
        
        var midiTracks = [MIKMIDITrack]()
        
        initializeMeasureStates()
        updateMeasureStates()
        
        collectionView.reloadData()
        
        if midiManager.sequencer.sequence.tracks.count > 0 {
            for i in 0...midiManager.sequencer.sequence.tracks.count - 1 {
                midiTracks.append(midiManager.sequencer.sequence.tracks[i])
            }
            
            for i in 0...midiTracks.count - 1 {
                midiManager.sequencer.sequence.removeTrack(midiTracks[i])
            }
            
            
        }
        
        let piano = Player()
        let bass = Player()
        
        if !startup {
            progression = sequenceTemplate?.generateProgression()
            updateMeasureStates()
            if (currentViewController is PlaybackPane) {
                (self.currentViewController as? PlaybackPane)!.setSequenceLength(newLength: (progression?.chordProgression.count)!)
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
        
        //loopResetRequested = true
    }
    
    func setStartLoop(loopPosition position:Float) {
        
        
        newLoopStart =  Int(Float(progression!.chordProgression.count ) * position)
        if newLoopStart >= progression!.chordProgression.count {
            newLoopStart = progression!.chordProgression.count - 1
        }
        
        currentAppState.loopSettings[0] = position
        print("new loop start is \(newLoopStart)")
        
    }
    
    func setEndLoop(loopPosition position:Float) {
        
        midiManager.newLoopRange =  (Int(Float(progression!.chordProgression.count ) * position) * 4)
        
        if midiManager.newLoopRange == 0 {
            midiManager.newLoopRange = 4
        }
        
        currentAppState.loopSettings[1] = position
        
        print("loopRange is \(midiManager.newLoopRange)")
        
}

