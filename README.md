# CalenDeck
하루 일상을 카드로 꾸며서 카드들을 관리하는 일상어플 (2021.1.22 ~ 2021.2.20)

## 폴더구조
* ViewControllers
  * Notificiation
    * 노티피케이션파일
* ViewControllers
  * Main
    * TimeLine
      * TimeLine 뷰컨트롤러
    * Deck
      * Deck 뷰컨트롤러
  * Login
    * Loing,Join 뷰컨트롤러
  * 스토리보드 파일
  * 뷰컨트롤러바인딩 프로토콜
* ViewModel
  * Storage
    * CardStorage
      * Card Model
      * CardStorage파일
    * UserStorage
      * User Model
      * UserStorage파일
    * EventStorage
      * Event Model
      * EventStorage파일
    * Memorytorage
      * MemoryStorage파일
  * 뷰모델 파일
  * 뷰모델타입 파일
* Scene
  * 씬 파일
  * 씬 코디네이터 파일
  
  
# 프로젝트 설명
## 사용 라이브러리리
![Generic badge](https://img.shields.io/badge/RxSwift-5.1.3-blue.svg)
![Generic badge](https://img.shields.io/badge/Action-4.2.0-blue.svg)
![Generic badge](https://img.shields.io/badge/NSObject+Rx-5.1.0-blue.svg)
![Generic badge](https://img.shields.io/badge/FSCalendar-2.8.2-blue.svg)
![Generic badge](https://img.shields.io/badge/SideMenu-6.5.0-blue.svg)
# 샐행화면
## 타임라인
![CalenDeck_타임라인](https://user-images.githubusercontent.com/73823603/130416902-083133e0-ed71-4b75-9ab3-80bc7b3ad230.gif)   
•달력을 통하여 어떤 이벤트가 발생했는지 확인할 수 있습니다.    
•날짜선택 버튼을 통하여 직접 선택할 수 있습니다.  
•달력을 옆으로 스와이프하여 날짜를 선택할 수 있습니다.   
•달력의 사이즈를 줄일 수 있습니다.  
•타임라인을 위로 당겨 새로고침을 할수 있습니다.
## 내 덱
![CalenDeck_덱보기](https://user-images.githubusercontent.com/73823603/130416751-f9f40e97-55fb-46f9-bcd8-4d6465ea3856.gif)  
•우측 상단 덱리스트에서 원하는 카드를 확인할 수 있습니다.  
## 덱 관리
![CalenDeck_관리](https://user-images.githubusercontent.com/73823603/130416672-3ae8c2c0-2c28-433e-9acb-f3cc4580eff2.gif)  
•덱 편집에서 왼쪽으로 셀을 슬라이드 하여 삭제할 수 있습니다.  
•카드 추가버튼을 통하여 카드를 추가할 수 있습니다.  
•카드를 추가하면 이벤트가 자동으로 생성됩니다.  


# 주요기능 
## Calendar FoldAction
•Action을 사용하여 버튼에 바인딩  
•버튼을 탭 할때마다 FSCalendarScope를 바꿔줌
```swift
func foldAction() -> CocoaAction{
        return CocoaAction{ _ in
            if self.calendar.scope == FSCalendarScope.month{
                self.calendar.setScope(.week, animated: true)
                self.foldButton.image = UIImage(systemName: "chevron.down")
            }else{
                self.calendar.setScope(.month, animated: true)
                self.foldButton.image = UIImage(systemName: "chevron.up")
            }
            return Observable.empty()
        }
    }
```
## FSCalendar EventDot
•날짜 배열을 리턴하여 이벤트닷 생성
```swift
func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let stringDate = viewModel.eventStorage.formatter.string(from: date)
        if viewModel.eventStorage.dateArray.contains(stringDate){ return [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)] } else { return [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)] }
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let stringDate = viewModel.eventStorage.formatter.string(from: date)
        if viewModel.eventStorage.dateArray.contains(stringDate){ return 1 } else { return 0 }
    }
```
## 키보드노티피케이션 처리
•키보드가 올라오면 UI를 가릴수 있음  
•키보드 노티피케이션을 사용하여 레이아웃을 맞춰줌
```swift
func notificationBinding(){
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map{$0.userInfo}
            .subscribe(onNext:{ [unowned self] info in
                if let frame = info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                    let keyboardHeight = frame.cgRectValue.height
                    self.bottomConstraint.constant = keyboardHeight
                }
            })
            .disposed(by: rx.disposeBag)
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map{$0.userInfo}
            .subscribe(onNext:{ _ in
                    self.bottomConstraint.constant = 50
            })
            .disposed(by: rx.disposeBag)
    }
```
## SideMenu
•사이드메뉴 뷰컨트롤러를 불러올 때 사용자 몰입을 위해 음영이 있는 효과를 추가  
•Notification을 사용하여 sideMenu가 appear 될 때 와 disappear될 때 post 해줌
```swift
class ClosetSideMenuNavigation: SideMenuNavigationController,SideMenuNavigationControllerDelegate {
    override func viewDidLoad(){
        sideMenuDelegate = self
        self.presentationStyle = .menuSlideIn
        self.isNavigationBarHidden = true
        super.viewDidLoad()
    }
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        ApplicationNotiCenter.sideMenuWillAppear.post(object: self.menuWidth)
    }
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        ApplicationNotiCenter.sideMenuWillDisappear.post()
    }
}
```
# 아쉬운 점
## 캐싱처리
덱 보기 화면에서 이미지를 따로 리사이징하거나 캐싱처리를 하지않아 시간이 오래걸리고 성능이 좋지않음
## 레이아웃
레이아웃 처리가 미숙하여 어긋나거나 삐져나오는 현상이 발생 (SnapKit을 써볼까 ?)
