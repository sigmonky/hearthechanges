//
//  ViewController.swift
//  Project1
//
//  Created by TwoStraws on 11/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit


//
// MARK: - Section Data Structure
//
struct Section {
    var name: String!
    var items: [Item]!
    var collapsed: Bool!
    
    init(name: String, items: [Item], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

struct Item {
    var name:String!
    var lesson:String!
    
    init(name:String,lesson:String) {
        self.name = name
        self.lesson = lesson
    }
}

class MainMenuViewController: UITableViewController {
    var sections = [Section]()
	//var pictures = [String]()
    var lastCollpased:Bool = true

	override func viewDidLoad() {
		super.viewDidLoad()
 
		title = "Hear The Changes"
        
        // Initialize the sections array
        // Here we have three sections: Mac, iPad, iPhone
        
        let basic1 = [Item(name:"Tonic and Dominant 1",lesson:"I-V-1"),
                      Item(name:"Tonic and Dominant 2",lesson:"I-V-2"),
                      Item(name:"Tonic and Dominant 3",lesson:"I-V-3"),
                      Item(name:"Tonic and Dominant 4",lesson:"I-V-4"),
                      Item(name:"Tonic and Subdominant 1",lesson:"I-IV-1"),
                      Item(name:"Tonic and Subdominant 2",lesson:"I-IV-2"),
                      Item(name:"Tonic and Subdominant 3",lesson:"I-IV-3"),
                      Item(name:"Tonic and Subdominant 4",lesson:"I-IV-4"),
                      Item(name:"Tonic,Doinant, and Subdominant",lesson:"I-IV-V-1")]
        
        let intermed1 = [
                        Item(name:"Tonic and Dominant",lesson:"I-V-1subs"),
                        Item(name:"Tonic and Subdominant",lesson:"I-IV-1subs"),
                        Item(name:"Tonic,Dominant, and Subdominant",lesson:"I-IV-V-1subs"),
                        Item(name:"Tonic,Dominant, and Subdominant",lesson:"I-IV-V-1subs"),
                        Item(name:"Secondary Dominants 1",lesson:"secondaryDominants1"),
                        Item(name:"Secondary Dominants 2",lesson:"secondaryDominants2"),
                        Item(name:"Secondary Dominants 3",lesson:"secondaryDominants3"),
                        Item(name:"Secondary Dominants 4",lesson:"secondaryDominants4"),
                        Item(name:"Cadences 1",lesson:"cadences1"),
                        Item(name:"Cadences 2",lesson:"cadences2"),
                        Item(name:"Cadences 3",lesson:"cadences3"),
                        Item(name:"Key Modulations 1",lesson:"keymodulations-1"),
                        Item(name:"Key Modulations 2",lesson:"keymodulations-2"),
                        Item(name:"Key Modulations 3",lesson:"keymodulations-3"),
                        Item(name:"Key Modulations 4",lesson:"keymodulations-4")
                      ]
        
        
        let intermed2 = [
            Item(name:"No More Cane",lesson:"nomorecane"),
            Item(name:"minor folk song",lesson:"minorfolk")
        ]
        
        let advanced1 = [Item(name:"A Train",lesson:"atrain"),
                         Item(name:"Afternooon In Paris",lesson:"afternooninparis"),
                         Item(name:"Ain't Misbehavin'",lesson:"aintmisbehavin"),
                         Item(name:"Alice In Wonderland",lesson:"aliceinwonderland"),
                         Item(name:"All Of Me",lesson:"allofme"),
                         Item(name:"All The Things You Are",lesson:"allthethingsyouare"),
                         Item(name:"Angel Eyes",lesson:"angeleyes")
                         ]
        
        sections = [
            Section(name: "Basics 1: Major Key", items:basic1, collapsed: true),
            Section(name: "Intermediate 1: Major Key", items:intermed1, collapsed: true),
            Section(name: "Intermediate 2: Folk Songs with Substitutions", items:intermed2, collapsed: true),
            Section(name: "Advanced 1: Jazz Standards", items:advanced1, collapsed: true)
        ]

	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		cell.textLabel?.text = sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row].name
        return cell
	}
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[(indexPath as NSIndexPath).section].collapsed! ? 0.0 : 44.0
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "MainDisplay") as? MainDisplay {
			//vc.selectedImage = pictures[indexPath.row]
            vc.currentLesson = sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row].lesson
            
            vc.navigationItem.title = sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row].name

            let backItem = UIBarButtonItem()
            backItem.title = "Menu"
            navigationItem.backBarButtonItem = backItem
                       
			navigationController?.pushViewController(vc, animated: true)
            
            
		}
	}
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sheader") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "sheader")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

//
// MARK: - Section Header Delegate
//
extension MainMenuViewController: CollapsibleTableViewHeaderDelegate {
    
    
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {

            let collapsed = !sections[section].collapsed
            
            // Toggle collapse
            sections[section].collapsed = collapsed
            header.setCollapsed(collapsed)
            
            // Adjust the height of the rows inside the section
            tableView.beginUpdates()
            for i in 0 ..< sections[section].items.count {
                tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            }
            tableView.endUpdates()
    }


    
}

