//
//  ViewControllerSwift.swift
//  ComponentSwitch
//
//  Created by Mike Woelmer on 8/27/15.
//  Copyright (c) 2015 atomicobject. All rights reserved.
//

import UIKit
import MIKMIDI

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

class MainDisplay: UIViewController, MIKMIDICommandScheduler {
 
//MARK: - Class Properties
    var progression:Progression?
    
    var loopRange:Int  = 0
    var loopStart = 0
    var newLoopStart = 0
    var newLoopRange = 0
    var loopResetRequested = false
    var lessonName:String?
    var sequenceTemplate:SequenceTemplate?
    var startup:Bool = true

    
    
    var currentLesson:String?
    
    var trackNumbers = [Int]()
    
    let synthesizer = MIKMIDISynthesizer()
    let sequence = MIKMIDISequence()
    let sequencer = MIKMIDISequencer()
    //var counter = 1
    var currentAppState = AppState (
        voiceStates:[false,true,true,true,true],
        loopSettings:[0.0,1.0]
    )
    
    
    var currentMeasure = -1
    var lastCurrentMeasure = -1
    var measureStates = [MeasureState]()
    var currentAnswer = ""
    var lastSelectedIndexPath:IndexPath?
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 0.0, right: 0.0)
    
    weak var currentViewController: UIViewController?
    
    var currentSelectedPane:UIButton?
    
    var selectedIndexPath: IndexPath?{
        didSet{
            if let _ = lastSelectedIndexPath {
                collectionView.reloadItems(at: [lastSelectedIndexPath!])
            }
            if let _ = selectedIndexPath {
                collectionView.reloadItems(at: [selectedIndexPath!])
            }
        }
    }
    
//MARK: - IB Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!


//MARK: - ViewController method overrides
    
    override func viewDidLoad() {
        
        self.navigationItem.rightBarButtonItem = nil;
        
        super.viewDidLoad()
        
        measureStates = [
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false),
            MeasureState(display:"?",rightAnswer:"IM",answerStatus:.unanswered,selected:false)
        ]

        
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
        
        if let _ = currentLesson {
            
            if let filepath = Bundle.main.path(forResource: currentLesson!, ofType: "json") {
                sequenceTemplate = SequenceTemplate()
                if let _ = sequenceTemplate?.load(filepath) {
                    
                        sequenceTemplate?.homeKey = 60
                        progression = sequenceTemplate?.generateProgression()
                        updateMeasureStates()
                    
                } else {
                    // example.txt not found!
                }
            }
            
        } else {
            print("couldn't load the lesson")
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.containerView.backgroundColor = UIColor.black
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.containerView.backgroundColor = UIColor.black

        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlaybackPane")
        (self.currentViewController as? PlaybackPane)!.sequenceLength = (progression?.chordProgression.count)!
        
        (self.currentViewController as? PlaybackPane)!.delegate = self
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        
        
        
        /*let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        */
                
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        sequencer.stop()
    }
    
    /*override var shouldAutorotate : Bool {
        
       let horizontalClass = self.traitCollection.horizontalSizeClass
       //let verticalCass = self.traitCollection.verticalSizeClass
        
        var allowAutoRotate = true
        
        if horizontalClass == UIUserInterfaceSizeClass.compact {
            allowAutoRotate = false
        }
        return allowAutoRotate
    }*/
    
// MARK: IB UI Action Handlers
    @IBAction func displayPlaybackPane(_ sender: UIButton) {
        
        manageButtonViewStatus(sender)
        
        updateControlPane("PlaybackPane")
        
        let thePlaybackPane = self.currentViewController as! (PlaybackPane)
        thePlaybackPane.sequenceLength = (progression?.chordProgression.count)!
        thePlaybackPane.setLoopSettings(appState: currentAppState)

        
        
        
    }
    
    @IBAction func displayMixPane(_ sender: UIButton ) {
        
        manageButtonViewStatus(sender)
        
       updateControlPane("MixPane")
        
       let theMixPane = self.currentViewController as! (MixPane)
        
       theMixPane.showVoices(voices: 5, appState: currentAppState)
        
    }
    
    @IBAction func displayAnswerPane(_ sender: UIButton) {
        
        manageButtonViewStatus(sender)
        
        updateControlPane("AnswerPane")
    }
  
    @IBAction func displayInfo(_ sender: Any) {
        
         updateControlPane("InfoView")
 
    }
    
//MARK: - Container View Methods
    
    func cycleFromViewController(_ oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
                newViewController.view.alpha = 1
                oldViewController.view.alpha = 0
            },
            completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMove(toParentViewController: self)
        })
    }

    func addSubview(_ subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)

        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func manageButtonViewStatus( _ buttonSelected:UIButton ) {
        
        if (currentSelectedPane) != nil {
            currentSelectedPane!.backgroundColor = UIColor.darkGray
            currentSelectedPane!.setTitleColor(UIColor.white, for: UIControlState())
        }
        
        if buttonSelected.backgroundColor == UIColor.yellow {
            buttonSelected.backgroundColor = UIColor.darkGray
            buttonSelected.setTitleColor(UIColor.white, for: UIControlState())
        } else {
            buttonSelected.backgroundColor = UIColor.yellow
            buttonSelected.setTitleColor(UIColor.blue, for: UIControlState())
        }
        
        currentSelectedPane = buttonSelected
        
        
    }
    
    func updateControlPane( _ storyBoardId:String ) {
        
        /*
        currentMeasure = (currentMeasure + 1)%progression!.chordProgression.count
        collectionView.reloadData()
        */
        
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: storyBoardId)
        
        if (storyBoardId == "AnswerPane") {
            (newViewController as? AnswerPane)!.delegate = self
        }
        
        if (storyBoardId == "MixPane") {
            (newViewController as? MixPane)!.delegate = self
            
        }
        
        if ( storyBoardId == "PlaybackPane") {
            (newViewController as? PlaybackPane)!.delegate = self
        }
        
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
        self.currentViewController = newViewController

        
    }


    
//MARK: Sequence Builders
    
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
            
            sequencer.setCommandScheduler(self, for: track)
            
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
                
                
                //let newNote = MIKMIDINoteEvent(timeStamp: 0.0,note:60,velocity:100,duration:4,channel:0)
                
                if forVoice < notesInChord.count {
                    if let midiNoteNumber:UInt8 = notesInChord[forVoice].uint8Value {
                        
                        let newNote = MIKMIDINoteEvent(timeStamp: beat,
                                                       note:midiNoteNumber,
                                                       velocity:100,
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
                    //try  trackSynth?.loadSoundfontFromFile(at: soundfont,presetID:presetID)
                    try  trackSynth?.loadSoundfontFromFile(at: soundfont)
                    trackNumber = sequence.tracks.count - 1
                } catch {
                    
                }
            }
            
            
        } catch {
            
        }
        
        return trackNumber
        
    }
    
    
    
//MARK: MIKMIDICommandScheduler Delegate Methods
    func scheduleMIDICommands(_ commands: [MIKMIDICommand]) {
        
        var reloadedCells:[IndexPath] = []
 
        if commands[0].commandType == MIKMIDICommandType.noteOn {
            
            // counter += 1
            print("sequencer time stamp \(sequencer.currentTimeStamp)")
            
            currentMeasure = (Int((round(sequencer.currentTimeStamp))/4.0)) % (loopRange/4)
            
            
            print("computed measure is \(currentMeasure)")
            
            if currentMeasure == 0 {
                currentMeasure += loopStart
            }
            
            DispatchQueue.main.async { [unowned self] in
                let highlightedMeasure = IndexPath(row:self.currentMeasure, section: 0)
                print("highlightedMeasure = \(highlightedMeasure)")
                
                if (highlightedMeasure.row < (self.progression?.chordProgression!.count)!) {
                    reloadedCells.append(highlightedMeasure)
                }
                
                var resetMeasure:IndexPath
                if self.lastCurrentMeasure >= 0 && (self.lastCurrentMeasure != self.currentMeasure) {
                   resetMeasure = IndexPath(row: self.lastCurrentMeasure, section:0)
                    if (resetMeasure.row < (self.progression?.chordProgression!.count)!) {
                        reloadedCells.append(resetMeasure)
                    }
                   
                }
                
                print("reloaded Cells = \(reloadedCells)")
                self.collectionView.reloadItems(at: reloadedCells)
                self.lastCurrentMeasure = self.currentMeasure
                
            }

            
        }
    }
}


//MARK:Function Pane Delegates


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

//MARK: - PlaybackPane
extension MainDisplay:PlaybackPaneDelegate {
    
    func playSequence() {
        
        currentMeasure = -1
        
        sequencer.stop()
        
        var midiTracks = [MIKMIDITrack]()
        
        collectionView.reloadData()
        
        if sequencer.sequence.tracks.count > 0 {
            for i in 0...sequencer.sequence.tracks.count - 1 {
                midiTracks.append(sequencer.sequence.tracks[i])
            }
            
            for i in 0...midiTracks.count - 1 {
                sequencer.sequence.removeTrack(midiTracks[i])
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
        loopRange = progression!.chordProgression.count * 4
        piano.performance = progression?.voicedChordProgression()
        
        
        
        bass.instrument = "bass"
        bass.midiInstrument = 32
        bass.performance = progression?.bassLine()
        
        renderProgressionToMidi(piano: piano, bass: bass)
        sequencer.startPlayback()

        
    }
    
    func setLoopStatus() {
        loopStart = newLoopStart
        loopRange = newLoopRange
        lastCurrentMeasure = currentMeasure
        currentMeasure = loopStart
        
        if loopRange == 0 {
            loopRange = 4
        }
        
        print("now looping from \(newLoopStart * 4) to \(loopRange)")
        sequencer.stop()
        var reloadedCells:[IndexPath] = []
        reloadedCells.append(IndexPath(row:self.currentMeasure, section: 0))
        sequencer.setLoopStartTimeStamp(MusicTimeStamp(loopStart * 4), endTimeStamp: MusicTimeStamp(loopRange))
        self.currentMeasure = -1

        self.collectionView.reloadItems(at: reloadedCells)
        loopResetRequested = false
        sequencer.startPlayback(atTimeStamp: MusicTimeStamp(loopStart * 4))

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
        
       newLoopRange =  (Int(Float(progression!.chordProgression.count ) * position) * 4)
        
        if newLoopRange == 0 {
            newLoopRange = 4
        }
        
        currentAppState.loopSettings[1] = position
        
        print("loopRange is \(newLoopRange)")
        
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
        let track = sequence.tracks[voiceToChange - 1]
        track.isMuted = !track.isMuted
    }
}

// MARK: Collection View Delegates
extension MainDisplay : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if progression != nil {
            return progression!.chordProgression.count 
        } else {
            return 0;
        }
        
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "measure", for: indexPath) as! MeasureCell
        var borderColor: CGColor! = UIColor.clear.cgColor
        var borderWidth: CGFloat = 0
        
        cell.chordId.text = measureStates[(indexPath as NSIndexPath).row].display
        
        var textColor:UIColor
        
        print(measureStates[(indexPath as NSIndexPath).row].answerStatus)
        
        switch measureStates[(indexPath as NSIndexPath).row].answerStatus {
            case .unanswered:
                textColor = UIColor.white
            case .correct:
                textColor = UIColor.green
            case.wrong:
                textColor = UIColor.red
            default:
                textColor = UIColor.white
        }
        
        cell.chordId.textColor = textColor

        if measureStates[(indexPath as NSIndexPath).row].selected == true {
                borderColor = UIColor.orange.cgColor
                borderWidth = 5
            
        } else {
            borderColor = UIColor.clear.cgColor
            borderWidth = 0
        }
        
        cell.image.layer.borderWidth = borderWidth
        cell.image.layer.borderColor = borderColor
        
        
        
        if (indexPath as NSIndexPath).row == currentMeasure {
            cell.image.backgroundColor = UIColor.yellow
             cell.chordId.textColor = UIColor.black
            
        } else {
            cell.image.backgroundColor = UIColor.black
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let lastPath = lastSelectedIndexPath {
             measureStates[lastPath.row].selected = false
            collectionView.reloadItems(at: [lastPath])
        }
        
        selectedIndexPath = indexPath
        measureStates[(selectedIndexPath?.row)!].selected = true

        collectionView.reloadItems(at: [selectedIndexPath!])
        
        lastSelectedIndexPath = indexPath
    }
    
    
    
}

extension MainDisplay : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width = Int(view.bounds.size.width/5.0)
        
        // each image has a ratio of 4:3
        let height = Int( Double(width) * 0.75 )
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
