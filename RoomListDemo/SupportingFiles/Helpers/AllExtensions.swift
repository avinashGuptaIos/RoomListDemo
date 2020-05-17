//
//  AllExtensions.swift
//  RoomListDemo
//
//  Created by mac on 16/05/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

protocol Utilities {
}

//MARK:- Utilities Extensions
extension NSObject:Utilities {
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        if flags.contains(.reachable) == false {
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
}




//MARK:-UIColor Extensions
extension UIColor {
    
   class func hexStringToUIColor (hex:String, withOpacity: CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(withOpacity)
        )
    }
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat)->UIColor{
        return UIColor(red:red/255 , green: green/255, blue: blue/255, alpha: 1)
    }
}


//MARK: Dictionary [AnyHashable: Any]

extension Dictionary where Key: Hashable, Value: Any
{
    func getDataFromDictionary() -> Data? {
        do {
            let taskData = try JSONSerialization.data(withJSONObject: self as Any, options: .prettyPrinted)
            return taskData
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

//MARK:- UIWindow Extensions

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}



//MARK:- UIView Extensions

extension UIView {
    
    func addConstraints(_ format: String, constraintViews: [UIView]) {
        var viewsDictionary = [String: Any]()
        for view: UIView in constraintViews {
            let key = "v\((constraintViews as NSArray).index(of: view))"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewsDictionary))
    }
    
}

//MARK: UIViewController Extensions

extension UIViewController {
    
    //MARK:- For InternetConnectivity Observers
       func addObserverForInternetConnectivity() {
           NotificationCenter.default.addObserver(self, selector: #selector(self.gotInternetConnectivity), name: NSNotification.Name.INTERNET_CONNECTION, object: nil)
       }
       
       func removeObserverForInternetConnectivity() {
           NotificationCenter.default.removeObserver(self, name: NSNotification.Name.INTERNET_CONNECTION, object: nil)
       }
       
       @objc func gotInternetConnectivity() {
           SHOW_TOAST("Connection established")
       }
}

//MARK: Extention for Array

extension Array {
    func indexesOf<T : Equatable>(object:T) -> [Int] {
        var result: [Int] = []
        for (index,obj) in self.enumerated() {
            if obj as! T == object {
                result.append(index)
            }
        }
        return result
    }
}
