//
//  ImageCell.swift
//  TestDemo
//
//  Created by zhuyun on 16/2/4.
//  Copyright © 2016年 codera. All rights reserved.
//

import UIKit
class ImageCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.brownColor()
        self.contentView.addSubview(bgView)
        bgView.layer.shadowColor = UIColor.blackColor().CGColor
        bgView.layer.shadowOpacity = 0.5
        bgView.layer.shadowOffset = CGSizeMake(2,4)
        bgView.layer.shadowRadius = 2;

        bgView.addSubview(imageView)
        imageView.layer.cornerRadius = 4;
        imageView.layer.masksToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleToFill;
    }
    func showImage(imagename:String){
        imageView.sd_setImageWithURL(NSURL.init(string: imagename), placeholderImage:nil)
    }
    override func didMoveToSuperview(){
        let rect:CGRect = CGRectMake(0, 0, (UIScreen.mainScreen().bounds.size.width-30)/2, self.contentView.frame.size.height)
        bgView.frame = rect;
        imageView.frame = rect;
    }
}
