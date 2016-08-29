//
//  EUIImage.swift
//
//  Created by Gints Murans on 13.03.15.
//  Copyright © 2015 Gints Murans. All rights reserved.
//

import UIKit

public enum UIImageContentMode {
    /// The option to scale the image to fit the new size by changing the aspect ratio of the content if necessary.
    case ScaleToFill

    /// The option to scale the image to fill the size by maintaining the aspect ratio. Some portion of the content may be clipped to fill the image's new size.
    case ScaleAspectFill

    /// The option to scale the image to fit the size by maintaining the aspect ratio. Any remaining area of the image's bounds is transparent or white in case of formats that does not support transparency.
    case ScaleAspectFit

    /// The option to scale the image to fill the size maintaining the aspect ratio, but forcing new image size to filled image size.
    case ScaleAspectFillForceSize

    /// The option to scale the image to fit the size by maintaining the aspect ratio, but forcing new image size to be equal to fitted image size.
    case ScaleAspectFitForceSize
}


public extension UIImage {
    /// Initializes a image object using the specified color as background color and size as a size for the image
    convenience init?(color: UIColor, size: CGSize) {
            let rect = CGRectMake(0, 0, size.width, size.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            color.setFill()
            UIRectFill(rect)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            self.init(CGImage: image.CGImage!)
    }


    // MARK: Crop

    /// Crop image. Returns new one.
    func crop(bounds: CGRect) -> UIImage?
    {
        return UIImage(CGImage: CGImageCreateWithImageInRect(self.CGImage, bounds)!,
                       scale: 0.0, orientation: self.imageOrientation)
    }

    func cropToSquare() -> UIImage? {
        let size = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale)
        let shortest = min(size.width, size.height)
        let left: CGFloat = size.width > shortest ? (size.width-shortest)/2 : 0
        let top: CGFloat = size.height > shortest ? (size.height-shortest)/2 : 0
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let insetRect = CGRectInset(rect, left, top)
        return crop(insetRect)
    }


    // MARK: Resize

    /// Resize image. Returns new one.
    func resize(size: CGSize, contentMode: UIImageContentMode = .ScaleToFill) -> UIImage?
    {
        var newSize = size
        let horizontalRatio = newSize.width / self.size.width;
        let verticalRatio = newSize.height / self.size.height;
        var rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        switch contentMode {
        case .ScaleAspectFill:
            let ratio = max(horizontalRatio, verticalRatio)
            if self.size.width / self.size.height >= newSize.width / newSize.height {
                rect.size.width = round(self.size.width * ratio)
            } else {
                rect.size.height = round(self.size.height * ratio)
            }
            break
        case .ScaleAspectFit:
            let ratio = min(horizontalRatio, verticalRatio)
            if self.size.width / self.size.height >= newSize.width / newSize.height {
                rect.size.height = round(self.size.height * ratio)
            } else {
                rect.size.width = round(self.size.width * ratio)
            }
            break
        default:
            break
        }

        switch contentMode {
        case .ScaleAspectFillForceSize, .ScaleAspectFitForceSize:
            newSize = rect.size
            break
        default:
            break
        }

        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context = CGBitmapContextCreate(nil, Int(newSize.width), Int(newSize.height), 8, 0, colorSpace, bitmapInfo.rawValue)

        let transform = CGAffineTransformIdentity

        // Rotate and/or flip the image if required by its orientation
        CGContextConcatCTM(context, transform);

        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(context, CGInterpolationQuality(rawValue: 3)!)

        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))

        // Draw into the context; this scales the image
        CGContextDrawImage(context, rect, self.CGImage)

        // Get the resized image from the context and a UIImage
        let newImage = UIImage(CGImage: CGBitmapContextCreateImage(context)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage;
    }


    // MARK: Orientation

    func fixImageOrientation() -> UIImage? {

        if self.imageOrientation == UIImageOrientation.Up {
            return self
        }

        var transform = CGAffineTransformIdentity

        switch self.imageOrientation {
        case UIImageOrientation.Down, UIImageOrientation.DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            break
        case UIImageOrientation.Left, UIImageOrientation.LeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            break
        case UIImageOrientation.Right, UIImageOrientation.RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            break
        case UIImageOrientation.Up, UIImageOrientation.UpMirrored:
            break
        }

        switch self.imageOrientation {
        case UIImageOrientation.UpMirrored, UIImageOrientation.DownMirrored:
            CGAffineTransformTranslate(transform, self.size.width, 0)
            CGAffineTransformScale(transform, -1, 1)
            break
        case UIImageOrientation.LeftMirrored, UIImageOrientation.RightMirrored:
            CGAffineTransformTranslate(transform, self.size.height, 0)
            CGAffineTransformScale(transform, -1, 1)
        case UIImageOrientation.Up, UIImageOrientation.Down, UIImageOrientation.Left, UIImageOrientation.Right:
            break
        }

        let ctx:CGContextRef = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height), CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageAlphaInfo.PremultipliedLast.rawValue)!

        CGContextConcatCTM(ctx, transform)

        switch self.imageOrientation {
        case UIImageOrientation.Left, UIImageOrientation.LeftMirrored, UIImageOrientation.Right, UIImageOrientation.RightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage)
            break
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage)
            break
        }
        
        guard let cgimg = CGBitmapContextCreateImage(ctx) else {
            return nil
        }
        
        return UIImage(CGImage: cgimg)
    }
}
