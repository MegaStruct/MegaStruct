
import UIKit
import CoreData

class TicketingController: UIViewController {

    private let networkManager = NetworkManager.shared
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 영화 정보 초기화
        configureUI()
        
        //시간버튼) 앱 실행 시 현재 시간 버튼에 표시
        updateTimeButton(date: selectedTime)
        
        //날짜버튼 ) 앱 실행 시 오늘 날짜 벼튼에 표시
        updateDateButton(with: selectedDate)
        
        //UIStepper 초기화 및 설정
        setupStepper()
        
        // 총 가격 레이블 업데이트
        updateTotalPriceLabel()
    }
    
    private func configureUI() {
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [ .large()]
        }
        sheetPresentationController?.prefersGrabberVisible = true
        
        movieTitleLabel.text = movie?.title
        movieReleaseLabel.text = movie?.releaseDate
        movieVoteAverageLabel.text = String((movie?.voteAverage ?? 0.0) / 2.0)
        
        if let url = movie?.posterPath {
            networkManager.fetchUrlImage(url: url) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async { [self] in
                        moviePosterImageView.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // 영화 정보 표시
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseLabel: UILabel!
    @IBOutlet weak var movieVoteAverageLabel: UILabel!
    
    // 시간 선택 기능 구현
    @IBOutlet weak var timeSelectButton: UIButton!
    var selectedTime : Date = Date() // 처음은 현재 시간으로 설정
    
    @IBAction func timeTapped(_ sender: Any) {
        showTimePicker()
    }
    
    //pickerView
    func showTimePicker() {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = .time
        pickerView.preferredDatePickerStyle = .wheels
        
        //pickerView 서브뷰로 표시
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.view.addSubview(pickerView)
        
        //선택 클릭 시
        let selectAction = UIAlertAction(title: "선택", style: .default) { [weak self] _ in
            self?.selectedTime = pickerView.date
            self?.updateTimeButton(date: pickerView.date)
        }
        //취소 선택 시
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        
        //alert 창의 크기를 datePicker에 맞추기 위해
        let height : NSLayoutConstraint = NSLayoutConstraint(item: alertController.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 330)
        alertController.view.addConstraint(height)
        
        present(alertController, animated: true, completion: nil)
    }
    //pickerView에서 타임 선택 시 업데이트
    func updateTimeButton(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" //04:24 PM
        let timeString = dateFormatter.string(from: date)
        timeSelectButton.setTitle(timeString, for: .normal)
    }
    
    // 날짜 선택 기능 구현
    @IBOutlet weak var dateSelectButton: UIButton!
    var selectedDate : Date = Date()
    
    @IBAction func dateTapped(_ sender: Any) {
        showDatePicker()
    }
    
    func showDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date() // 오늘 이후 날짜만 선택 가능
        datePicker.locale = Locale(identifier: "ko_KR") // 한국 형식으로 표시
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.view.addSubview(datePicker)
        
        let selectAction = UIAlertAction(title: "선택", style: .default) { [weak self] _ in
            self?.selectedDate = datePicker.date
            self?.updateDateButton(with: datePicker.date)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        
        //alert 창의 크기를 datePicker에 맞추기 위해
        let height : NSLayoutConstraint = NSLayoutConstraint(item: alertController.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 330)
        alertController.view.addConstraint(height)
        
        present(alertController, animated: true)
    }
    
    func updateDateButton(with date:Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.string(from: date)
        dateSelectButton.setTitle(dateString, for: .normal)
    }
    
    // 인원 추가,감소 기능 UIStepper
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countStepper: UIStepper!
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        updateLabelWithValue(value)
        
        calculateTotalPrice() // 총 가격 계산 및 업데이트
    }
    
    func setupStepper() {
        countStepper.minimumValue = 1
        countStepper.maximumValue = 8 //최대 예매 가능 인원
        countStepper.stepValue = 1
        countStepper.value = 1
        
        countStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        updateLabelWithValue(Int(countStepper.value))
    }
    
    func updateLabelWithValue( _ value: Int ){
        countLabel.text = "\(value)"
    }
    
    // 인원 수에 따른 총 가격 변동 (1인당 15000원)
    @IBOutlet weak var totalPrice: UILabel!
    var pricePerPerson = 15000 // 한 명당 기본 가격 (원)
    var total = 15000
    
    func calculateTotalPrice() {
        // 인원 수에 따라 총 가격 계산
        total = pricePerPerson * Int(countStepper.value)
        updateTotalPriceLabel() // 총 가격 레이블 업데이트
    }
        
    func updateTotalPriceLabel() {
        // 숫자 포맷터 생성
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 천 단위 구분 쉼표 사용
        formatter.groupingSeparator = "," // 천 단위 구분 기호 설정
        
        // 숫자 포맷 적용하여 문자열 생성
        if let formattedTotalPrice = formatter.string(from: NSNumber(value: total)) {
            totalPrice.text = "\(formattedTotalPrice)원"
        }
    }
    
    // 결제하기 버튼 클릭 시 ( alert로 확인 창 띄우기 -> 확인 클릭 시 상세 페이지로 이동, 값들 CoreData에 추가 )
    @IBAction func payTapped(_ sender: Any) {
        // 확인 창 생성
        let alertController = UIAlertController(title: "영화 예매", message: "결제하시겠습니까?", preferredStyle: .alert)
                
        // 확인 버튼 생성
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            // CoreData에 영화 정보 저장
            self.saveMovieToCoreData()
                    
            // 상세 화면으로 이동
            self.dismiss(animated: true)
        }
                
        // 취소 버튼 생성
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                
        // 확인 창에 버튼 추가
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
                
        // 확인 창 표시
        present(alertController, animated: true, completion: nil)
    }
            
    // CoreData에 영화 예매 정보 저장하는 메서드
    private func saveMovieToCoreData() {
        let coreDataManager = CoreDataManager.shared
        
        // 필요한 영화 정보 가져오기
        guard let movieTitle = movieTitleLabel.text,
              let showDateText = dateSelectButton.title(for: .normal),
              let showTimeText = timeSelectButton.title(for: .normal),
              let totalPriceText = totalPrice.text else {
            return
        }
                
        // 날짜 형식 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let showDate = dateFormatter.date(from: showDateText) else {
            return
        }
                
        // 시간 형식 변환
        dateFormatter.dateFormat = "hh:mm a"
        guard let showTime = dateFormatter.date(from: showTimeText) else {
            return
        }
                
        // 영화 정보 CoreData에 저장
        coreDataManager.saveMovie(title: movieTitle, showDate: showDate, showTime: showTime, price: totalPriceText)
    }
            
    // 문자열에서 숫자만 추출하는 메서드
    private func extractPrice(from text: String) -> Int? {
        let digits = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Int(digits)
    }
}
