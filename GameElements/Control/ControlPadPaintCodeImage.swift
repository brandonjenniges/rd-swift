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
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let color = UIColor(red: 0.282, green: 0.636, blue: 1.000, alpha: 1.000)
        let color3 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.grayColor()
        shadow.shadowOffset = CGSizeMake(0.1, 1.1)
        shadow.shadowBlurRadius = 7
        
        
        //// Subframes
        let borderGroup: CGRect = CGRectMake(frame.minX + floor(frame.width * 0.00000 + 0.5), frame.minY, floor(frame.width * 1.00000 + 0.5) - floor(frame.width * 0.00000 + 0.5), frame.height)
        let frame2 = CGRectMake(frame.minX + floor((frame.width - 48) * 0.53191 + 0.5), frame.minY + floor((frame.height - 33) * 0.50000 - 0.5) + 1, 48, 33)
        
        
        //// Border Group
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, (shadow.shadowColor as! UIColor).CGColor)
        CGContextBeginTransparencyLayer(context, nil)
        
        
        //// Background Drawing
        let backgroundPath = UIBezierPath(rect: CGRectMake(borderGroup.minX + floor(borderGroup.width * 0.00000 + 0.5), borderGroup.minY + floor(borderGroup.height * 0.00000 + 0.5), floor(borderGroup.width * 1.00000 + 0.5) - floor(borderGroup.width * 0.00000 + 0.5), floor(borderGroup.height * 1.00000 + 0.5) - floor(borderGroup.height * 0.00000 + 0.5)))
        color.setFill()
        backgroundPath.fill()
        
        
        //// Border Drawing
        let borderPath = UIBezierPath(rect: CGRectMake(borderGroup.minX + floor(borderGroup.width * 0.00000 + 0.5), borderGroup.minY + floor(borderGroup.height * 0.00000 + 0.5), floor(borderGroup.width * 1.00000 + 0.5) - floor(borderGroup.width * 0.00000 + 0.5), floor(borderGroup.height * 1.00000 + 0.5) - floor(borderGroup.height * 0.00000 + 0.5)))
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, (shadow.shadowColor as! UIColor).CGColor)
        UIColor.whiteColor().setStroke()
        borderPath.lineWidth = 6
        borderPath.stroke()
        CGContextRestoreGState(context)
        
        
        CGContextEndTransparencyLayer(context)
        CGContextRestoreGState(context)
        
        
        //// Polygon Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, frame2.minX + 0.16667 * frame2.width, frame2.minY + 0.93939 * frame2.height)
        CGContextRotateCTM(context, -90 * CGFloat(M_PI) / 180)
        
        let polygonPath = UIBezierPath()
        polygonPath.moveToPoint(CGPointMake(15, 0))
        polygonPath.addLineToPoint(CGPointMake(27.99, 22.5))
        polygonPath.addLineToPoint(CGPointMake(2.01, 22.5))
        polygonPath.closePath()
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, (shadow.shadowColor as! UIColor).CGColor)
        color3.setFill()
        polygonPath.fill()
        CGContextRestoreGState(context)
        
        UIColor.whiteColor().setStroke()
        polygonPath.lineWidth = 1
        polygonPath.stroke()
        
        CGContextRestoreGState(context)
    }

}
