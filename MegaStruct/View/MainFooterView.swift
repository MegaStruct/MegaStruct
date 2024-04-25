//
//  MainFooterView.swift
//  MegaStruct
//
//  Created by 김정호 on 4/26/24.
//

import UIKit
import SnapKit

final class MainFooterView: UICollectionReusableView {
    
    // MARK: - properties
    private let divisionLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .megaRed
        return view
    }()
    
    // MARK: - methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraint() {
        self.addSubview(divisionLineView)
        
        divisionLineView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
