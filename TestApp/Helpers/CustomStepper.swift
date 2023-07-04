//
//  CustomStepper.swift
//  TestApp
//
//  Created by Григорий Душин on 03.07.2023.
//

import UIKit

class CustomStepper: UIControl {
    private let incrementButton = UIButton(type: .system)
    private let decrementButton = UIButton(type: .system)
    private let valueTextField = UITextField()
    
    var value: Int = 0 {
        didSet {
            if value < 0 {
                value = 0
            }
            valueTextField.text = "\(value)"
            sendActions(for: .valueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        incrementButton.setTitle("+", for: .normal)
        incrementButton.setTitleColor(.black, for: .normal)
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        
        decrementButton.setTitle("-", for: .normal)
        decrementButton.setTitleColor(.black, for: .normal)
        decrementButton.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)
        
        valueTextField.text = "\(value)"
        valueTextField.textAlignment = .center
        valueTextField.keyboardType = .numberPad
        valueTextField.delegate = self
        
        addSubview(incrementButton)
        addSubview(decrementButton)
        addSubview(valueTextField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        incrementButton.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
        decrementButton.frame = CGRect(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
        valueTextField.frame = CGRect(x: bounds.height, y: 0, width: bounds.width - 2 * bounds.height, height: bounds.height)
    }
    
    @objc private func incrementButtonTapped() {
        value += 1
    }
    
    @objc private func decrementButtonTapped() {
        value -= 1
    }
}

extension CustomStepper: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let newValue = Int(textField.text ?? "") {
            value = newValue
        } else {
            textField.text = "\(value)"
        }
    }
}
