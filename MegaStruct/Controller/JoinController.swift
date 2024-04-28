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
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var alertNickNameLabel: UILabel!
    @IBOutlet weak var alertIdLabel: UILabel!
    @IBOutlet weak var alertPwdLabel: UILabel!
    @IBOutlet weak var alertCheckPwdLabel: UILabel!
    @IBOutlet weak var alertNameLabel: UILabel!
    @IBOutlet weak var alertBirthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTextField(joinIdTextField)
        customTextField(joinPwdTextField)
        customTextField(joinPwdCheckTextField)
        customTextField(joinNicknameTextField)
        customTextField(joinUserNameTextField)
        customTextField(joinBirthDateTextField)
        joinIdTextField.addTarget(self, action: #selector(validateId), for: .editingChanged)
        joinPwdTextField.addTarget(self, action: #selector(validatePassword), for: .editingChanged)
        joinPwdCheckTextField.addTarget(self, action: #selector(validatePasswordCheck), for: .editingChanged)
        joinBirthDateTextField.addTarget(self, action: #selector(validateBirthDate), for: .editingChanged)
        joinIdTextField.keyboardType = .asciiCapable
        joinPwdTextField.textContentType = .newPassword
        joinPwdCheckTextField.textContentType = .newPassword
        joinPwdCheckTextField.isEnabled = false
        hideAllErrorLabels()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func hideAllErrorLabels() {
        alertNickNameLabel.isHidden = true
        alertIdLabel.isHidden = true
        alertPwdLabel.isHidden = true
        alertCheckPwdLabel.isHidden = true
        alertNameLabel.isHidden = true
        alertBirthLabel.isHidden = true
    }
    // 에러 라벨을 보이는 함수
    private func showErrorLabel(_ label: UILabel) {
        label.isHidden = false
    }
    // 에러 라벨을 숨기는 함수
    private func hideErrorLabel(_ label: UILabel) {
        label.isHidden = true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let overlapHeight = keyboardFrame.height - (view.frame.height - (joinBtn.frame.origin.y + joinBtn.frame.height))
        if overlapHeight > 0 {
            self.view.frame.origin.y = -overlapHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func customTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 25.0
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
    }
    
    @objc func validateId() {
        let pattern = "^[a-z0-9]{6,}$"
        let errorMessage = "영문 소문자와 숫자만 사용해 주세요!"
        validateAllFields()
//        textFieldCheck(joinIdTextField, pattern, errorMessage, alertIdLabel)
    }
    
    @objc func validatePassword() {
        let pattern = "^[a-z0-9]{6,}$"
        let errorMessage = "영문 소문자와 숫자만 사용해 주세요!"
        // joinPwdTextField의 유효성 검사 결과를 변수에 저장
        let isValidPassword = textFieldCheck(joinPwdTextField, pattern, errorMessage, alertPwdLabel)
        // joinPwdTextField가 유효성 검사를 통과한 경우
        if isValidPassword {
            joinPwdCheckTextField.isEnabled = true // joinPwdCheckTextField 활성화
        } else {
            joinPwdCheckTextField.isEnabled = false // joinPwdCheckTextField 비활성화
        }
    }
    
    @objc func validatePasswordCheck() {
        guard let pwd = joinPwdTextField.text, !pwd.isEmpty else {
            print("Password is empty")
            return
        }
        guard let checkPwd = joinPwdCheckTextField.text, !checkPwd.isEmpty else {
            print("Password check is empty")
            return
        }
        if checkPwd == pwd {
            hideErrorLabel(alertCheckPwdLabel) // 일치할 때 에러 숨김 처리
        } else {
            showErrorLabel(alertCheckPwdLabel) // 일치하지 않을 때 에러 보이도록 처리
            alertCheckPwdLabel.text = "비밀번호가 일치하지 않습니다."
        }
        validateAllFields()
    }
    
    @objc func validateBirthDate() {
        guard let birthDateText = joinBirthDateTextField.text else { return }
        let isValid = birthDateText.count == 8 && // 8자리인지 확인
        birthDateText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil // 숫자만 입력되었는지 확인
        if isValid {
            hideErrorLabel(alertBirthLabel) // 유효한 입력일 때 에러 숨김 처리
        } else {
            showErrorLabel(alertBirthLabel) // 유효하지 않은 입력일 때 에러 보이도록 처리
            alertBirthLabel.text = "8자리 숫자로 입력해주세요."
        }
    }
    
    private func textFieldCheck(_ textField: UITextField, _ pattern: String, _ errorMessage: String, _ errorLabel: UILabel) -> Bool {
        guard let text = textField.text else { return false }
        let regex = try? NSRegularExpression(pattern: pattern)
        let isValid = regex?.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) != nil
        if isValid {
            // 유효성 검사 통과
            textField.layer.borderWidth = 0
            hideErrorLabel(errorLabel) // 에러 숨김 처리
        } else {
            // 유효성 검사 실패
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.red.cgColor
            showErrorLabel(errorLabel) // 에러 보이도록 처리
            errorLabel.text = errorMessage
        }
        return isValid
    }
    
    private func validateAllFields() {
        // 모든 필드의 유효성 검사 통과 여부 확인
        let isIdValid = textFieldCheck(joinIdTextField, "^[a-z0-9]{6,}$", "영문 소문자와 숫자만 사용해 주세요!", alertIdLabel)
        let isPasswordCheckValid = joinPwdTextField.text == joinPwdCheckTextField.text && !(joinPwdCheckTextField.text?.isEmpty ?? true)
        let isNicknameValid = !(joinNicknameTextField.text?.isEmpty ?? true)
        let isNameValid = !(joinUserNameTextField.text?.isEmpty ?? true)
        let isBirthDateValid = joinBirthDateTextField.text?.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    @IBAction func joinBtnOnClick(_ sender: UIButton) {
        saveJoinUserData()
    }
    
    private func saveJoinUserData() {
        guard let context = self.persistentContainer?.viewContext else { return }
        guard let id = joinIdTextField.text, !id.isEmpty else {
            print("ID is empty")
            return
        }
        guard let pwd = joinPwdTextField.text, !pwd.isEmpty else {
            print("Password is empty")
            return
        }
        guard let checkPwd = joinPwdCheckTextField.text, checkPwd == pwd else {
            print("Passwords do not match")
            return
        }
        guard let nickname = joinNicknameTextField.text, !nickname.isEmpty else {
            print("Nickname is empty")
            return
        }
        guard let name = joinUserNameTextField.text, !name.isEmpty else {
            print("Name is empty")
            return
        }
        guard let birthDate = joinBirthDateTextField.text, !birthDate.isEmpty else {
            print("Birth date is empty")
            return
        }
        let saveJoinData = User(context: context)
        saveJoinData.id = id
        saveJoinData.pwd = pwd
        saveJoinData.nickName = nickname
        saveJoinData.birthDate = Int32(birthDate) ?? 0
        saveJoinData.name = name
        do {
            try context.save()
            print("User data saved successfully")
            print("---- User Data ----")
            print("ID: \(saveJoinData.id ?? "")")
            print("Name: \(saveJoinData.name ?? "")")
            print("Nickname: \(saveJoinData.nickName ?? "")")
            print("Birth Date: \(saveJoinData.birthDate)")
            print("Password: \(saveJoinData.pwd ?? "")")
            print("----")
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error saving user data: \(error)")
        }
    }
}
