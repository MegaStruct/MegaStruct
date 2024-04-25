//
//  LoginController.swift
//  MegaStruct
//
//  Created by A Hyeon on 4/24/24.
//

import UIKit

class LoginController: UIViewController {
    
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
    //버튼 넣기 userNameTextField: UITextField
    @IBOutlet weak var userIdTextField: UITextField!
    //버튼 넣기 userPWDTextField: UITextField
    @IBOutlet weak var userPWDTextField: UITextField!
    //버튼 넣기 loginBtn: RoundBtn
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    @objc func checkBoxDidTap() {
        if checkBoxImageView.image == UIImage(systemName: "square") {
            checkBoxImageView.image = UIImage(systemName: "checkmark.square")
        } else {
            checkBoxImageView.image = UIImage(systemName: "square")
        }
    }
    
    //이미 있는 유저인지 확인
    func hasUser (name: String, pwd: String) -> Bool {
        for user in model {
            if user.userId == name && user.userPWD == pwd {
                return true
                
            }
        }
        return false
    }
    
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
        
        if let lastLoggedInUser = UserDefaults.standard.string(forKey: "userIdForKey") {
            print("UserDefaults-user: \(lastLoggedInUser)")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.moveMain()
            }
        }
        
        customTextField(_textField: userIdTextField)
        customTextField(_textField: userPWDTextField)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxDidTap))
        checkBoxImageView.isUserInteractionEnabled = true
        checkBoxImageView.addGestureRecognizer(tapGesture) // 이미지 뷰 타겟
    }
    
    @IBAction func loginBtnOnClick(_ sender: Any) {
        
        guard let userId = userIdTextField.text, !userId.isEmpty else {return}
        guard let userPWD = userPWDTextField.text, !userPWD.isEmpty else {return}
        
        let loginSuccess : Bool = hasUser(name: userId, pwd: userPWD)
        if loginSuccess {
            moveMain()
            UserDefaults.standard.set(userId, forKey: "userIdForKey")
            
        }
    }
    
    func moveMain() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "TemporaryMainViewController") else {return}
        self.present(nextVC, animated: true)
    }
}
