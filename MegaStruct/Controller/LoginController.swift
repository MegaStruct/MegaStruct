//
//  LoginController.swift
//  MegaStruct
//
//  Created by A Hyeon on 4/24/24.
//

import UIKit

class LoginController: UIViewController {

    var userModel = UserModel() // 모델 인스턴스 생성
    //버튼 넣기 userNameTextField: UITextField
    @IBOutlet weak var userIdTextField: UITextField!
    //버튼 넣기 userPWDTextField: UITextField
    @IBOutlet weak var userPWDTextField: UITextField!
    //버튼 넣기 loginBtn: RoundBtn
    @IBOutlet weak var loginBtn: UIButton!
    
    func customTextField(_textField: UITextField) {
        //텍스트 필드 둥글게
        _textField.layer.cornerRadius = 25.0
        _textField.layer.masksToBounds = true
        
        //텍스트 필드 안에 패딩
        _textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        _textField.leftViewMode = .always
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTextField(_textField: userIdTextField)
        customTextField(_textField: userPWDTextField)
    }
    
//    //아이디 형식 검사
//    func isValidEmail(id: String) -> Bool {
//            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
//            return emailTest.evaluate(with: id)
//        }
//        
//        // 비밀번호 형식 검사
//        func isValidPassword(pwd: String) -> Bool {
//            let passwordRegEx = "^[a-zA-Z0-9]{8,}$"
//            let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
//            return passwordTest.evaluate(with: pwd)
//        }
//

    @IBAction func loginBtnOnClick(_ sender: Any) {
        
        guard let userId = userIdTextField.text, !userId.isEmpty else {return}
        guard let userPWD = userPWDTextField.text, !userPWD.isEmpty else {return}
        
        let loginSuccess : Bool = userModel.hasUser(name: userId, pwd: userPWD)
        if loginSuccess {
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "TemporaryMainViewController") else {return}
            self.present(nextVC, animated: true)
        }
        
    }
    
    @IBAction func autoLoginOnClick(_ sender: Any) {
        
    }
}
