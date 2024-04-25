import UIKit
import CoreData

class LoginController: UIViewController {
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var userPWDTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
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
            print("UserDefaults - Last logged in user: \(lastLoggedInUser)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.moveMain()
            }
        }
        
        customTextField(userIdTextField)
        customTextField(userPWDTextField)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxDidTap))
        checkBoxImageView.isUserInteractionEnabled = true
        checkBoxImageView.addGestureRecognizer(tapGesture)
    }
    
    func customTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 25.0
        textField.layer.masksToBounds = true
        
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
    }
    
    @IBAction func loginBtnOnClick(_ sender: Any) {
        guard let userId = userIdTextField.text, !userId.isEmpty else {
            print("User ID is empty")
            return
        }
        
        guard let userPWD = userPWDTextField.text, !userPWD.isEmpty else {
            print("User password is empty")
            return
        }
        
        // 코어 데이터에서 id와 pwd가 일치하는 사용자 검색
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND pwd == %@", userId, userPWD)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                // 로그인 성공
                print("Login successful!")
                UserDefaults.standard.set(userId, forKey: "userIdForKey")
                moveMain()
            } else {
                // 로그인 실패
                print("Login failed: Invalid user ID or password")
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
    }
    
    func moveMain() {
        guard let nextVC = storyboard?.instantiateViewController(identifier: "TemporaryMainViewController") else {
            return
        }
        present(nextVC, animated: true)
    }
}
