//
//  MainDisplayCollectionViewExtensions.swift
//  iHearChangesSwift
//
//  Created by Randy Weinstein on 6/30/17.
//  Copyright © 2017 fakeancient. All rights reserved.
//

import UIKit

// MARK: Collection View Delegates and Helper Methods

extension MainDisplay : UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    
    func initializeCollectionView() -> Void  {
        
        self.containerView.backgroundColor = UIColor.black
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    
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
        return UIEdgeInsets(top: 2.0, left: 2.0, bottom: 0.0, right: 0.0)
    }
}


