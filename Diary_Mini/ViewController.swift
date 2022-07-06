//
//  ViewController.swift
//  Diary_Mini
//
//  Created by 김민 on 2022/07/05.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionVIew: UICollectionView!
    var diary: Diary?
    var diaryList = [Diary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionVIew.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let writeDiaryViewController = segue.destination as? WriteDiaryViewController else {return}
        writeDiaryViewController.delegate = self
    }
}

extension ViewController: WriteDiaryViewDelegate {
    func didSelectRegister(diary: Diary) {
        diaryList.append(diary)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    }
    
    
}
