//
//  ViewController.swift
//  图片加载优化
//
//  Created by Mekor on 2017/11/7.
//  Copyright © 2017年 Citynight. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func click(_ sender: Any) {
        self.navigationController?.pushViewController(ListViewController(), animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

