//
//import UIKit
//
//class LikeControl: UIControl {
//
//    private var numberOfLikes: Int = 0
//    private var liked: Bool = false
//    
//    var lable = UILabel()
//    var imageView = UIImageView()
//    
//    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
//        let recognizer = UITapGestureRecognizer(target: self,
//                                                action: #selector(onTap))
//        recognizer.numberOfTapsRequired = 1
//        recognizer.numberOfTouchesRequired = 1
//        return recognizer
//    }()
//    
//    @objc func onTap(){
//        if !liked {
//            liked = true
//            numberOfLikes += 1
//            self.lable.text = String(numberOfLikes)
//            self.imageView.image = UIImage(named: "Heart")
//            self.lable.textColor = UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1)
//            UIView.animateKeyframes(withDuration: 0.5,
//                                    delay: 0,
//                                    options: [],
//                                    animations: {
//                                        UIView.addKeyframe(withRelativeStartTime: 0,
//                                                           relativeDuration: 0.25,
//                                                           animations: {
//                                                            self.imageView.bounds = CGRect(x: 10, y: 7.5, width: 30, height: 30)
//                                        })
//                                        UIView.addKeyframe(withRelativeStartTime: 0.25,
//                                                           relativeDuration: 0.25,
//                                                           animations: {
//                                                            self.imageView.bounds = CGRect(x: 10, y: 7.5, width: 20, height: 20)
//                                        })
//            },
//                                    completion: nil)
//            
//        } else {
//            liked = false
//            numberOfLikes -= 1
//            self.lable.text = String(numberOfLikes)
//            self.lable.textColor = UIColor.darkGray
//            self.imageView.image = UIImage(named: "Heart Blank")
//
//        }
//        
//    }
//    
//    private func setupView(textColor: UIColor, image: String){
//        
//        self.imageView = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 20, height: 20))
//        imageView.image = UIImage(named: image)
//        
//        lable = UILabel(frame: CGRect(x: 40, y: 7.5, width: 20, height: 20))
//        lable.textColor = textColor
//        lable.font = UIFont.boldSystemFont(ofSize: 18)
//        lable.text = String(numberOfLikes)
//        
//        self.addSubview(imageView)
//        self.addSubview(lable)
//    }
//    
//    override init(frame: CGRect) {
//        super .init(frame: frame)
//        self.setupView(textColor: .darkGray, image: "Heart Blank")
//        self.addGestureRecognizer(tapGestureRecognizer)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super .init(coder: aDecoder)
//        self.setupView(textColor: .darkGray, image: "Heart Blank")
//        self.addGestureRecognizer(tapGestureRecognizer)
//        
//    }
//}
//import UIKit
//
//class LikeControl: UIControl{
//    
//    var delegate: FriendDelegate?
//    
//    private var counter: Int = 0
//    private var button: UIButton = UIButton(type: .custom)
//    private var isLiked: Bool = false {
//        didSet {
//            //            updateButton(false)
//        }
//    }
//    
//    private func setupView() {
//        button.setImage(UIImage(named: "Heart Rounded Blank")!, for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        let str = self.counter > 0 ? String(format:"%d", self.counter) : ""
//        button.setTitle(str, for: .normal)
//        button.setTitleColor(UIColor.black, for: .normal)
//        button.tintColor = UIColor.black
//        button.addTarget(self, action: #selector(addLike(_:)), for: .touchUpInside)
//        self.addSubview(button)
//    }
//    
//    private func updateButton(_ animate: Bool) {
//        if isLiked {
//            button.setImage(UIImage(named: "Heart Rounded Blank")!, for: .normal)
//            button.setTitleColor(UIColor.red, for: .normal)
//            button.tintColor = UIColor.red
//        } else {
//            button.setImage(UIImage(named: "Heart Blank-1")!, for: .normal)
//            button.setTitleColor(UIColor.black, for: .normal)
//            button.tintColor = UIColor.black
//        }
//        if animate {
//            let str = self.counter > 0 ? String(format:"%d", self.counter) : ""
//            UIView.transition(with: button.titleLabel!, duration: 1, options: .transitionFlipFromLeft, animations:
//                {self.button.setTitle(str, for: .normal)})
//        }
//        self.layoutSubviews()
//    }
//    
//    @objc private func addLike(_ sender: UIButton) {
//        if isLiked {
//            counter -= 1
//            isLiked = false
//        } else {
//            counter += 1
//            isLiked = true
//        }
//        updateButton(true)
//        guard let userFriendsController = delegate else {return}
//        userFriendsController.onLikedChange(self.counter, self.isLiked)
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.setupView()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.setupView()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        button.frame = bounds
//    }
//    
//    public func getCounter() -> Int {
//        return self.counter
//    }
//    
//    public func setCounter(_ counter: Int) {
//        self.counter = counter
//        let str = counter > 0 ? String(format:"%d", counter) : ""
//        button.setTitle(str, for: .normal)
//    }
//    
//    public func setLiked(_ liked: Bool) {
//        self.isLiked = liked
//        updateButton(false)
//    }
//}
