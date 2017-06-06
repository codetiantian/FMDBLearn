//
//  UserMessageModel.swift
//  DBLearn
//
//  Created by 这个夏天有点冷 on 2017/6/5.
//  Copyright © 2017年 YLT. All rights reserved.
//

import UIKit

class UserMessageModel: NSObject {
    var ID : String = ""
    var userName : String = ""
    var age : Int = 0
    var sex :Int = 0
    
    
    init(ID : String, userName : String, age : Int, sex : Int) {
        self.ID = ID
        self.userName = userName
        self.age = age
        self.sex = sex
        
        super.init()
    }
}
