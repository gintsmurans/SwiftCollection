//
//  EUIImage.swift
//
//  Created by Gints Murans on 13.03.15.
//  Copyright © 2015 Gints Murans. All rights reserved.
//

import UIKit

public enum UIImageContentMode {
    /// The option to scale the image to fit the new size by changing the aspect ratio of the content if necessary.
    case scaleToFill

    /// The option to scale the image to fill the size by maintaining the aspect ratio. Some portion of the content may be clipped to fill the image's new size.
    case scaleAspectFill

    /// The option to scale the image to fit the size by maintaining the aspect ratio. Any remaining area of the image's bounds is transparent or white in case of formats that does not support transparency.
    case scaleAspectFit

    /// The option to scale the image to fill the size maintaining the aspect ratio, but forcing new image size to filled image size.
    case scaleAspectWidth

    /// The option to scale the image to fit the size by maintaining the aspect ratio, but forcing new image size to be equal to fitted image size.
    case scaleAspectHeight
}


public extension UIImage {
    /// Initializes a image object using the specified color as background color and size as a size for the image
    convenience init?(color: UIColor, size: CGSize) {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            color.setFill()
            UIRectFill(rect)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            self.init(cgImage: (image?.cgImage!)!)
    }


    // MARK: Crop

    /// Crop image. Returns new one.
    func crop(_ bounds: CGRect) -> UIImage?
    {
        return UIImage(cgImage: (self.cgImage?.cropping(to: bounds)!)!,
                       scale: 0.0, orientation: self.imageOrientation)
    }

    /// Crop image to squared size by searching the shortest first
    func cropToSquare() -> UIImage? {
        let size = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let shortest = min(size.width, size.height)
        let left: CGFloat = size.width > shortest ? (size.width-shortest)/2 : 0
        let top: CGFloat = size.height > shortest ? (size.height-shortest)/2 : 0
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let insetRect = rect.insetBy(dx: left, dy: top)
        return crop(insetRect)
    }


    // MARK: Resize

    /// Resize image. Returns new one.
    func resize(_ size: CGSize, contentMode: UIImageContentMode = .scaleToFill) -> UIImage?
    {
        let newSize = size
        let horizontalRatio = newSize.width / self.size.width;
        let verticalRatio = newSize.height / self.size.height;
        var rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        switch contentMode {
        case .scaleAspectFill:
            let ratio = max(horizontalRatio, verticalRatio)
            if self.size.width / self.size.height >= newSize.width / newSize.height {
                rect.size.width = round(self.size.width * ratio)
            } else {
                rect.size.height = round(self.size.height * ratio)
            }
            break
        case .scaleAspectFit:
            let ratio = min(horizontalRatio, verticalRatio)
            if self.size.width / self.size.height >= newSize.width / newSize.height {
                rect.size.height = round(self.size.height * ratio)
            } else {
                rect.size.width = round(self.size.width * ratio)
            }
            break
        case .scaleAspectWidth:
//            rect.size.height = round(self.size.height * ratio)
            break;
        case .scaleAspectHeight:
            break;
        default:
            break;
        }

        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        let transform = CGAffineTransform.identity

        // Rotate and/or flip the image if required by its orientation
        context?.concatenate(transform);

        // Set the quality level to use when rescaling
        context!.interpolationQuality = CGInterpolationQuality(rawValue: 3)!

        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))

        // Draw into the context; this scales the image
        context?.draw(self.cgImage!, in: rect)

        // Get the resized image from the context and a UIImage
        let newImage = UIImage(cgImage: (context?.makeImage()!)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage;
    }


    // MARK: Orientation

    func fixImageOrientation() -> UIImage? {

        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }

        var transform = CGAffineTransform.identity

        switch self.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }

        switch self.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: self.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: self.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }

        let ctx:CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        ctx.concatenate(transform)

        switch self.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
            break
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            break
        }
        
        guard let cgimg = ctx.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: cgimg)
    }
}
