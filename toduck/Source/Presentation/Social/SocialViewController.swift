//
//  SocialViewController.swift
//  toduck
//
//  Created by 박효준 on 7/15/24.
//

import UIKit
import Then
import SnapKit

class SocialViewController: UIViewController {
    private(set) lazy var chipCollectionView = TDChipCollectionView(chipType: .capsule)
    private(set) lazy var chipCollectionView2 = TDChipCollectionView(chipType: .roundedRectangle)
    private(set) lazy var socialFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout()).then {
        $0.backgroundColor = TDColor.baseWhite
        
    }
    
    let chipTexts = ["전체", "집중력", "기억력", "충동", "불안", "수면", "test", "test2", "test3", "test4", "test5"]
    let posts : [Post] = [Post(id: 1,
                               user: .init(id: 1, name: "오리발", icon: "https://placehold.it/36x36", title: "작심삼일", isblock: false),
                               contentText: "콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요?콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요?콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요?콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요?콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요?콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요?콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요?콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요?콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요?콘서타는 먹었는데 다른 약 먹는걸 깜빡했다.. 요새 매일 이러네 ㅠㅠ 저만 이런가요?",
                               imageList: nil,
                               timestamp: .now,
                               likeCount: 21,
                               isLike: true,
                               commentCount: 3,
                               shareCount: nil,
                               routine: nil,
                               type: .communication,
                               category: [.anxiety]),
                          Post(id: 2,
                               user: .init(id: 2, name: "꽉꽉", icon: "https://placehold.it/36x36", title: "작심삼일", isblock: false),
                               contentText: "어제 잠들기 전 새로운 루틴을 추가했다👀\n덕분에 오늘은 까먹는 일 없이 장 챙김✌️어제 잠들기 전 새로운 루틴을 추가했다👀\n덕분에 오늘은 까먹는 일 없이 장 챙김✌️어제 잠들기 전 새로운 루틴을 추가했다👀\n덕분에 오늘은 까먹는 일 없이 장 챙김✌️어제 잠들기 전 새로운 루틴을 추가했다👀\n덕분에 오늘은 까먹는 일 없이 장 챙김✌️어제 잠들기 전 새로운 루틴을 추가했다👀\n덕분에 오늘은 까먹는 일 없이 장 챙김✌️어제 잠들기 전 새로운 루틴을 추가했다👀\n덕분에 오늘은 까먹는 일 없이 장 챙김✌️어제 잠들기 전 새로운 루틴을 추가했다👀\n덕분에 오늘은 까먹는 일 없이 장 챙김✌️",
                               imageList: nil,
                               timestamp: .now,
                               likeCount: 46,
                               isLike: false,
                               commentCount: 7,
                               shareCount: 12,
                               routine: Routine(id: 1, title: "✌️ 나가기 전 잊지 말고 챙기자나가기 전 잊지 말고 챙기자나가기 전 잊지 말고 챙기자", category: "일", isPublic: true, dateAndTime: .now, isRepeating: true, isRepeatAllDay: false, repeatDays: [.monday,.friday], alarm: true, alarmTimes: [.oneHourBefore], memo: "지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산,지갑, 차키, 에어팟, 접이식우산", recommendedRoutines: nil, isFinish: false),
                               type: .communication,
                               category: [.anxiety]),
                          Post(id: 3,
                               user: .init(id: 3, name: "오리궁뎅이", icon: "https://placehold.it/36x36", title: "작심삼일", isblock: false),
                               contentText: "오늘은 피곤해서 진짜 일찍 자고싶은데 ㅠㅠ 잠이 안와서 괴로워요ㅠㅠㅠㅠㅠ",
                               imageList: nil,
                               timestamp: .now,
                               likeCount: 46,
                               isLike: true,
                               commentCount: 7,
                               shareCount: 12,
                               routine: nil,
                               type: .communication,
                               category: [.anxiety]),
                          Post(id: 4,
                               user: .init(id: 76, name: "꽉꽉", icon: "https://placehold.it/36x36", title: "작심삼일", isblock: false),
                               contentText: "어제 잠들기 전 새로운 루틴을 추가했다👀\n덕분에 오늘은 까먹는 일 없이 장 챙김✌️",
                               imageList: nil,
                               timestamp: .now,
                               likeCount: 46,
                               isLike: false,
                               commentCount: 7,
                               shareCount: 12,
                               routine: Routine(id: 12, title: "✌️ 나가기 전 잊지 말고 챙기자", category: "일", isPublic: true, dateAndTime: .now, isRepeating: true, isRepeatAllDay: false, repeatDays: [.monday,.friday], alarm: true, alarmTimes: [.oneHourBefore], memo: "지갑, 차키, 에어팟, 접이식우산", recommendedRoutines: nil, isFinish: false),
                               type: .communication,
                               category: [.anxiety]),
                          Post(id: 5,
                               user: .init(id: 33, name: "오리궁뎅이", icon: "http://placehold.it/36x36", title: "작심삼일", isblock: false),
                               contentText: "오늘은 피곤해서 진짜 일찍 자고싶은데 ㅠㅠ 잠이 안와서 괴로워요ㅠㅠㅠㅠㅠ",
                               imageList: nil,
                               timestamp: .now,
                               likeCount: 46,
                               isLike: true,
                               commentCount: 7,
                               shareCount: 12,
                               routine: nil,
                               type: .communication,
                               category: [.anxiety]),
                          
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
        self.socialFeedCollectionView.dataSource = self
        self.socialFeedCollectionView.delegate = self
    }
}

extension SocialViewController: TDChipCollectionViewDelegate {
    func chipCollectionView(_ collectionView: TDChipCollectionView, didSelectChipAt index: Int, chipText: String) {
        print("[LOG] 현재 Select 한 Chip: \(chipText) , Index = : \(index)")
    }
}

extension SocialViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SocialFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let post = posts[indexPath.item]
        cell.configure(with: post)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("[LOG] Clicked")
    }
}

private extension SocialViewController {
    
    private func setupUI() {
        //MARK: - layout 싹 다 다시 잡아야함
        view.addSubview(chipCollectionView)
        view.addSubview(chipCollectionView2)
        view.addSubview(socialFeedCollectionView)
        chipCollectionView.chipDelegate = self
        chipCollectionView2.chipDelegate = self
        socialFeedCollectionView.register(with: SocialFeedCollectionViewCell.self)
        chipCollectionView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        chipCollectionView2.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(chipCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        chipCollectionView.setChips(chipTexts)
        chipCollectionView2.setChips(chipTexts)
        
        socialFeedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chipCollectionView2.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        
    }
}

private extension SocialViewController {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemPadding: CGFloat = 10
        let groupPadding: CGFloat = 16
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        
        let edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(itemPadding),
            trailing: .fixed(0),
            bottom: .fixed(itemPadding)
        )
        
        let groupInset = NSDirectionalEdgeInsets(
            top: 0,
            leading: groupPadding,
            bottom: 0,
            trailing: groupPadding
        )
        
        return UICollectionViewCompositionalLayout.makeVerticalCompositionalLayout(
            itemSize: itemSize,
            itemEdgeSpacing: edgeSpacing,
            groupSize: groupSize,
            groupInset: groupInset
        )
    }
}


