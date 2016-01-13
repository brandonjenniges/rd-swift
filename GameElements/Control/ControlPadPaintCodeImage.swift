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
    
    internal class func draw(canvas: CGRect) {
        //// Color Declarations
        let color = UIColor(red: 0.000, green: 0.477, blue: 0.969, alpha: 1.000)
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRectMake(0, 0, canvas.width, canvas.height))
        color.setFill()
        rectanglePath.fill()
        
        
        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRectMake(0, 0, canvas.width, canvas.height))
        UIColor.whiteColor().setStroke()
        rectangle2Path.lineWidth = 2
        rectangle2Path.stroke()
    }
}
