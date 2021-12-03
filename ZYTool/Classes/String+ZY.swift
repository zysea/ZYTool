//
//  String+ZY.swift
//  ZYTool
//
//  Created by Iann on 2020/1/21.
//

import Foundation
import CommonCrypto

public extension String {
    
    var md5:String {
        let cStr = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(cStr, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02X", result[i])
        }
        result.deallocate()
        return hash as String
    }
    
    var isEmail:Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return validate(emailRegex)
    }
    
    var isPhone:Bool {
        let regex = "^1\\d{10}$"
        return validate(regex)
    }
    
    var isEmpty: Bool {
        if self.count == 0 {
            return true
        }
        return false
    }
    
    func validate(_ regex:String?) -> Bool {
        guard let regex = regex else { return false }
        let predicate = NSPredicate(format:  "SELF MATCHES %@",regex)
        return predicate.evaluate(with: self)
    }
    
    func append(path:String) -> String {
        if self.last != "/" && path.last != "/" {
            return self + "/" + path
        }
        return self + path
    }
    
    func jsonObject(_ options:JSONSerialization.ReadingOptions = .allowFragments) -> Any? {
        if let data = self.data(using: .utf8) {
            do {
                let jsonObjc = try JSONSerialization.jsonObject(with: data, options: options)
                return jsonObjc
            } catch {
                print("json is nil")
            }
        }
        return nil
    }
 
}
