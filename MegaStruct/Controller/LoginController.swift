import UIKit
import CoreData
class LoginController: UIViewController {
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var userPwdTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var goToJoinPageBtn: UIButton!
    @IBOutlet weak var alertIdPwdLabel: UILabel!
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @objc func checkBoxDidTap() {
        if checkBoxImageView.image == UIImage(systemName: "square") {
            checkBoxImageView.image = UIImage(systemName: "checkmark.square")
        } else {
            checkBoxImageView.image = UIImage(systemName: "square")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let lastLoggedInUser = UserDefaults.standard.string(forKey: "userIdForKey") {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.moveMain()
              } //자동로그인
            }
        customTextField(userIdTextField)
        customTextField(userPwdTextField)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxDidTap))
        checkBoxImageView.isUserInteractionEnabled = true
        checkBoxImageView.addGestureRecognizer(tapGesture)
        alertIdPwdLabel.isHidden = true//라벨 값 초기 로딩 시 히든
    }
    
    func customTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 25.0
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
    }
    
    @IBAction func LoginBtnOnClick(_ sender: Any) {
        guard let userId = userIdTextField.text, !userId.isEmpty else {
            print("User ID is empty")
            shakeTextField(userIdTextField)
            return
        }
        
        guard let userPWD = userPwdTextField.text, !userPWD.isEmpty else {
            print("User password is empty")
            shakeTextField(userPwdTextField)
            return
        }
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND pwd == %@", userId, userPWD)
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                print("Login successful!")
                UserDefaults.standard.set(userId, forKey: "userIdForKey")
                print("")
                // 출력할 사용자 데이터를 가져와서 출력
                for user in results {
                    print("---- User Data ----")
                    print("ID: \(user.id ?? "")")
                    print("Name: \(user.name ?? "")")
                    print("Nickname: \(user.nickName ?? "")")
                    print("Birth Date: \(user.birthDate)")
                    print("Password: \(user.pwd ?? "")")
                    print("----")
                }
                moveMain()
            } else {
                print("Login failed: Invalid user ID or password") 
                alertIdPwdLabel.isHidden = false//라벨 값을 히든으로 놨다가 여기서 보여지는거
                userIdTextField.layer.borderWidth = 1.0
                userIdTextField.layer.borderColor = UIColor.red.cgColor
                userPwdTextField.layer.borderWidth = 1.0
                userPwdTextField.layer.borderColor = UIColor.red.cgColor
                shakeTextField(userIdTextField)
                shakeTextField(userPwdTextField)
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
    }

    
    func moveMain() {
        let mainVC = MainViewController()
        present(mainVC, animated: true)
    }
    
    func shakeTextField(_ textField: UITextField) {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 5
        shake.autoreverses = true
        shake.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 5, y: textField.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 5, y: textField.center.y))
        textField.layer.add(shake, forKey: "position")
    }
    
    @IBAction func goToJoinPageBtnOnClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "JoinView", bundle: nil)
        if let joinVC = storyboard.instantiateViewController(withIdentifier: "JoinController") as? JoinController {
            joinVC.modalPresentationStyle = .fullScreen
            present(joinVC, animated: true, completion: nil)
        }
    }
    
}
