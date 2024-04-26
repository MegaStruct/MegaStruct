import UIKit
import CoreData

class LoginController: UIViewController {
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var userPWDTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var joinBtn: UIButton!
    
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
            shakeTextField(userIdTextField)
            return
        }
        
        guard let userPWD = userPWDTextField.text, !userPWD.isEmpty else {
            print("User password is empty")
            shakeTextField(userPWDTextField)
            return
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND pwd == %@", userId, userPWD)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                print("Login successful!")
                UserDefaults.standard.set(userId, forKey: "userIdForKey")
                moveMain()
            } else {
                print("Login failed: Invalid user ID or password")
                shakeTextField(userIdTextField)
                shakeTextField(userPWDTextField)
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
    
    @IBAction func joinBtnOnClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "JoinView", bundle: nil)
        if let joinVC = storyboard.instantiateViewController(withIdentifier: "JoinController") as? JoinController {
            joinVC.modalPresentationStyle = .fullScreen
            present(joinVC, animated: true, completion: nil)
        }
    }
    
}
