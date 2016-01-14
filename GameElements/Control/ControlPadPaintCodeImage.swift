//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import UIKit

class ControlPadPaintCodeImage: UIImageView {
    
    func getTestImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, 1.0)
        ControlPadPaintCodeImage.draw(self.frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    internal class func draw(frame: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let color = UIColor(red: 0.000, green: 0.477, blue: 0.969, alpha: 1.000)
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRectMake(frame.minX, frame.minY, frame.width, frame.height))
        color.setFill()
        rectanglePath.fill()
        
        
        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRectMake(frame.minX, frame.minY, frame.width, frame.height))
        UIColor.whiteColor().setStroke()
        rectangle2Path.lineWidth = 4
        rectangle2Path.stroke()
        
        
        //// Polygon Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame.minX + 0.37625 * frame.width, frame.minY + 0.83929 * frame.height)
        CGContextRotateCTM(context, -90 * CGFloat(M_PI) / 180)
        
        let polygonPath = UIBezierPath()
        polygonPath.moveToPoint(CGPointMake(12.38, 0))
        polygonPath.addLineToPoint(CGPointMake(23.09, 18.56))
        polygonPath.addLineToPoint(CGPointMake(1.66, 18.56))
        polygonPath.closePath()
        UIColor.whiteColor().setFill()
        polygonPath.fill()
        UIColor.whiteColor().setStroke()
        polygonPath.lineWidth = 2
        polygonPath.stroke()
        
        CGContextRestoreGState(context)

    }
}
