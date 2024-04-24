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
    
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    @IBOutlet weak var autoLoginBtn: UIButton!
    
    
    @objc func checkBoxDidTap() {
        if checkBoxImageView.image == UIImage(systemName: "square") {
                checkBoxImageView.image = UIImage(systemName: "checkmark.square")
              } else {
                checkBoxImageView.image = UIImage(systemName: "square")
              }
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
        customTextField(_textField: userIdTextField)
        customTextField(_textField: userPWDTextField)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxDidTap))
                checkBoxImageView.isUserInteractionEnabled = true
                checkBoxImageView.addGestureRecognizer(tapGesture) // 이미지 뷰 타겟
        
    }
    
    
    
    @IBAction func loginBtnOnClick(_ sender: Any) {
        
        guard let userId = userIdTextField.text, !userId.isEmpty else {return}
        guard let userPWD = userPWDTextField.text, !userPWD.isEmpty else {return}
        
        let loginSuccess : Bool = userModel.hasUser(name: userId, pwd: userPWD)
        if loginSuccess {
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "TemporaryMainViewController") else {return}
            self.present(nextVC, animated: true)
            //TemporaryMainViewController 는 정호님 메인 페이지랑 연결할거라 확인해보려고 만든 컨트롤러!
        }
        
    }
 
    
    
}

