//
//  UIAttributedLabel.swift
//  SimpleReactiveSwift
//
//  Created by Santo Michael on 03/03/24.
//

import UIKit

internal class UIAttributedLabel: UILabel {
	
	internal enum TextViewAttributedType {
		case tappable(text: String, completion: () -> Void)
		case underlined(text: String)
		case colored(text: String, color: UIColor)
		case font(text: String, font: UIFont)
	}
	
	private var tapGestureRecognizers: [UITapGestureRecognizerWithClosure] = []
	
	var attributedStrings: [TextViewAttributedType] = [] {
		didSet {
			setAttributedString()
		}
	}
	
	func setAttributedString() {
		guard let text = text else { return }
		let atString = NSMutableAttributedString(string: text)
		let textRange = NSRange(location: 0, length: text.utf16.count)
		atString.addAttribute(.foregroundColor, value: textColor as Any, range: NSRange(location: 0, length: text.utf16.count))
		atString.addAttribute(.font, value: font as Any, range: textRange)
		
		attributedStrings.forEach { attributedString in
			switch attributedString {
			case let .tappable(textToBeTapped, completion):
				let range = (text as NSString).range(of: textToBeTapped)
				let tapGesture = UITapGestureRecognizerWithClosure(target: self, action: #selector(tappedOnLabel(_:)))
				tapGesture.numberOfTapsRequired = 1
				tapGesture.closure = completion
				tapGesture.targetRange = range
				tapGestureRecognizers.append(tapGesture)
				self.isUserInteractionEnabled = true
				self.addGestureRecognizer(tapGesture)
				
			case let .underlined(textToBeUnderlined):
				let range = (text as NSString).range(of: textToBeUnderlined)
				atString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
				
			case let .colored(textToBeColored, color):
				let range = (text as NSString).range(of: textToBeColored)
				atString.addAttribute(.foregroundColor, value: color, range: range)
				
			case let .font(textToChangeTheFont, font):
				let range = (text as NSString).range(of: textToChangeTheFont)
				atString.addAttribute(.font, value: font, range: range)
			}
		}
		
		attributedText = atString
	}
	
	@objc func tappedOnLabel(_ gesture: UITapGestureRecognizerWithClosure) {
		guard let text = self.text else { return }
		let locationOfTouchInLabel = gesture.location(in: self)
		
		// Find the tapped character location for each associated tap gesture
		for tapGesture in tapGestureRecognizers {
			let textContainer = NSTextContainer(size: CGSize.zero)
			let textStorage = NSTextStorage(attributedString: attributedText!)
			let layoutManager = NSLayoutManager()
			
			layoutManager.addTextContainer(textContainer)
			textStorage.addLayoutManager(layoutManager)
			
			textContainer.lineFragmentPadding = 0.0
			textContainer.lineBreakMode = lineBreakMode
			textContainer.maximumNumberOfLines = numberOfLines
			textContainer.size = bounds.size
			
			// Calculate the bounding rect for the entire text
			let boundingRectForText = layoutManager.boundingRect(forGlyphRange: layoutManager.glyphRange(for: textContainer), in: textContainer)
			
			// Calculate the textAlignmentOffset based on textAlignment
			var textAlignmentOffset: CGFloat = 0.0
			switch textAlignment {
			case .center:
				textAlignmentOffset = (bounds.width - boundingRectForText.width) * 0.5
			case .right:
				textAlignmentOffset = bounds.width - boundingRectForText.width
			default:
				break
			}
			
			// Adjust the tap location based on the alignment and textAlignmentOffset
			let adjustedLocationInLabel = CGPoint(x: locationOfTouchInLabel.x - textAlignmentOffset, y: locationOfTouchInLabel.y)
			
			// Find the glyph index for the tapped location
			let glyphIndex = layoutManager.glyphIndex(for: adjustedLocationInLabel, in: textContainer)
			
			// Find the character index for the tapped location
			let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
			
			// Check if the tap is within the range associated with the tap gesture
			if tapGesture.targetRange.contains(characterIndex) {
				// Find the glyph range for the character index
				let glyphRangeForCharacter = layoutManager.glyphRange(forCharacterRange: NSMakeRange(characterIndex, 1), actualCharacterRange: nil)
				
				// Get the bounding rect for the glyph range
				let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRangeForCharacter, in: textContainer)
				
				// Check if the tap is inside the bounding rect
				if boundingRect.contains(adjustedLocationInLabel) {
					// The location is inside the bounding rect, so it's a valid tap
					tapGesture.closure?()
					break
				}
			}
		}
	}
}

class UITapGestureRecognizerWithClosure: UITapGestureRecognizer {
	var closure: (() -> Void)?
	var targetRange: NSRange = NSRange(location: 0, length: 0)
}

extension UITapGestureRecognizerWithClosure {
	// A convenience function to create a UITapGestureRecognizerWithClosure with a closure
	convenience init(target: Any?, action: Selector?, closure: (() -> Void)?) {
		self.init(target: target, action: action)
		self.closure = closure
	}
}

