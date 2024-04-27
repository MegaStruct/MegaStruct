//
//  JoinController.swift
//  MegaStruct
//
//  Created by A Hyeon on 4/25/24.
//

import UIKit
import CoreData

final class JoinController: UIViewController {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    @IBOutlet weak var joinIdTextField: UITextField!
    @IBOutlet weak var joinPwdTextField: UITextField!
    @IBOutlet weak var joinPwdCheckTextField: UITextField!
    @IBOutlet weak var joinNicknameTextField: UITextField!
    @IBOutlet weak var joinUserNameTextField: UITextField!
    @IBOutlet weak var joinBirthDateTextField: UITextField!
    @IBOutlet weak var JoinBtn: UIButton!
    @IBOutlet var defaultDiscriptionHiddenCollection: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTextField(_textField: joinIdTextField)
        customTextField(_textField: joinPwdTextField)
        customTextField(_textField: joinPwdCheckTextField)
        customTextField(_textField: joinNicknameTextField)
        customTextField(_textField: joinUserNameTextField)
        customTextField(_textField: joinBirthDateTextField)
        
        for label in defaultDiscriptionHiddenCollection {
            label.isHidden = true
        }
        
        joinIdTextField.delegate = self
        joinNicknameTextField.delegate = self
        joinUserNameTextField.delegate = self
    }
    
    func customTextField(_textField: UITextField) {
        //텍스트 필드 둥글게
        _textField.layer.cornerRadius = 25.0
        _textField.layer.masksToBounds = true
        
        //텍스트 필드 안에 패딩
        _textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        _textField.leftViewMode = .always
    }
    
    @IBAction func joinBtnOnClick(_ sender: UIButton) {
        saveJoinUserData()
    }
    
    private func saveJoinUserData(){
        guard let context = self.persistentContainer?.viewContext else { return }
        
        guard let name = joinUserNameTextField.text, !name.isEmpty else {
            print("Name is empty")
            return
        }
        guard let id = joinIdTextField.text, !id.isEmpty else {
            print("id is empty")
            return
        }
        guard let pwd = joinPwdTextField.text, !pwd.isEmpty else {
            print("pwd is empty")
            return
        }
        guard let checkPwd = joinPwdCheckTextField.text, !checkPwd.isEmpty else {
            print("checkPwd is empty")
            return
        }
        guard let nickName = joinNicknameTextField.text, !nickName.isEmpty else {
            print("nickName is empty")
            return
        }
        guard let birthDate = joinBirthDateTextField.text, !birthDate.isEmpty else {
            print("birthDate is empty")
            return
        }
        let savejoinData = User(context: context)
        
        savejoinData.id = id
        savejoinData.pwd = pwd
        savejoinData.nickName = nickName
        savejoinData.birthDate = Int32(birthDate) ?? 0
        savejoinData.name = name
        
        try? context.save()
    }
}

extension JoinController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard textField.text!.count < 10 else { return false } // 10 글자로 제한
        return true
    }
}


