import UIKit
import RxSwift
import NSObject_Rx
extension CardManageViewController:UIImagePickerControllerDelegate{
    func addSetTitleAlert(){
        let alert = UIAlertController(title: "카드 관리", message: "제목을 입력하세요.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { action in
            guard let str = alert.textFields?[0].text else { return }
            self.cardTitle.text = str
        }
        let cancel = UIAlertAction(title: "취소", style: .default, handler:nil)
        alert.addAction(okAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    func addThumbnailAlert(){
        let alert = UIAlertController(title: "불러오기", message: "", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "앨범", style: .default) { action in
            self.openLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { action in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .default, handler:nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
        
    }
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.thumbnailImage.image =  userImage
        }
        dismiss(animated: true, completion: nil)
    }
}
