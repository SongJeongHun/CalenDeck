//
//  CardStorage.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/12.
//
import RxSwift
import Action
import Firebase
import RxFirebaseDatabase
import NSObject_Rx
import RxFirebaseStorage
import Foundation
class CardStorage:CardStorageType{
    let bag = DisposeBag()
    lazy var eventHandler = EventStorage(myID: myID)
    var dateArray:Set<[Int]> = []
    let ref = Database.database().reference()
    let storeRef = Storage.storage()
    var formatter:DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy.MM.dd"
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    private let myID:String
    var cardList:[Card] = []
    var store = BehaviorSubject<[Card]>(value: [])
    lazy var seletedModel = BehaviorSubject<Card>(value: Card(date: Date(), title: "카드가 없습니다!!", content: "카드를 만들어 보세요.", thumbnail: nil))
    required init(myID:String){
        self.myID = myID
    }
    func getCardList(year:Int,month:Int) -> Completable{
        let subject = PublishSubject<Void>()
        cardList = []
        ref.child("users").child(myID).child("cards").rx
            .observeSingleEvent(.value)
            .subscribe(onSuccess:{[unowned self]snap in
                guard let snapValue = snap.value! as? Dictionary<String,Any> else { return }
                let data = snapValue.values
                for i in data{
                    let dict = i as! Dictionary<String,Any>
                    let title = dict["title"] as! String
                    let content =  dict["content"] as! String
                    let date = self.formatter.date(from: dict["date"] as! String)!
                    //                    let thumbnail = dict["thumbnail"] as! String
                    //                    let grade = dict["grade"] as! Int
                    let dateComponents = Calendar.current.dateComponents([.month,.year], from: date)
                    if dateComponents.year! == year && dateComponents.month! == month{
                        let card = Card(date: date, title: title, content: content, thumbnail: nil)
                        self.cardList.append(card)
                    }
                    self.cardList.sort(by:{$0.date < $1.date})
                    if self.cardList.count == 0{
                        self.seletedModel.onNext(Card(date: Date(), title: "카드가 없습니다!!", content: "카드를 만들어 보세요.", thumbnail: nil))
                    }else{
                        self.seletedModel.onNext(self.cardList[0])
                    }
                    self.store.onNext(self.cardList)
                }
                subject.onCompleted()
            })
            .disposed(by: bag)
        return subject.ignoreElements()
    }
    func addCard(card:Card) -> Completable{
        let subject = PublishSubject<Void>()
        ref.child("users").child(myID).child("cards").child(card.title).rx
            .setValue(["title":card.title,"content":card.content,"date":formatter.string(from: card.date) ,"thumbnail":card.thumbnail ?? "none","grade":card.grade])
            .subscribe(onSuccess:{ _ in
                self.eventHandler.createEvent(style: .create(card))
                self.cardList.append(card)
                self.store.onNext(self.cardList)
                subject.onCompleted()
            })
            .disposed(by: bag)
        return subject.ignoreElements()
    }
    func deleteCard(card:Card) -> Completable{
        let subject = PublishSubject<Void>()
        deleteEvent(card: card)
        ref.child("users").child(myID).child("cards").child(card.title).rx
            .removeValue()
            .subscribe(onSuccess:{_ in
                subject.onCompleted()
            }) { error in
                subject.onError(error)
            }
            .disposed(by: bag)
        return subject.ignoreElements()
    }
    func deleteEvent(card:Card) -> Completable{
        let subject = PublishSubject<Void>()
        ref.child("users").child(myID).child("events").child(card.title).rx
            .removeValue()
            .subscribe(onSuccess:{_ in
                subject.onCompleted()
            }) { error in
                subject.onError(error)
            }
            .disposed(by: bag)
        return subject.ignoreElements()
    }
}
extension CardStorage{
    func saveThumbnail(card:Card,img:UIImage) -> Completable{
        let subject = PublishSubject<Void>()
        var data = img.jpegData(compressionQuality: 0.8)!
        let ref = storeRef.reference().child("users/\(myID)/cardsThumbnail").child("\(card.title)_thumbnail").rx
            .putData(data)
            .subscribe(onNext:{metadata in
                subject.onCompleted()
            }) { error in
                subject.onError(error)
            }
            .disposed(by: bag)
        return subject.ignoreElements()
    }
    func getThumbnail(card:Card) -> Observable<UIImage>{
        let subject = PublishSubject<UIImage>()
        let ref = storeRef.reference(forURL: "gs://calendeck-e28b2.appspot.com/users/\(myID)/cardsThumbnail/\(card.title)_thumbnail").rx
//        let localURL = URL(string:"users/\(myID)/cardsThumbnail/\(card.title)_thumbnail")!
        ref.downloadURL()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext:{url in
                let data = try! Data(contentsOf: url)
                subject.onNext(UIImage(data: data)!)
            }) { error in
                print(error)
            }
            .disposed(by: bag)
        return subject
    }

}
