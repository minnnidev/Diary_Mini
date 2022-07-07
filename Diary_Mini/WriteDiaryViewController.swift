//
//  WriteDiaryViewController.swift
//  Diary_Mini
//
//  Created by 김민 on 2022/07/05.
//

import UIKit

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    
    let datePicker = UIDatePicker()
    var diaryDate: Date?
    var delegate: WriteDiaryViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentView()
        self.configureDateTextField()
    }
    
    private func configureContentView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentView.layer.borderColor = borderColor.cgColor
        self.contentView.layer.borderWidth = 0.5 //테두리 너비
        self.contentView.layer.cornerRadius = 5.0
    }
    
    private func configureDateTextField() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        self.dateTextField.inputView = self.datePicker
    }
    
    @objc func datePickerValueChanged(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd (EE)"
        formatter.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    @IBAction func tapRegisterButton(_ sender: UIBarButtonItem) {
        //Diary 배열에 제목, 내용, 날짜를 넣고 popController
        guard let title = self.titleTextField.text else {return}
        guard let contents = self.contentView.text else {return}
        guard let date = self.diaryDate else {return}
    
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        
        self.delegate?.didSelectRegister(diary: diary)
        self.navigationController?.popViewController(animated: true)
    }
}
