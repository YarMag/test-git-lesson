//
//  ViewController.swift
//  otus-textfield-demo
//
//  Created by Yaroslav Magin on 27.10.2022.
//

import UIKit

class ViewController: UIViewController {

    private enum Constants {
        static let sideOffset: CGFloat = 16
    }
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        return scroll
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.addTarget(self, action: #selector(didChangeDate(sender:)), for: .valueChanged)
        datePicker.timeZone = .current
        
        return datePicker
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter name:"
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.autocapitalizationType = .sentences
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter email:"
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter email:"
        textField.inputView = datePicker
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        view.addGestureRecognizer(backgroundTapGesture)
        
        view.addSubview(scrollView)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(addressTextField)
        scrollView.addSubview(dateTextField)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: scrollView.centerYAnchor),
            // nameTextField.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor), - этот констрейнт помешал нарисовать все как надо :)
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.sideOffset),
            nameTextField.trailingAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            addressTextField.topAnchor.constraint(equalTo: nameTextField.topAnchor),
            addressTextField.leadingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 16),
            addressTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.sideOffset),
            
            dateTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            dateTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            dateTextField.trailingAnchor.constraint(equalTo: addressTextField.trailingAnchor)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(didShowKeyboard(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHideKeyboard(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
    
    @objc private func didTapBackground() {
        view.endEditing(true)
    }
    
    @objc private func didShowKeyboard(notification: NSNotification) {
        print(notification.userInfo!)
        guard let frame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            return
        }
        print(frame.height)
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
    }
    
    @objc private func didHideKeyboard(notification: NSNotification) {
        print("Keyboard hidden")
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc private func didChangeDate(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY, HH:mm"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("Start editing")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameTextField {
            addressTextField.becomeFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let resultString = text.replacingCharacters(in: Range(range, in: text)!, with: string)
        
        let maxCount = 10
        if resultString.count > maxCount {
            textField.text = String(resultString.prefix(maxCount))
            return false
        } else {
            return true
        }
    }
}
