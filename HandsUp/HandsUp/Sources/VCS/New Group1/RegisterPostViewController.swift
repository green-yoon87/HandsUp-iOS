//
//  asViewController.swift
//  HandsUp
//
//  Created by 윤지성 on 2023/01/19.
//

import UIKit

class RegisterPostViewController: UIViewController {

    @IBOutlet weak var tagScrollView_HVC: UIScrollView!
    
    //tag btn 설정
    @IBOutlet weak var totalTagBtn_HVC: UIButton!
    
    
    @IBOutlet weak var talkTagBtn_HVC: UIButton!
    
    @IBOutlet weak var foodTagBtn_HVC: UIButton!
    
    @IBOutlet weak var studyTagBtn_HVC: UIButton!
    
    @IBOutlet weak var hobbyTagBtn_HVC: UIButton!
    
    @IBOutlet weak var tripTagBtn_HVC: UIButton!
    
    @IBOutlet weak var borderLine_HVC: UIView!
    
    @IBOutlet weak var timeLb_HVC: UILabel!
    @IBOutlet weak var timeSlider_HVC: UISlider!
    @IBOutlet weak var sendBtn_HVC: UIButton!
    
    var totalIsOn = false; var talkIsOn = false; var foodIsOn = false; var studyIsOn = false; var hobbyIsOn = false;var tripIsOn = false;
    let unClickedColor = UIColor(named: "HandsUpLightGrey")
    let clickedColor = UIColor(named: "HandsUpOrange")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagScrollView_HVC.canCancelContentTouches = true
        
        borderLine_HVC.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        sendBtn_HVC.layer.cornerRadius = 10
        
        self.timeLb_HVC.text = "1h"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func timeChangeDidChange(_ sender: UISlider) {
        let step: Float = 1
        let timeValue = round(sender.value / step) * step
        sender.value = timeValue
        
        self.timeLb_HVC.text = String(Int(timeValue)) + "h"
    }
    //tag 버튼 action 설정
    
    @IBAction func totalTagDidTap(_ sender: UIButton) {
        if(totalIsOn){
           totalIsOn = false
            totalTagBtn_HVC.setTitleColor(unClickedColor, for: .normal)
        }else{
            resetTagBtn()
            
            totalIsOn = true
            totalTagBtn_HVC.setTitleColor(clickedColor, for: .normal)
        }
    }
    @IBAction func talkTagDidTap(_ sender: UIButton) {
        if(talkIsOn){
            talkIsOn = false
            talkTagBtn_HVC.setTitleColor(unClickedColor, for: .normal)
        }else{
            resetTagBtn()
           
            talkIsOn = true
            talkTagBtn_HVC.setTitleColor(clickedColor, for: .normal)
        }
    }
    @IBAction func foodTagDidTap(_ sender: UIButton) {
        if(foodIsOn){
            foodIsOn = false
            foodTagBtn_HVC.setTitleColor(unClickedColor, for: .normal)
        }else{
            resetTagBtn()
           foodTagBtn_HVC.setTitleColor(clickedColor, for: .normal)
            foodIsOn = true

        }
    }
    @IBAction func studyTagDidTap(_ sender: UIButton) {
        if(studyIsOn){
            studyIsOn = false
            studyTagBtn_HVC.setTitleColor(unClickedColor, for: .normal)
        }else{
            resetTagBtn()
            studyTagBtn_HVC.setTitleColor(clickedColor, for: .normal)
            studyIsOn = true

        }
    }
    @IBAction func hobbyTagDidTap(_ sender: UIButton) {
        if(hobbyIsOn){
            hobbyIsOn = false
            hobbyTagBtn_HVC.setTitleColor(unClickedColor, for: .normal)
        }else{
            resetTagBtn()
            hobbyTagBtn_HVC.setTitleColor(clickedColor, for: .normal)
            hobbyIsOn = true
        }
    }
    
    @IBAction func tripTagDidTap(_ sender: UIButton) {
        if(tripIsOn){
            tripIsOn = false
            tripTagBtn_HVC.setTitleColor(unClickedColor, for: .normal)
        }else{
            resetTagBtn()
            tripTagBtn_HVC.setTitleColor(clickedColor, for: .normal)
            tripIsOn = true
        }
    }
    
    func resetTagBtn() {
        totalTagBtn_HVC.titleLabel?.textColor = unClickedColor
        talkTagBtn_HVC.titleLabel?.textColor = unClickedColor
        foodTagBtn_HVC.titleLabel?.textColor = unClickedColor
        studyTagBtn_HVC.titleLabel?.textColor = unClickedColor
        hobbyTagBtn_HVC.titleLabel?.textColor = unClickedColor
        totalIsOn = false; talkIsOn = false; foodIsOn = false; studyIsOn = false; hobbyIsOn = false; tripIsOn = false
    }

   

}