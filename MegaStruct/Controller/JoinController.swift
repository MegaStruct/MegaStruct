//
//  JoinController.swift
//  MegaStruct
//
//  Created by A Hyeon on 4/25/24.
//

import UIKit

class JoinController: UIViewController {
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        customTextField(_textField: userIdTextField)
//        customTextField(_textField: userPWDTextField)
        
    }
    func customTextField(_textField: UITextField) {
        //텍스트 필드 둥글게
        _textField.layer.cornerRadius = 25.0
        _textField.layer.masksToBounds = true
        
        //텍스트 필드 안에 패딩
        _textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        _textField.leftViewMode = .always
    }
}
