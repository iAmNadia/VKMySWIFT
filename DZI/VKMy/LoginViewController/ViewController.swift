//
//  ViewController.swift
//  VKMy
//
//  Created by NadiaMorozova on 12.11.2018.
//  Copyright © 2018 NadiaMorozova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var Vk: UILabel!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loading: UILabel!
    @IBOutlet weak var loading2: UILabel!
    @IBOutlet weak var loading3: UILabel!
    
 
    private let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // присваиваем его UIScrollVIew
        scroll?.addGestureRecognizer(hideKeyboardGesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        ​animateTitleAppearing​2()
    }
    // Добавим метод отписки при исчезновении контроллера с экрана.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scroll?.contentInset = contentInsets
        scroll?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scroll?.contentInset = contentInsets
        scroll?.scrollIndicatorInsets = contentInsets
    }
    
    // Добавим исчезновение клавиатуры при клике по пустому месту на экране
    @objc func hideKeyboard() {
        self.scroll?.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //    let checkResult = checkUserData()
        //    if !checkResult {
        //        showLoginError()
        //    }
        //return checkResult
        return true
    }
    func checkUserData() -> Bool {
        let loging = login.text!
        let passwords = password.text!
        
        if loging == "admin" && passwords == "123456" {
            return true
        } else {
            return false
        }
    }
    func showLoginError() {
        let alter = UIAlertController(title: "Ошибка", message: "Введены не корректные данные пользователя", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
    }
 
    func ​animateTitleAppearing​2() {
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.beginTime = CACurrentMediaTime() + 1
        UIView.animate(withDuration: 3, delay: 3,
                       options: .repeat, animations: {
                        self.loading.alpha = 0.5
                        
        })
        UIView.animate(withDuration: 3, delay: 4,
                       options: .repeat, animations: {
                        self.loading2.alpha = 0.5
        })
        UIView.animate(withDuration: 3, delay: 5,
                       options: .repeat, animations: {
                        self.loading3.alpha = 0.5
        })
    }
}


