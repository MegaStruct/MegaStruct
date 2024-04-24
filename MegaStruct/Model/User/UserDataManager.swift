//
//  UserDataManager.swift
//  MegaStruct
//
//  Created by A Hyeon on 4/24/24.
//

import Foundation

// MARK: - properties
final class UserModel {
    struct User {
        var userId: String
        var userPWD: String
    }
    
    var model: [User] = [
        User (userId: "ahyeon", userPWD: "1234"),
        User (userId: "jeongho", userPWD: "5678"),
        User (userId: "jiyeon", userPWD: "91011"),
        User (userId: "hanbit", userPWD: "12131415")
    ]
    
    // MARK: - methods
    
    //이미 있는 유저인지 확인
    func hasUser (name: String, pwd: String) -> Bool {
        for user in model {
            if user.userId == name && user.userPWD == pwd {
                return true
                
            }
        }
        return false
    }
    
    //새로운 유저 추기
    func addUser(name: String, pwd: String) {
        let newUser = User(userId: name, userPWD: pwd)
        model.append(newUser)
    }
    
}
