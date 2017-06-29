//
//  MixPane.swift
//  ComponentSwitch
//
//  Created by Weinstein, Randy - Nick.com on 9/9/16.
//  Copyright © 2016 atomicobject. All rights reserved.
//

import UIKit

protocol MixPaneDelegate: class {
    func muteUnmuteVoice(_ sender:MixPane, voiceToChange:Int, voiceState:Bool)
}

class MixPane: UIViewController {
    
    weak var delegate:MixPaneDelegate?
    
    enum voiceState {
        case voiceOn
        case voiceOff
    }
   
    var voiceStates = [Bool]()

    @IBOutlet weak var voice1Btn: UIButton!
    @IBOutlet weak var voice2Btn: UIButton!
    @IBOutlet weak var voice3Btn: UIButton!
    @IBOutlet weak var voice4Btn: UIButton!
    @IBOutlet weak var voice5Btn: UIButton!
    
    @IBAction func muteOrUnmuteVoice(_ sender: UIButton) {
        print(sender.tag)
        
        var isSounding:Bool
        if voiceStates[sender.tag - 1] {
            isSounding = false
            voiceStates[sender.tag - 1] = false
           sender.setTitle("Voice \(sender.tag) muted", for: UIControlState.normal)
        } else {
            isSounding = true
            voiceStates[sender.tag - 1] = true
            sender.setTitle("Voice \(sender.tag)", for: UIControlState.normal)
        }
        delegate?.muteUnmuteVoice(self,voiceToChange:sender.tag,voiceState:isSounding)
    }
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showVoices(voices:Int,appState:AppState) {
        
        voiceStates = appState.voiceStates
        
        for i in 0..<5{
            if let button = self.view.viewWithTag(i+1) as? UIButton
            {
                button.isHidden = true
            }
        }
        
        for i in 0..<voices{
            if let button = self.view.viewWithTag(i+1) as? UIButton
            {
                
                var theCurrenTitle:String
                
                if (voiceStates[i]) {
                    theCurrenTitle = "Voice \(i+1)"
                } else {
                    theCurrenTitle = "Voice \(i+1) muted"
                }
               
                button.setTitle(theCurrenTitle, for: UIControlState.normal)
                button.isHidden = false
            }
        }
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
