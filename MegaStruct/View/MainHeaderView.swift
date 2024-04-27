//
//  MainHeaderView.swift
//  MegaStruct
//
//  Created by 김정호 on 4/25/24.
//

import UIKit
import SnapKit

final class MainHeaderView: UICollectionReusableView {
    
    // MARK: - properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - life cycles
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.prepare(text: nil)
    }
    
    // MARK: - methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
    }
    
    private func configureConstraint() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
    }
    
    func prepare(text: String?) {
        self.titleLabel.text = text
    }
}
