//
//  UILabel+ZY.swift
//  ZSTool
//
//  Created by Iann on 2021/12/17.
//

import Foundation


extension UILabel {
    
    func setReadMoreLabelContentMode() {
        guard let contents = getLinesArrayOfLabelRows() else {return}
        if contents.count <= 1 {
            isUserInteractionEnabled = false
            return
        }
        let cutLength = 20
                
    }
    
    func getLinesArrayOfLabelRows() -> [String]? {
        let labelWidth = frame.size.width
        guard let text = text else { return nil }
        let myFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let attStr = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        let range = NSRange(location: 0, length: attStr.length)
        attStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attStr.addAttribute(.font, value: myFont, range: range)
        let frameSetter = CTFramesetterCreateWithAttributedString(attStr)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: labelWidth, height: CGFloat(MAXFLOAT)))
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: 0), path, nil)
        let lines = CTFrameGetLines(frame) as! Array<CTLine>
        var lineArray = [String]()
        for line in lines {
            let lineRange = CTLineGetStringRange(line)
            let startIndex = text.index(text.startIndex, offsetBy: lineRange.location)
            let endIndex = text.index(startIndex, offsetBy:lineRange.length)
            let lineString = String(text[startIndex..<endIndex])
            CFAttributedStringSetAttribute(attStr,lineRange,kCTKernAttributeName,NSNumber(value: 0))
            CFAttributedStringSetAttribute(attStr,lineRange,kCTKernAttributeName,NSNumber(value: 0))
            lineArray.append(lineString)
        }
        return lineArray
    }
}
