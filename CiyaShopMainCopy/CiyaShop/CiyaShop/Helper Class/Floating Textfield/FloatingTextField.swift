//
//  FloatingTextField.swift
//  AnimatedTextField
//
//  Created by Alexey Zhulikov on 22.10.2019.
//  Copyright © 2019 Alexey Zhulikov. All rights reserved.
//

import UIKit

private extension TimeInterval {
    static let animation250ms: TimeInterval = 0.25
}

private extension UIColor {
    static let inactive: UIColor = .gray
}

private enum Constants {
    static let offset: CGFloat = 0
    static let placeholderSize: CGFloat = 12
}

final class FloatingTextField: UITextField {

    // MARK: - Subviews

    private var label = UILabel()

    // MARK: - Private Properties

    private var scale: CGFloat {
        Constants.placeholderSize / fontSize
    }

    private var fontSize: CGFloat {
        font?.pointSize ?? 0
    }

    private var labelHeight: CGFloat {
        ceil(font?.withSize(Constants.placeholderSize).lineHeight ?? 0)
    }

    private var textHeight: CGFloat {
        ceil(font?.lineHeight ?? 0)
    }

    private var isEmpty: Bool {
        text?.isEmpty ?? true
    }

    private var textInsets: UIEdgeInsets {
        UIEdgeInsets(top: Constants.offset + labelHeight, left: 0, bottom: Constants.offset+14, right: 0)
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - UITextField

    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: textInsets.top + textHeight + textInsets.bottom)
    }

    override var placeholder: String? {
        didSet {
            label.text = placeholder
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        border.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
        updateLabel(animated: false)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard !isFirstResponder else {
            return
        }
        
        label.transform = .identity
        label.frame = bounds.inset(by: textInsets)
        updateLabel(animated: false)
    }

    // MARK: - Private Methods

    private func setupUI() {
        borderStyle = .none

//        border.backgroundColor = .inactive
//        border.isUserInteractionEnabled = false
//        addSubview(border)

        label.font = UIFont.appLightFontName(size: fontSize12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .inactive
        label.text = placeholder
        label.isUserInteractionEnabled = false
        addSubview(label)
        
        
        let horizontalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        verticalConstraint.priority = UILayoutPriority(rawValue: 1000)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])

        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
        
        if isRTL {
            self.textAlignment = .right
        } else {
            self.textAlignment = .left
        }
    }

    @objc
    private func handleEditing() {
        updateLabel()
    }

    private func updateLabel(animated: Bool = true) {
        let isActive = isFirstResponder || !isEmpty

        var offsetX = -label.bounds.width * (1 - scale) / 2
        var offsetY = -label.bounds.height * (1 - scale) / 2
        

        if isRTL {
            offsetX = label.bounds.width * (1 - scale) / 2
            offsetY = label.bounds.height * (1 - scale) / 2 - 4
        }
     
        let transform = CGAffineTransform(translationX: offsetX, y: offsetY - labelHeight - Constants.offset)
            .scaledBy(x: scale, y: scale)

        guard animated else {
            label.transform = isActive ? transform : .identity
            return
        }

        UIView.animate(withDuration: .animation250ms) {
            self.label.transform = isActive ? transform : .identity
        }
    }
}
