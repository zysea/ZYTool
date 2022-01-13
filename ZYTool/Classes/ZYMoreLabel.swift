//
//  ZYMoreLabel.swift.swift
//  ZSTool
//
//  Created by Iann on 2021/12/17.
//

import Foundation
import CoreText

public enum ZYVerticalTextAlignment {
    case top
    case middle
    case bottom
}

public class ZYMoreLabel: UILabel {
    public var orgVerticalTextAlignment:ZYVerticalTextAlignment = .top {
        didSet {
            isDisplay = true
        }
    }
    
    public var orgLineSpacing:CGFloat = 4 {
        didSet {
            isDisplay = true
        }
    }
    
    public var orgCharSpacing:CGFloat = 2 {
        didSet {
            isDisplay = true
        }
    }
    
    public var orgMargin:UIEdgeInsets = .zero {
        didSet {
            isDisplay = true
        }
    }
    
    public var orgLastLineRightIndent:CGFloat = 8
    
    public var orgTruncationEndAttributedString:NSAttributedString?
    
    public var orgDrawOfLines:Int = 3
    
    fileprivate var attributedString:NSMutableAttributedString?
    
    fileprivate var isDisplay:Bool = true
    
    fileprivate var isText:Bool = true
    
    public override var text: String? {
        didSet {
            if text != nil {
                isDisplay = true
                isText = true
            } else {
                isDisplay = false
                isText = false
            }
        }
    }
    
    public override var attributedText: NSAttributedString? {
        didSet {
            if attributedText != nil {
                isDisplay = true
                isText = false
            } else {
                isDisplay = false
                isText = false
            }
        }
    }
    
    public override var textColor: UIColor! {
        didSet {
            isDisplay = true
        }
    }
    
    public override var textAlignment: NSTextAlignment {
        didSet {
            isDisplay = true
        }
    }
    
    public override var font: UIFont! {
        didSet {
            isDisplay = true
        }
    }
    
    private func orgSetAttributedStringStyle(_ text:String?) -> NSMutableAttributedString? {
        guard let text = text else {
            return nil
        }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = orgLineSpacing
        style.paragraphSpacing = 0
        style.alignment = textAlignment
        style.lineBreakMode = .byCharWrapping
        let attributedString = NSMutableAttributedString(string: text)
        let attributes:[NSMutableAttributedString.Key:Any] = [.foregroundColor:textColor,NSMutableAttributedString.Key.font:font,.kern:orgCharSpacing,.paragraphStyle:style]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: text.count))
        return attributedString
    }
    
    public override func drawText(in rect: CGRect) {
        
        guard let text = text,let attributedText = attributedText else {
            return
        }
        if isDisplay {
            if isText {
                attributedString = orgSetAttributedStringStyle(text)
            } else {
                attributedString = NSMutableAttributedString(attributedString: attributedText)
            }
            isDisplay = false
        }
        guard let attributedString = attributedString else {
            return
        }
        let drawRect = CGRect(x: orgMargin.left, y: orgMargin.top, width: bounds.width - orgMargin.left - orgMargin.right, height:  CGFloat(MAXFLOAT))
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let forecastPath = CGMutablePath()
        forecastPath.addRect(drawRect)
        let forecastFrame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), forecastPath, nil)
        let forecastLines = CTFrameGetLines(forecastFrame)
        let forecastMaxLineNumber = CFArrayGetCount(forecastLines)
        
        let drawingRect = CGRect(x: drawRect.origin.x, y: drawRect.origin.y, width:drawRect.width, height: CGFloat(MAXFLOAT))
        let textPath = CGMutablePath()
        textPath.addRect(drawingRect)
        let textFrame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), textPath, nil)
        let textlines = CTFrameGetLines(textFrame)
        let textMaxLineNumber = CFArrayGetCount(textlines)
        
        let minLinesNumber = min(forecastMaxLineNumber, textMaxLineNumber)
        orgDrawOfLines = numberOfLines == 0 ? minLinesNumber : min(minLinesNumber,numberOfLines)
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        context.textMatrix = .identity
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: bounds.height)
        
        var lineOrigins:[CGPoint] = [CGPoint](repeating: .zero, count: orgDrawOfLines)
        CTFrameGetLineOrigins(forecastFrame, CFRangeMake(0, orgDrawOfLines), &lineOrigins)
        
        for lineIndex in 0..<orgDrawOfLines {
            
            let line:CTLine = CFArrayGetValueAtIndex(forecastLines, lineIndex).load(as: CTLine.self)

            var lineOrigin:CGPoint!
            if forecastMaxLineNumber >= orgDrawOfLines && orgVerticalTextAlignment == .top {
                let topMargin = lineOrigins[orgDrawOfLines - 1].y / 2.0
                lineOrigin = lineOrigins[lineIndex]
                lineOrigin = CGPoint(x: lineOrigin.x, y: lineOrigin.y - floor(topMargin))
            } else if (orgVerticalTextAlignment == .bottom) {
                var ascent:CGFloat = 0
                var descent:CGFloat = 0
                var leading:CGFloat = 0
                CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
                lineOrigin = lineOrigins[orgDrawOfLines - 1 - lineIndex];
                lineOrigin = CGPoint(x: lineOrigin.x, y: bounds.height - floor(lineOrigin.y + ascent - descent))
            } else {
                lineOrigin = lineOrigins[lineIndex]
            }
            var lastLine:CTLine! = nil
            if orgDrawOfLines < textMaxLineNumber {
                if lineIndex == orgDrawOfLines - 1 {
                    let range = CTLineGetStringRange(line)
                    let attributes = attributedString.attributes(at: range.location + range.length - 1, effectiveRange: nil)
                    var token = NSAttributedString(string: "...",attributes: attributes)
                    if let orgTruncationEndAttributedString = orgTruncationEndAttributedString {
                        let attributedString = NSMutableAttributedString(attributedString: token)
                        attributedString.append(orgTruncationEndAttributedString)
                        token = attributedString
                    }
                    let truncationToken = CTLineCreateWithAttributedString(token)
                    
                    var lastLineRange = NSRange(location: range.location, length: 0)
                    lastLineRange.length = attributedString.length - lastLineRange.location
                    let longString = attributedString.attributedSubstring(from: lastLineRange)
                    let endLine = CTLineCreateWithAttributedString(longString)
                    lastLine = CTLineCreateTruncatedLine(endLine, bounds.width - orgLastLineRightIndent, .end, truncationToken)
                }
            }
            if lastLine != nil {
                context.textPosition = lineOrigin
                CTLineDraw(lastLine, context)
            } else {
                context.textPosition = lineOrigin
//                CTLineDraw(line,context)
            }
        }
        context.addEllipse(in: drawRect)
        UIGraphicsPushContext(context)
    }
}
