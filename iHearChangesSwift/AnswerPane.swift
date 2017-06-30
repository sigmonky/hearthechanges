//
//  ComponentA.swift
//  ComponentSwitch
//
//  Created by Weinstein, Randy - Nick.com on 8/18/16.
//  Copyright © 2016 atomicobject. All rights reserved.
//

import UIKit

protocol AnswerPaneDelegate: class {
    func didProvideAnswer(_ sender:AnswerPane)
}

class AnswerPane: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chordQualityTable: UITableView!
    @IBOutlet weak var accidentalButton: UIButton!
    
    weak var delegate:AnswerPaneDelegate?
    
   
    var theAnswer:String = ""
    var theAccidental:String = ""
    
    var items: [String] = [
        "M","m","7","dim", "aug",
        "M6", "M7","M9","M11","M13",
        "m6","m7","7","7b9","7#9","7sus","7#11",
        "dim7",
        "m7b5"
    ]
    
    let selectedCellBGColor = UIColor.yellow
    let selectedCellTextColor = UIColor.blue
    
    let notSelectedCellBGColor = UIColor.black
    let notSelectedCellTextColor = UIColor.white
    
    var currentSelectedRoot:UIButton?
    
   
    @IBAction func selectAnswer(_ sender: AnyObject) {
        
        theAnswer = theAccidental + theAnswer
        delegate?.didProvideAnswer(self)
        
        theAccidental = ""
        accidentalButton.backgroundColor = UIColor.black
        accidentalButton.setTitleColor(UIColor.white, for: UIControlState())

        if let rootButton = currentSelectedRoot {
            rootButton.backgroundColor = UIColor.black
            rootButton.setTitleColor(UIColor.white, for: UIControlState())
        }
        
        chordQualityTable.reloadData()
        
    }
    
    @IBAction func selectRoot(_ sender: UIButton) {
        
        theAnswer = ""
        
        if (currentSelectedRoot) != nil {
            currentSelectedRoot!.backgroundColor = UIColor.black
            currentSelectedRoot!.setTitleColor(UIColor.white, for: UIControlState())
        }
        
        if sender.backgroundColor == UIColor.yellow {
            sender.backgroundColor = UIColor.black
            sender.setTitleColor(UIColor.white, for: UIControlState())
        } else {
            sender.backgroundColor = UIColor.yellow
            sender.setTitleColor(UIColor.blue, for: UIControlState())
           
        }
        
        currentSelectedRoot = sender
        theAnswer = (currentSelectedRoot!.titleLabel?.text)!
    }
    
    
    
    @IBAction func selectAccidental(_ sender: UIButton) {
       
        if sender.backgroundColor == UIColor.yellow {
            sender.backgroundColor = UIColor.black
            sender.setTitleColor(UIColor.white, for: UIControlState())
            theAccidental = ""
        } else {
            sender.backgroundColor = UIColor.yellow
            sender.setTitleColor(UIColor.blue, for: UIControlState())
            theAccidental = "b"
            
        }
        
    }
  

    @IBOutlet weak var chordTypes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chordTypes.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        chordTypes.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

 
    //MARK: - TableViewDelegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (cell.isSelected)
        {
            cell.backgroundColor = selectedCellBGColor
            cell.textLabel!.textColor = selectedCellTextColor
        }
        else
        {
           cell.backgroundColor = notSelectedCellBGColor
           cell.textLabel!.textColor = notSelectedCellTextColor
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.chordTypes.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = self.items[(indexPath as NSIndexPath).row]
        cell.textLabel?.textColor = UIColor.white
        
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if let currentSelectedIndexPath = tableView.indexPathForSelectedRow {
            if let selectedCell = tableView.cellForRow(at: currentSelectedIndexPath) {
                selectedCell.backgroundColor = notSelectedCellBGColor
                selectedCell.textLabel?.textColor = notSelectedCellTextColor
                
            }
            
        }
        
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.backgroundColor = selectedCellBGColor
        cell!.textLabel?.textColor = selectedCellTextColor
        theAnswer = theAnswer + (cell!.textLabel?.text)!
        
    }

}
