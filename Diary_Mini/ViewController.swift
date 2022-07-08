//
//  ViewController.swift
//  Diary_Mini
//
//  Created by 김민 on 2022/07/05.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var diary: Diary?
    var diaryList = [Diary]() {
        //프로퍼티가 변경될 때마다 호출되는 옵저버
        didSet {
            self.saveData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let writeDiaryViewController = segue.destination as? WriteDiaryViewController else {return}
        writeDiaryViewController.delegate = self
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd (EE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func configureCollectionView() {
        //인스턴스 생성
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //상하좌우 간격 10
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    //save data - UserDefaults 이용
    private func saveData() {
        //UserDefaults 이용 위해 dictionary로 wrap
        let data = self.diaryList.map {
           [
            "title": $0.title,
            "contents": $0.contents,
            "date": $0.date,
            "isStar": $0.isStar
           ]
        }
        UserDefaults.standard.set(data, forKey: "DiaryData")
    }
    
    //load data - UserDefaults
    private func loadData() {
        //Userdefaults에 저장하기 위해 dictionary로 map한 걸 다시 unwrap
        //[[String:Any]] -> 딕셔너리 배열 타입
        guard let data = UserDefaults.standard.object(forKey: "DiaryData") as? [[String: Any]] else {return}
        //딕셔너리 배열 타입을 다시 Diary 타입으로 바꿔주어야 함
        self.diaryList = data.compactMap({
            guard let title = $0["title"] as? String else {return nil}
            guard let contents = $0["contents"] as? String else {return nil}
            guard let date = $0["date"] as? Date else {return nil}
            guard let isStar = $0["isStar"] as? Bool else {return nil}
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        })
        //날짜 순으로 다시 정렬
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
     
}

extension ViewController: WriteDiaryViewDelegate {
    func didSelectRegister(diary: Diary) {
        diaryList.append(diary)
        //일기가 추가될 때마다 날짜 이용하여 sort(내림차순 - 최신순)
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = dateToString(date: diary.date)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 5.0
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/2)-20, height: 200)
    }
}

extension ViewController: UICollectionViewDelegate {
    
}
