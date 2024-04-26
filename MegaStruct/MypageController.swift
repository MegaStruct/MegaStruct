
import UIKit
import CoreData
import MegaStruct

class MyPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var wordView: UIView!
    
    var reservations: [NSManagedObject] = []
    // CoreDataManager 인스턴스 생성
    let coreDataManager = CoreDataManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        fetchReservations()
        
        // TableView에 PaymentCell을 등록
        tableView.register(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "paymentCell")
        
        //테이블뷰 구분선 제거
        tableView.separatorStyle = .none
        
        // 프로필 사진 변경
        // 이미지뷰에 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileView.isUserInteractionEnabled = true
        profileView.addGestureRecognizer(tapGesture)
        
        //포인트 색 입히기
        // myView 설정
        myView.layer.borderWidth = 1.0
        myView.layer.borderColor = UIColor.megaRed.cgColor
        myView.layer.cornerRadius = 25.0
        //한마디 View 설정
        wordView.layer.borderColor = UIColor.megaRed.cgColor
        wordView.layer.borderWidth = 1.0
    }
    // 프로필 사진 변경
    @objc func imageTapped() {
        // 이미지를 터치했을 때 수행할 동작: 이미지 선택
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //테이블뷰 스크롤 비활성화
        tableView.isScrollEnabled = false
        
        // 테이블 뷰의 높이 계산
        let tableViewHeight = CGFloat(reservations.count) * 330 // 예매 내역 셀 높이 * 예매 내역 수
        
        // 테이블 뷰의 프레임 조정
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableViewHeight)
        
        // 스크롤 뷰의 컨텐츠 사이즈 설정
        scrollView.contentSize = CGSize(width: view.frame.width, height: tableViewHeight)
        
        //스크롤이 가려지지 않게 여백?공간 추가
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableViewHeight, right: 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 예매내역 셀의 높이
        return 330
    }
        
    func fetchReservations() {
        // CoreDataManager를 사용하여 예매 내역을 가져옴
        reservations = coreDataManager.fetchMovies()
        tableView.reloadData()
    }
    
    //테이블 뷰 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as! PaymentCell

        let reservation = reservations[indexPath.row]
        cell.configure(with: reservation)
        
        // 셀의 버튼에 액션을 연결
        cell.onDeleteButtonTapped = { [weak self] in
            self?.deleteCell(at: indexPath)
        }

        return cell
    }
    
    //예매 내역 삭제하기
    func deleteCell(at indexPath: IndexPath) {
        let deletedReservation = reservations.remove(at: indexPath.row)
        coreDataManager.deleteMovie(movie: deletedReservation)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        // 삭제 후 남은 예매 내역으로 스크롤 뷰의 높이 조정
        scrollView.contentSize.height -= 330
        
    }
    
    //프로필 사진 선택하기
    @IBOutlet weak var profileView: UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileView.image = pickedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    //로그아웃 버튼 클릭 시
    @IBAction func logoutTapped(_ sender: Any) {
        // 확인 메시지를 포함한 UIAlertController 생성
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        // 확인 액션 추가
        let confirmAction = UIAlertAction(title: "확인", style: .destructive)  // { _ in
            //if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginController") {
                //self.navigationController?.pushViewController(loginVC, animated: true)
            //}
        //}
        
        // 취소 액션 추가
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        // 액션 추가
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        // 확인 메시지 표시
        present(alert, animated: true, completion: nil)
    }
    
    // 내 정보 데이터들 받아오기
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel2: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    // 임시로 코어데이터 추가할라고
    @IBAction func addButton(_ sender: Any) {
        addTemporaryReservation() // 버튼이 탭될 때 임시 예매 내역 추가
    }
    // 임시로 예매 내역을 추가하는 기능
    func addTemporaryReservation() {
        // 임시 데이터 생성
        let title = "임시 예매"
        let showDate = Date()
        let showTime = Date()
        let price = "10000"
            
        // CoreDataManager를 사용하여 임시 데이터 저장
        coreDataManager.saveMovie(title: title, showDate: showDate, showTime: showTime, price: price)
            
        // 예매 내역 가져오기
        fetchReservations()
    }
    
}


