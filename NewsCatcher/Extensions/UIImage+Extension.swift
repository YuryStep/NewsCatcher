//
//  UIImage+Extension.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.10.2023.
//

import UIKit

extension UIImage {
    func resizeToScreenWidth() -> UIImage? {
        let screenWidth = UIScreen.main.bounds.width
        let aspectRatio = size.width / size.height
        let newHeight = screenWidth / aspectRatio
        let newSize = CGSize(width: screenWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resizedImage
    }
}
