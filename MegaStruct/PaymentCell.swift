//
//  PaymentCell.swift
//  MegaStruct
//
//  Created by Luz on 4/25/24.
//

import UIKit
import CoreData

class PaymentCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payView: UIView!
    
    override func awakeFromNib() {
        //예매내역
        payView.layer.borderColor = UIColor.megaRed.cgColor
        payView.layer.borderWidth = 1.0
    }
    
    // CoreDataManager 인스턴스 생성
    let coreDataManager = CoreDataManager()
    
    var reservation: NSManagedObject?
    
    func configure(with reservation: NSManagedObject) {
        self.reservation = reservation
        
        //영화 제목
        titleLabel.text = reservation.value(forKey: "title") as? String
        //상영 날짜
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let showDate = reservation.value(forKey: "showDate") as? Date {
            dateLabel.text = dateFormatter.string(from: showDate)
        }
        //상영 시간
        dateFormatter.dateFormat = "hh:mm a"
        if let showTime = reservation.value(forKey: "showTime") as? Date {
            timeLabel.text = dateFormatter.string(from: showTime)
        }
        //총 결제한 가격
        priceLabel.text = reservation.value(forKey: "price") as? String
    }
    
    //예매 취소
    var onDeleteButtonTapped: (() -> Void)?
    
    @IBAction func cancelReservation(_ sender: Any) {
        onDeleteButtonTapped?()
    }
    
}
