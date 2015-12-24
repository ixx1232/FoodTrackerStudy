//
//  RatingControl.swift
//  FoodTracker
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 www.ixx.com. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    // MARK: Properties
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    var sapcing = 5
    var stars = 5
    
    var ratingButtons = [UIButton]()

    // MARK: Initialization
   
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        let emptyStarImage = UIImage(named: "emptyStar")
        let filledStarImage = UIImage(named: "filledStar")
        
        for _ in 0..<stars {
            let button = UIButton()
            
            button.setImage(emptyStarImage, forState: UIControlState.Normal)
            button.setImage(filledStarImage, forState: UIControlState.Selected)
            button.setImage(filledStarImage, forState: [UIControlState.Selected,UIControlState.Highlighted])
            
            button.adjustsImageWhenHighlighted = false
            
            button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: UIControlEvents.TouchDown)
            ratingButtons += [button]
            addSubview(button)
        }
        
    }
    
    override func layoutSubviews() {
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + sapcing))
            button.frame = buttonFrame
        }
        
        updateButtonSelectionStates()
    }
    
    
    override func intrinsicContentSize() -> CGSize {
        
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + sapcing) * stars
        
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
        
        rating = ratingButtons.indexOf(button)! + 1
        
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        
        for (index, button) in ratingButtons.enumerate() {
            button.selected = index < rating
        }
    }

}



