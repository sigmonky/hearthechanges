//
//  InfoViewController.swift
//  iHearChangesSwift
//
//  Created by Weinstein, Randy - Nick.com on 6/26/17.
//  Copyright © 2017 fakeancient. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var infoText:String = ""

    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textView.text = infoText
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func updateInfo() {
         //textView.text = infoText
        if let rtfPath = Bundle.main.url(forResource: infoText, withExtension: "rtf") {
            do {
                let attributedStringWithRtf = try NSAttributedString(url: rtfPath, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
                textView.attributedText = attributedStringWithRtf
            } catch {
                print("No rtf content found!")
            }
        }
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
