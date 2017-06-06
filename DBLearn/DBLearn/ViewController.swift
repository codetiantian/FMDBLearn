//
//  ViewController.swift
//  DBLearn
//
//  Created by 这个夏天有点冷 on 2017/6/5.
//  Copyright © 2017年 YLT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var db : DataBaseTool?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        learnFMDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  MARK: - 增加
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let userMessageModel = UserMessageModel.init(ID: "1", userName: "崔", age: 18, sex: 1)
        self.db?.saveUserMessageModel(userMessageModel: userMessageModel)
    }
    
    //  MARK: - 查找
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        let userMessageModel = self.db?.selectUserMessage()
        
        if Int((userMessageModel?.ID)!)! == 0 {
            print("当前数据库为空")
        } else {
            print(userMessageModel?.ID ?? "", userMessageModel?.userName ?? "", userMessageModel?.age ?? "", userMessageModel?.sex ?? "")
        }
    }

    //  MARK: - 删除
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        self.db?.deleteUserMessage()
    }
}

extension ViewController {
    
    func learnFMDB() {
        let db = DataBaseTool.init()
        self.db = db
    }
}
