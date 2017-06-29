//
//  PlaybackPane.swift
//  ComponentSwitch
//
//  Created by Weinstein, Randy - Nick.com on 9/6/16.
//  Copyright © 2016 atomicobject. All rights reserved.
//

import UIKit



protocol PlaybackPaneDelegate: class {
    func playSequence()
    func setLoopStatus()
    func setStartLoop(loopPosition:Float)
    func setEndLoop(loopPosition:Float)
    
}

class PlaybackPane: UIViewController {
    
    weak var delegate:PlaybackPaneDelegate?
    var startLoopSetting:Int = 0
    var currentIncrement = 0
    var loopStart = 0
    var loopEnd = 0
    var sequenceLength = 0

    //@IBOutlet weak var increaseStartLoop: UIButton!
    
    
    
    @IBOutlet weak var loopFromMeasure: UILabel!
    @IBOutlet weak var loopToMeasure: UILabel!
    
    @IBOutlet weak var loopFromSlider: UISlider!
    @IBOutlet weak var loopToSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loopFromMeasure.text = "1"
        loopToMeasure.text = String(sequenceLength)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loopStart(_ sender: Any) {
        print( (sender as! UISlider).value)
        
        if (loopFromSlider.value > loopToSlider.value) {
            loopFromSlider.value = loopToSlider.value
        }
        
        var calculatedMeasure = Int(loopFromSlider.value * Float(sequenceLength)) + 1
        
        if calculatedMeasure > sequenceLength {
            calculatedMeasure -= 1
        }
       
        loopFromMeasure.text = String(calculatedMeasure)
        delegate?.setStartLoop(loopPosition: (sender as! UISlider).value)
        
    }
    
    @IBAction func loopEnd(_ sender: Any) {
        print( (sender as! UISlider).value)
        
        if (loopToSlider.value < loopFromSlider.value) {
            loopToSlider.value = loopFromSlider.value
        }
        
        var calculatedMeasure = Int(loopToSlider.value * Float(sequenceLength))
        
        if calculatedMeasure > sequenceLength {
            calculatedMeasure -= 1
        }
        
        loopToMeasure.text = String(calculatedMeasure)
        
        delegate?.setEndLoop(loopPosition: (sender as! UISlider).value)
    }
    @IBAction func playSequence(_ sender: Any) {
        delegate?.playSequence()
    }
    
    @IBAction func setLoop(_ sender: Any) {
        delegate?.setLoopStatus()
    }
    
    func setSequenceLength(newLength:Int) {
        sequenceLength = newLength
        loopFromMeasure.text = "1"
        loopToMeasure.text = String(sequenceLength)
        
    }
    
    func setLoopSettings(appState:AppState) {
        
        loopFromSlider.value = appState.loopSettings[0]
        loopToSlider.value = appState.loopSettings[1]
        loopFromMeasure.text = String(Int(appState.loopSettings[0] * Float(sequenceLength)) + 1)
        loopToMeasure.text = String(Int(appState.loopSettings[1] * Float(sequenceLength)))
    }
    

}
