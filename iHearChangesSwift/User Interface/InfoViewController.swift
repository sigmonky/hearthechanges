//
//  InfoViewController.swift
//  iHearChangesSwift
//
//  Created by Weinstein, Randy - Nick.com on 6/26/17.
//  Copyright © 2017 fakeancient. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "     Moving between the tonic and the dominant is by far the most common harmonic progression and is heard in everything from innocent nursery rhymes to sophisticated Bach concertos. It is the bedrock of European fucntional harmony.\n\n     In this lesson the tonic is identified by the symbol I and the dominant is identified by the symbol V. Conventional understanding is that the V chord seeks resolution to the I chord. Confirm whether or not your ears agree with that!\n\n     There are only two chord choices in this lesson -- I Major and V Major. The conventional functional identify for the I Major is IM and the conventional functional identify for V Major is VM.\n\n     Touch a measure, select the Answer Pane by touching the answer button and use the controls on the Answer Pane to select either IM or VM. Then press Select at the bottom of the Answer Pane to see if you identified the chord in the selected measure correctly."

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
