import Foundation
import UIKit

class Sizing
{
    
    static let singleton = Sizing()
    
    //system dimensions
    static let tabBarHeight : CGFloat = 49
    static let statusBarHeight : CGFloat = 20
    static let navBarHeight : CGFloat = 44
    
    
    //static functions
    class func HundredRelativeWidthPts()->CGFloat
    {
    	return 375/UIScreen.main.bounds.size.width*100
    } 

    class func HundredRelativeHeightPts()->CGFloat
    {
    	return 667/UIScreen.main.bounds.size.height*100
    }

    class func ScreenWidth()->CGFloat
    {
        return UIScreen.main.bounds.size.width
    }

    class func ScreenHeight()->CGFloat
    {
        return UIScreen.main.bounds.size.height
    }

    
}
