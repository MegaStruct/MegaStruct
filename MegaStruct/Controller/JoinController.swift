//
//  JoinController.swift
//  MegaStruct
//
//  Created by A Hyeon on 4/25/24.
//

import UIKit

class JoinController: UIViewController {
    
    @IBOutlet weak var joinIdTextField: UITextField!
    
    @IBOutlet weak var joinPwdTextField: UITextField!
    
    @IBOutlet weak var joinPwdCheckTextField: UITextField!
    
    @IBOutlet weak var joinNicknameTextField: UITextField!
    
    @IBOutlet weak var joinUserNameTextField: UITextField!
    
    @IBOutlet weak var joinBirthDateTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTextField(_textField: joinIdTextField)
        customTextField(_textField: joinPwdTextField)
        customTextField(_textField: joinPwdCheckTextField)
        customTextField(_textField: joinNicknameTextField)
        customTextField(_textField: joinUserNameTextField)
        customTextField(_textField: joinBirthDateTextField)
        
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
