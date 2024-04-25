//
//  MainView.swift
//  MegaStruct
//
//  Created by 김정호 on 4/24/24.
//

import UIKit
import SnapKit

final class MainView: UIView {
    
    // MARK: - properties
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
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
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160.0), heightDimension: .absolute(220.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(220.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [ createTitleHeaderLayout() ]
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout.init(section: section)
    }
    
    private func createTitleHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(57.0)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return header
    }
}
