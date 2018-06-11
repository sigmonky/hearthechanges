//
//  ViewController.swift
//  ZDT_InstaTutorial
//
//  Created by Sztanyi Szabolcs on 22/12/15.
//  Copyright © 2015 Zappdesigntemplates. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

    var collectionViewLayout: CustomImageFlowLayout!
    var x = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimer()

        collectionViewLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.backgroundColor = .black
    }
    
    func setTimer() {
        let _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.autoScroll), userInfo: nil, repeats: true)
    }
    
    @objc func autoScroll() {
        //self.pagecontrols.currentPage = x
        let indexPath = IndexPath(item: x, section: 0)
        print("\(self.x) -- \(indexPath)")
        //if self.x <= 10 {
        let isAnimated = (self.x == 0) ? false:true
        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: isAnimated)
        self.x = (self.x + 1) % 25
        print(self.x)
        //} else {
        //self.x = 1
        //self.scrollAuto.scrollToItem(at: IndexPath(item: 1, section: 0), at: .top, animated: false)
        //}
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell

        let imageName = (indexPath.row % 2 == 0) ? "image1" : "image2"

        cell.imageView.image = UIImage(named: imageName)

        return cell
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
