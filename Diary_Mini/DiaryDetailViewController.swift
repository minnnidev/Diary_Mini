//
//  DiaryDetailViewController.swift
//  Diary_Mini
//
//  Created by 김민 on 2022/07/05.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
    func didSelectDelete(indexPath: IndexPath)
    func didSelectStar(indexPath: IndexPath, isStar: Bool)
}

class DiaryDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var diary: Diary?
    var indexPath: IndexPath?
    weak var delegate: DiaryDetailViewDelegate?
    var starButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView() {
        guard let diary = self.diary else {return}
        self.titleLabel.text = diary.title
        self.contentView.text = diary.contents
        self.dateLabel.text = dateToString(date: diary.date)
        
        //즐겨찾기 버튼 추가
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
    }
    
    @objc func tapStarButton() {
        //diary.isStar이 true이면 탭했을 때 빈 star 이미지, false이면 탭했을 때 꽉 찬 star 이미지
        guard let isStar = self.diary?.isStar else {return}
        guard let indexPath = self.indexPath else {return}
        if isStar {
            self.starButton?.image = UIImage(systemName: "star")
        } else {
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        self.diary?.isStar = !isStar
        self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false)
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd (EE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    @IBAction func deleteButtonDidTap(_ sender: UIButton) {
        //받아온 indexPath를 View Controller로 다시 전달
        guard let indexPath = indexPath else {return}
        self.delegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        //수정된 diary 객체를 전달받아 뷰를 업데이트
        guard let diary = notification.object as? Diary else {return}
        guard let row = notification.userInfo?["indexPath.row"] as? Int else {return}
        self.diary = diary
        self.configureView()
    }
    
    @IBAction func modifyButtonDidTap(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else {return}
        guard let indexPath = self.indexPath else {return}
        guard let diary = self.diary else {return}
        viewController.diaryEditorMode = .edit(indexPath, diary)
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: NSNotification.Name(rawValue: "editDiary"), object: nil)
        //observer: 어떤 인스턴스에서 옵저빙할 것인지
        //selector: Notification을 탐지하고 있다가 event가 발생하면 selector에 정의된 함수 호출
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    deinit {
        //해당 인스턴스에 추가된 모든 옵저버 제거
        NotificationCenter.default.removeObserver(self)
    }
}
