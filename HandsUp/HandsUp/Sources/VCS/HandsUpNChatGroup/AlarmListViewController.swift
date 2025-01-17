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
        
        getAllAlarmRead()
        
        
    }
    
    func showBlockAlert(errorContent: String){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { (action) in }; alert.addAction(confirm)

        confirm.setValue(UIColor(red: 0.563, green: 0.691, blue: 0.883, alpha: 1), forKey: "titleTextColor") //확인버튼 색깔입히기
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        let attributedString = NSAttributedString(string: errorContent, attributes: [ NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(red: 1, green: 1, blue: 1, alpha: 1)])
        alert.setValue(attributedString, forKey: "attributedTitle") //컨트롤러에 설정한 걸 세팅

        present(alert, animated: false, completion: nil)
    }
    
    func getAllAlarmRead(){ //새로운 알람이 있으면 false을 리턴하는 함수
        let defaults = UserDefaults.standard
        let alarmNchatVC = self.storyboard?.instantiateViewController(withIdentifier: "AlarmNChatListViewController") as! AlarmNChatListViewController
       // alarmNchatVC.redAlarmBtnLb.alpha = 0 
        defaults.set(Date().toString(), forKey:"isAlarmAllRead")
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
         
        // 보내기 버튼 눌렀을 때 실행할 함수 선언
        cell.sendMessage = { [unowned self] in
            // 1. 새로운 채팅방 개설하기 위해 DB에 채팅 데이터 추가하는 함수 호출
            let boardIdx = likeList[indexPath.row].boardIdx
            
            // 채팅방 키(형식 = 게시물 인덱스 + 게시물 작성자 이메일 + 상대방 이메일)
            let chatRoomKey = String(likeList[indexPath.row].boardIdx) + UserDefaults.standard.string(forKey: "email")! + likeList[indexPath.row].emailFrom
            var statusCode = PostAPI.makeNewChat(boardIndx: boardIdx, chatRoomKey: chatRoomKey)
            
            // 채팅방 화면전환 관련 코드
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else { return  }
            nextVC.modalPresentationStyle = .fullScreen
            
            // 2. DB 에서 요청 데이터 삭제하기
            switch statusCode {
            case 2000: // 채팅방 생성 성공 -> 해당 키로 화면 이동
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                view.window!.layer.add(transition, forKey: kCATransition)
                //채팅방 뷰컨에 게시물 키 전달
                nextVC.boardIdx = likeList[indexPath.row].boardIdx

                present(nextVC, animated: false, completion: nil)
                break
                
            case 4055: // 이미 존재하는 채팅방 -> 해당 이메일로 이동
                //채팅방 뷰컨에 채팅방 키 전달
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                view.window!.layer.add(transition, forKey: kCATransition)
                nextVC.chatRoomKey = chatRoomKey

                present(nextVC, animated: false, completion: nil)
                break
                
            case 4000: //존재하지 않는 유저이다. -> 팝업창
                showBlockAlert(errorContent: "존재하지 않는 사용자 입니다.")
                break
                
            case 4010: //존재하지 않는 게시물이다. -> 팝업창
                showBlockAlert(errorContent: "존재하지 않는 게시물입니다.")
                break
        
            default: // 서버 오류이다.
                ServerError()
                break
            }
           let status_code =  PostAPI.sendChatAlarm(emailID: "wltjd1234@dongguk.edu")
            print("chat alarm; \(status_code)")
            
        }
            
         
        
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
    func getTimeDifference() -> String { // 경과 시간을 보여주는 함수
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
    func getDateToString() -> String{ // 저장 시간을 보여주는 함수
        let current = Calendar.current
        var date = ""
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy"
        
        var current_year_string = myDateFormatter.string(from: Date())
        var create_year_string = myDateFormatter.string(from: self)
        
        myDateFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)

        if(current.isDateInToday(self)){//오늘이다.
            myDateFormatter.dateFormat = "a h시 m분"
        }
        else if(current.isDateInYesterday(self)){
            myDateFormatter.dateFormat = "어제"
        }
        else if(current_year_string == create_year_string){ // 올해일 때
            myDateFormatter.dateFormat = "M월 d일"
        }else{ // 작년부터 쭉 과거
            myDateFormatter.dateFormat = "yyyy. M. d."
        }
        date = myDateFormatter.string(from: self)
        return date
    }
    
     func isNew(fromDate: Date) -> Bool {
            var strDateMessage:Bool = false
            let result:ComparisonResult = self.compare(fromDate)
            switch result {
            case .orderedAscending:
                strDateMessage = true
                break
            default:
                strDateMessage = false
                break
            }
            return strDateMessage
        }
}
