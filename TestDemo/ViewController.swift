//
//  ViewController.swift
//  TestDemo
//
//  Created by zhuyun on 16/2/3.
//  Copyright © 2016年 codera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let encryptmodel:EnCryptTool = EnCryptTool()
        let Timestamp:String = "123456"
        let value:String = "abcd"
        let result:String? = encryptmodel.EncryptMsg(value, timeStmap: Timestamp)
        //encryptmodel.EncryptMsg(value,timeStmap:Timestamp)
        print("result \(result!)")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

