//
//  ImageScanCtl.swift
//  TestDemo
//
//  Created by zhuyun on 16/2/4.
//  Copyright © 2016年 codera. All rights reserved.
//

import UIKit

class ImageScanCtl: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    var images:[String] = []
    var heights:[CGFloat] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageModel:ImageModel = ImageModel.init()
        images = imageModel.images
        let flowLayout:WaterLayout = WaterLayout.init();
        var block: HeightBlock?
         block = {
            (indexPath:NSIndexPath,_)->CGFloat in
            let height = Float((self.view.frame.width-36)/2)+Float((indexPath.row%5)*30)
            return CGFloat(height)
        }
        flowLayout.computeIndexCellHeightWithWidthBlock(block!)
        let collectView: UICollectionView! = UICollectionView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), collectionViewLayout: flowLayout)
        self.view.addSubview(collectView)
        collectView.backgroundColor = UIColor.whiteColor()
        collectView.delegate = self
        collectView.dataSource = self
        collectView.registerNib(UINib.init(nibName:"ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let icell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
        icell.showImage(images[indexPath.row])
//        let imageView:UIImageView = UIImageView();
//         imageView.sd_setImageWithURL(NSURL.init(string: images[indexPath.row]), placeholderImage:nil)
//        icell.backgroundView = imageView;
        return icell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.images.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
}
