//
//  AlarmListViewController.swift
//  HandsUp
//
//  Created by 윤지성 on 2023/01/16.
//

import UIKit

class AlarmListViewController: UIViewController{
    
    var likeList : [board_like] = []
    var characterList: [Int] = []
    var characterInAlarm: Character = Character.init()
    
    // 테스트용 코드 지울것!
    let like_test = board_like.init()
    
    var background = 0, hair = 0, eyebrow = 0, mouth = 0, nose = 0, eyes = 0, glasses = 0
    
    @IBOutlet var alarmTableView_ALVC: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmTableView_ALVC.delegate = self
        alarmTableView_ALVC.dataSource = self
        alarmTableView_ALVC.rowHeight = 98
        
        alarmTableView_ALVC.backgroundColor = UIColor(named: "HandsUpBackGround")
        
        likeList = PostAPI.showBoardsLikeList() ?? []
        
         
            print("서버통신 성공 및 원소 개수 ==  \(likeList.count)")
        
        likeList.append(like_test)
        print("추가 이후 서버통신 성공 및 원소 개수 ==  \(likeList.count)")
        
        
    }
    

}

extension AlarmListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
        return likeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmTableViewCell", for: indexPath) as! AlarmTableViewCell
        
        let createdDate  = likeList[indexPath.row].likeCreatedAt.toDate()
        cell.timeLb_ATVC.text = createdDate.getTimeDifference()
        //캐릭터 설정
        characterList = []
        characterInAlarm = likeList[indexPath.row].character
        
        background = (Int(characterInAlarm.backGroundColor) ?? 1) - 1
        hair = (Int(characterInAlarm.hair) ?? 1) - 1
        eyebrow = (Int(characterInAlarm.eyeBrow) ?? 1) - 1
        mouth = (Int(characterInAlarm.mouth) ?? 1) - 1
        nose = (Int(characterInAlarm.nose) ?? 1) - 1
        eyes = (Int(characterInAlarm.eye) ?? 1) - 1
        glasses = Int(characterInAlarm.glasses ?? "1") ?? 0
        
        characterList.append(background)
        characterList.append(hair)
        characterList.append(eyebrow)
        characterList.append(mouth)
        characterList.append(nose)
        characterList.append(eyes)
        characterList.append(glasses)
        
        cell.characterView_ATVC.setAll(componentArray: characterList)
        cell.characterView_ATVC.setCharacter_NoShadow()
        
        cell.idLb_ATVC.text = likeList[indexPath.row].text
        cell.contentLb_ATVC.text = likeList[indexPath.row].boardContent
        
    
        return cell
    }
}
    

extension UIButton {
    var circleButton: Bool {
        set {
            
            if newValue {
                self.layer.cornerRadius = 0.5 * self.bounds.size.width
                
                self.backgroundColor = UIColor(red: 0.31, green: 0.494, blue: 0.753, alpha: 1)
            } else {
                self.layer.cornerRadius = 0
            }
        } get {
            return false
        }
    }
}
extension UIView {
    @IBInspectable var borderColor: UIColor {
        get {
            let color = self.layer.borderColor ?? UIColor.clear.cgColor
            return UIColor(cgColor: color)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

extension UIView {
    func applyShadow(cornerRadius: CGFloat){
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = 24
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        
        
    }
}
extension String{
    func toDate() -> Date { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
               dateFormatter.timeZone = TimeZone(identifier: "UTC")
               if let date = dateFormatter.date(from: self) {
                   return date
               } else {
                   return Date() // 현재 날짜 출력하기
               }
    }
    
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
    func getTimeDifference() -> String {
        var timeDiff = ""
        let currentDate = Date()
        let remainUTC = self.timeIntervalSince(currentDate)
        var minute: Int?
        var hour: Int?
        
        var formatter_year = DateFormatter()
        formatter_year.dateFormat = "yyyy"
        var current_year_string = formatter_year.string(from: Date())
        var create_year_string = formatter_year.string(from: self)
        
        if(remainUTC < 60){ // 1분 보다 적은 시간일 때
            timeDiff = "방금 전"
        }
        else if(remainUTC < 3600 ) {// 1시간 보다 적은 시간일 떄
            minute = (Int)(remainUTC / 60)
            timeDiff = "\(String(describing: minute))분 전"
        }
        else if(remainUTC < 21600) { // 6시간 보다 적은 시간 경과
            hour = (Int)(remainUTC / 3600)
            timeDiff = "\(String(describing: hour))시간 전"
        }
        else if( current_year_string == create_year_string){ // 저장된 년도와 현재 년도가 같을 때
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            timeDiff =  dateFormatter.string(from: self)
        }
        else{ // 년도가 다를 때
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy/MM/dd HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            timeDiff =  dateFormatter.string(from: self)
        }
        return timeDiff
    }
}
