//
//  String+Extensions.swift
//  E-Learning
//
//  Created by aya on 29/12/2024.
//

import Foundation
import UIKit

extension String {
    func width(usingFont font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = self.size(withAttributes: attributes)
        return size.width
    }
}
