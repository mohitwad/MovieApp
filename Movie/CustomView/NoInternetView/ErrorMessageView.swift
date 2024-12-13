//
//  NoInternetView.swift
//  RadarDating
//
//  Created by osx on 20/12/21.
//

import UIKit
import ActiveLabel

class ErrorMessageView: UIView {
    
    //MARK: - Iboutlet
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblText: ActiveLabel!
    
    //MARK: - init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        Bundle.main.loadNibNamed("ErrorMessageView", owner: self, options: nil)
        contentView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(contentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func addView(on view: UIView, icon: UIImage?, text:String, attribute:String, selectHandler: @escaping (String) -> Void) {
        
        var contains = false
        for subview in view.subviews {
            
            if let _ = subview as? ErrorMessageView {
                contains = true
                break
            }
        }
    
        if !contains {
            hide()
            view.addSubview(self)
        }
       
        self.imgIcon.image = icon
        let customType = ActiveType.custom(pattern: "\\s\(attribute)\\b") //Looks for ""
        self.lblText.enabledTypes.append(customType)
        self.lblText.text = text
        self.lblText.customColor[customType] = #colorLiteral(red: 0.02352941176, green: 0.7215686275, blue: 0.631372549, alpha: 1)

        self.lblText.handleCustomTap(for: customType) {
           selectHandler($0)
        }
    }
    
    func updateMessageImage(icon:UIImage?, attribute:String, message: String) {
        self.imgIcon.image = icon
        let customType = ActiveType.custom(pattern: "\\s\(attribute)\\b") //Looks for ""
        self.lblText.enabledTypes.append(customType)
        self.lblText.text = message
        self.lblText.customColor[customType] = #colorLiteral(red: 0.02352941176, green: 0.7215686275, blue: 0.631372549, alpha: 1)
    }
    
    func show() {
        
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
    
}
