//
//  ListViewController.swift
//  图片加载优化
//
//  Created by Mekor on 2017/11/8.
//  Copyright © 2017年 Citynight. All rights reserved.
//

import UIKit
import CoreFoundation

class ListViewController: UIViewController {

    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        view.addSubview(tableView)
        RunLoopWorker.shared.maxQueueLength = 100
    }
    
    deinit {
        print("走了")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        RunLoopWorker.shared.add(task: { () -> Bool in
            self.addImage1(with: cell)
            return true
        }, with: indexPath)
        
        RunLoopWorker.shared.add(task: { () -> Bool in
            self.addImage2(with: cell)
            return true
        }, with: indexPath)
        
        RunLoopWorker.shared.add(task: { () -> Bool in
            self.addImage3(with: cell)
            return true
        }, with: indexPath)
        return cell
    }
    
    
    private func addImage1(with cell:TableViewCell) {
        guard let path = Bundle.main.path(forResource: "spaceship", ofType: "png") else {return}
        guard let image = UIImage(contentsOfFile: path) else {return}
        UIView.animate(withDuration: 0.25) {
            cell.imageView1.image = image
        }
    }
    private func addImage2(with cell:TableViewCell) {
        guard let path = Bundle.main.path(forResource: "spaceship", ofType: "png") else {return}
        let image = UIImage(contentsOfFile: path)
        UIView.animate(withDuration: 0.25) {
            cell.imageView2.image = image
        }
    }
    private func addImage3(with cell:TableViewCell) {
        guard let path = Bundle.main.path(forResource: "spaceship", ofType: "png") else {return}
        let image = UIImage(contentsOfFile: path)
        UIView.animate(withDuration: 0.25) {
            cell.imageView3.image = image
        }
    }
}
