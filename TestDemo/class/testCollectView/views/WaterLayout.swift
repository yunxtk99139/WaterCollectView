//
//  WaterLayout.swift
//  TestDemo
//
//  Created by zhuyun on 16/2/4.
//  Copyright © 2016年 codera. All rights reserved.
//

import UIKit
typealias HeightBlock = (NSIndexPath,CGFloat)->CGFloat
class WaterLayout: UICollectionViewLayout {
    var lineNumber:Int = 0
    var  rowSpacing:CGFloat = 0
    var lineSpacing:CGFloat = 0
    var sectionInset:UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    var dicOfHeight:Dictionary<CGFloat,CGFloat> = Dictionary()
    var array:Array<UICollectionViewLayoutAttributes> = Array()
    override init() {
        super.init()
        self.lineNumber = 2
        self.rowSpacing = 10.0
        self.lineSpacing = 10.0
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }
     var block:HeightBlock?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareLayout() {
        super.prepareLayout()
        let count = self.collectionView?.numberOfItemsInSection(0)
        for  i in 0...lineNumber {
            dicOfHeight.updateValue(self.sectionInset.top, forKey: CGFloat(i))
        }
        var idx:Int = 0;
        for idx=0;idx<count;++idx{
          let indexPath:NSIndexPath = NSIndexPath.init(forRow: idx, inSection: 0)
          array.append(self.layoutAttributesForItemAtIndexPath(indexPath)!)
        }
    }
    override func collectionViewContentSize() -> CGSize {
        var maxHeightline:CGFloat = 0;
        for (key,value) in dicOfHeight{
            if dicOfHeight[maxHeightline] < value{
                maxHeightline = key
            }
        }
        return CGSizeMake(self.collectionView!.bounds.size.width, dicOfHeight[maxHeightline]! + self.sectionInset.bottom)
    }
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attr:UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWithIndexPath: indexPath)
        let itemW:CGFloat  = (self.collectionView!.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) - CGFloat(self.lineNumber - 1) * self.lineSpacing) / CGFloat(self.lineNumber);
        var itemH:CGFloat = 0
        if((self.block) != nil){
           itemH = self.block!(indexPath,itemW)
        }
        var frame:CGRect = CGRect()
        frame.size = CGSizeMake(itemW, itemH)
        var minHeightline:CGFloat = 0;
        for (key,value) in dicOfHeight{
            if dicOfHeight[minHeightline] > value{
                minHeightline = key
            }
        }
        frame.origin = CGPointMake(self.sectionInset.left + minHeightline * (itemW + self.lineSpacing), dicOfHeight[minHeightline]!)
        dicOfHeight[minHeightline] = frame.size.height + self.rowSpacing + dicOfHeight[minHeightline]!
         attr.frame = frame
        return attr
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.array
    }
    func computeIndexCellHeightWithWidthBlock(block:HeightBlock){
            self.block = block;
    }
}
