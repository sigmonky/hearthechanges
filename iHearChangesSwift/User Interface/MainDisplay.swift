
import UIKit
import MIKMIDI



class MainDisplay: UIViewController, MIKMIDICommandScheduler {
 
//MARK: - Class Properties
    var progression:Progression?

    var loopStart = 0
    var newLoopStart = 0
   
    var loopResetRequested = false
    var lessonName:String?
    var sequenceTemplate:SequenceTemplate?
    var startup:Bool = true
    var lessonInstructions:String = "No instructions available"

    
    
    var currentLesson:String?
    
    let midiManager = MidiManager()

    var currentAppState = AppState (
        voiceStates:[false,true,true,true,true],
        loopSettings:[0.0,1.0]
    )
    
    
    var currentMeasure = -1
    var lastCurrentMeasure = -1
    var measureStates = [MeasureState]()
    var currentAnswer = ""
    var lastSelectedIndexPath:IndexPath?
    
    weak var currentViewController: UIViewController?
    
    var currentSelectedPane:UIButton?
    
    var selectedIndexPath: IndexPath?{
        didSet{
            if let lastSelectedCell = lastSelectedIndexPath {
                collectionView.reloadItems(at: [lastSelectedCell])
            }
            if let currentSelectedCell = selectedIndexPath {
                collectionView.reloadItems(at: [currentSelectedCell])
            }
        }
    }
    
//MARK: - IB Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!


//MARK: - ViewController method overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
         self.navigationItem.rightBarButtonItem = nil;
        
        initializeMeasureStates()
        
        initializeSequence()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeCollectionView()
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
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        midiManager.sequencer.stop()
    }
    
    
// MARK: IB UI Action Handlers
    @IBAction func displayPlaybackPane(_ sender: UIButton) {
        
        manageButtonViewStatus(sender)
        
        updateControlPane("PlaybackPane")
        
        let thePlaybackPane = self.currentViewController as! (PlaybackPane)
        thePlaybackPane.sequenceLength = (progression?.chordProgression.count)!
        thePlaybackPane.playButtonTitle = "New Sequence"
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
  
    @IBAction func displayInfo(_ sender: UIButton) {
        
        manageButtonViewStatus(sender)
        
        updateControlPane("InfoView")
        
        let theInfoPane = self.currentViewController as! (InfoViewController)
        
        theInfoPane.infoText = self.lessonInstructions
        
        theInfoPane.updateInfo()
 
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


//MARK: MIKMIDICommandScheduler Delegate Methods
    func scheduleMIDICommands(_ commands: [MIKMIDICommand]) {
        
        var reloadedCells:[IndexPath] = []
 
        if commands[0].commandType == MIKMIDICommandType.noteOn {
            
            // counter += 1
            print("sequencer time stamp \(midiManager.sequencer.currentTimeStamp)")
            
            currentMeasure = (Int((round(midiManager.sequencer.currentTimeStamp))/4.0)) % (midiManager.loopRange/4)
            
            
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

extension MainDisplay {
    // MARK: Initialization Helper Methods
    
    func initializeSequence() -> Void {
        if let _ = currentLesson {
            
            if let filepath = Bundle.main.path(forResource: currentLesson!, ofType: "json") {
                sequenceTemplate = SequenceTemplate()
                if let _ = sequenceTemplate?.load(filepath) {
                    
                    sequenceTemplate?.homeKey = 60
                    progression = sequenceTemplate?.generateProgression()
                    lessonInstructions = (sequenceTemplate?.instructions)!
                    updateMeasureStates()
                    
                } else {
                    // example.txt not found!
                }
            }
            
        } else {
            print("couldn't load the lesson")
        }

    }
}


