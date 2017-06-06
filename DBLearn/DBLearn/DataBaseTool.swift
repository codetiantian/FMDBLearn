//
//  DataBaseTool.swift
//  DBLearn
//
//  Created by 这个夏天有点冷 on 2017/6/5.
//  Copyright © 2017年 YLT. All rights reserved.
//

import UIKit

class DataBaseTool: NSObject {

    static let shared : DataBaseTool = DataBaseTool.init()
    
    var pathToDataBase : String!
    
    var dataBase : FMDatabase!
    
    override init() {
        super.init()
        
        //  初始化数据库路径
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        pathToDataBase = documentDirectory.appending("dataBase.sqlite")
        
        createTable()
        myDBRemoval()
    }
}

extension DataBaseTool {
    //  创建数据库
    func createTable() {
        dataBase = FMDatabase.init(path: pathToDataBase)
        
        if dataBase.open() {
            print("创建数据库成功")
            
            let createUserMessageSQL = "create table if not exists UserMessageTab(userID text primary key, userName text, age int);"
            do {
                try dataBase.executeUpdate(createUserMessageSQL, values: nil)
                print("创建用户信息表成功")
            } catch {
                print("用户信息表创建失败")
            }
            
        }
    }
    
    //  插入数据
    func saveUserMessageModel(userMessageModel : UserMessageModel) {
        if dataBase.open() {
            
            guard userMessageModel.ID.characters.count > 0 else {
                return
            }
            
            let model = UserMessageModel.init(ID: "0", userName: "0", age: 0, sex: 0)
            var rs:FMResultSet!
            
            do {
                rs = try dataBase.executeQuery("SELECT * FROM UserMessageTab", values: nil)
                
                while rs.next() {
                    model.ID = rs.string(forColumn: "userID")!
                }
                
                if Int(model.ID)! > 0 {
                    //  当前插入数据已存在
                    print("当前插入数据已存在")
                    dataBase.close()
                    return
                }
                
                let isOK = dataBase.executeUpdate("insert into UserMessageTab(userID, userName, age, sex) values (?, ?, ?, ?)", withArgumentsIn: [userMessageModel.ID, userMessageModel.userName, userMessageModel.age, userMessageModel.sex])
                if isOK {
                    print("插入数据成功")
                } else {
                    print("插入数据失败")
                }
                
                dataBase.close()
                
            } catch {
                
            }
        }
    }
    
    func selectUserMessage() -> UserMessageModel {
        let model = UserMessageModel.init(ID: "0", userName: "0", age: 0, sex: 0)
        
        if dataBase.open() {
            var rs : FMResultSet!
            
            do {
                rs = try dataBase.executeQuery("SELECT * FROM UserMessageTab", values: nil)
                
                while rs.next() {
                    model.ID = rs.string(forColumn: "userID")!
                    model.userName = rs.string(forColumn: "userName")!
                    model.age = Int(rs.int(forColumn: "age"))
                    model.sex = Int(rs.int(forColumn: "sex"))
                }
                
                dataBase.close()
            } catch {
                
            }
        }
        
        return model
    }
    
    //  MARK: - 删除全部数据
    func deleteUserMessage() {
        if dataBase.open() {
            let isOK = dataBase.executeUpdate("DELETE FROM UserMessageTab", withArgumentsIn: [])
        
            if isOK {
                print("删除数据成功")
            } else {
                print("删除数据失败")
            }
            
            dataBase.close()
        }
    }
    
    //  MARK: - 数据库迁移
    func myDBRemoval() {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let stringPath  = documentDirectory.appending("dataBase.sqlite")
        
        let manage = FMDBMigrationManager.init(databaseAtPath: stringPath, migrationsBundle: Bundle.main)!
        
        let migration1 = Migration.init(name: "UserMessageTab表新增字段sex", andVersion: manage.currentVersion + 1, andExecuteUpdate: ["alter table UserMessageTab add sex int"])
        manage.addMigration(migration1!)
        
        if !manage.hasMigrationsTable {
            do {
                try manage.createMigrationsTable()
            } catch {
                print("创建迁移表失败")
            }
        }

        do {
            try manage.migrateDatabase(toVersion: UINT64_MAX, progress: nil)
        } catch {
            print("升级失败")
        }
    }
}
