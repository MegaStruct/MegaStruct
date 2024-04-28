//
//  String+Extension.swift
//  MegaStruct
//
//  Created by 김정호 on 4/28/24.
//

import UIKit

extension String {
    func replaceReleaseDate() -> String {
        return self.replacingOccurrences(of: "-", with: ".")
    }
    
    func setLineSpacing(_ spacing: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        
        return NSAttributedString(
            string: self,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }
}
