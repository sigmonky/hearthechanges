//
//  MidiGenerator.swift
//  iHearChangesSwift
//
//  Created by Randy Weinstein on 6/30/17.
//  Copyright © 2017 fakeancient. All rights reserved.
//

import Foundation
import MIKMIDI
import AVFoundation

class MidiManager {
    
    var loopRange:Int  = 0
    var newLoopRange = 0
    var trackNumbers = [Int]()
    
    let synthesizer = MIKMIDISynthesizer()
    var sequence = MIKMIDISequence()
    var sequencer = MIKMIDISequencer()
    
    

    func renderProgressionToMidi(piano:Player, bass:Player) {
        
        for aChord in piano.performance  {
            let firstChord = (aChord as! NSArray) as Array
            let beat = firstChord[0]
            let notesInChord = (firstChord[1] as! NSArray) as Array
            let duration = firstChord[2]
            print("starting beat for chord \(beat)")
            print("chord notes \(notesInChord)")
            print("chord duration \(duration)")
            
            
        }
        
        
        for aChord in bass.performance  {
            let firstChord = (aChord as! NSArray) as Array
            let beat = firstChord[0]
            let notesInChord = (firstChord[1] as! NSArray) as Array
            let duration = firstChord[2]
            print(beat)
            print(notesInChord)
            print(duration)
            
            
        }
        
        
        sequencer.tempo = 120.0
        let endTimeStamp = Float(bass.performance.count) * 4.0
        loopRange = bass.performance.count * 4
        newLoopRange = loopRange
        sequencer.setLoopStartTimeStamp(0.0, endTimeStamp: MusicTimeStamp(endTimeStamp))
        sequencer.shouldLoop = true
       
        for track in sequence.tracks {
            sequence.removeTrack(track)
        }
        
        sequencer.sequence = sequence
        
        
        buildMidiTrack(forVoice: 0, withInstrument: 18,thePerformer:bass)
        buildMidiTrack(forVoice: 0, withInstrument: 18,thePerformer:piano)
        buildMidiTrack(forVoice: 1, withInstrument: 32,thePerformer:piano)
        buildMidiTrack(forVoice: 2, withInstrument: 70,thePerformer:piano)
        buildMidiTrack(forVoice: 3, withInstrument: 70,thePerformer:piano)
        
        sequence.tracks[0].isMuted = true
        
        if let trackNumber = addTrackWithSoundFont("rhodes_73", presetID: 0) , trackNumber > -1
        {
            let track = sequence.tracks[trackNumber]
            var timeStamp = 0.0
            for _ in 0..<bass.performance.count {
                let note = MIKMIDINoteEvent(timeStamp: timeStamp,note:0,velocity:0,duration:4.0,channel:0)
                track.addEvents([note])
                timeStamp += 4.0
            }
            
          
            
        }
    }
    
    
    func buildMidiTrack(forVoice:Int, withInstrument:Int, thePerformer:Player) {
        
        if let trackNumber = addTrackWithSoundFont("rhodes_73", presetID: UInt8(withInstrument) ) , trackNumber > -1
        {
            
            trackNumbers.append(trackNumber)
            let track = sequence.tracks[trackNumber]
            
            for aChord in thePerformer.performance  {
                
                let firstChord = (aChord as! NSArray) as Array
                let beat = firstChord[0] as! MusicTimeStamp
                let notesInChord = (firstChord[1] as! NSArray) as Array
                let duration = firstChord[2] as! Float32
                
                if forVoice < notesInChord.count {
                    if let midiNoteNumber:UInt8 = notesInChord[forVoice].uint8Value {
                        
                        let newNote = MIKMIDINoteEvent(timeStamp: beat,
                                                       note:midiNoteNumber,
                                                       velocity:127,
                                                       duration:duration,
                                                       channel:0)
                        
                        track.addEvents([newNote])
                        
                    }
                }
            }
        }
    }
    
    
    func addTrackWithSoundFont(_ soundFontFile:String, presetID:UInt8)-> Int? {
        
        var trackNumber:Int? = -1
        
        do {
            let _ = try sequence.addTrack()
            
            let track = sequence.tracks[sequence.tracks.count - 1]
            
            let trackSynth = sequencer.builtinSynthesizer(for: track)
            
            if let soundfont = Bundle.main.url(forResource: soundFontFile, withExtension: "sf2") {
                do {
                    try  trackSynth?.loadSoundfontFromFile(at: soundfont)
                    trackNumber = sequence.tracks.count - 1
                } catch {
                    
                }
            }
            
            
        } catch {
            
        }
        
        return trackNumber
    }
    
}


