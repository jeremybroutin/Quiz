//
//  AlternativeViewController.swift
//  Quiz
//
//  Created by Jeremy Broutin on 6/30/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.


// Alternative view controller using a LayoutGuide to rotate current and next questions
// instead of hardcoding spacing constraint's constant (Silver Challenge)

import UIKit

class AlternativeViewController: UIViewController {
	
	@IBOutlet weak var currentQuestionLabel: UILabel!
	//@IBOutlet weak var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
	var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var nextQuestionLabel: UILabel!
	//@IBOutlet weak var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
	var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
	@IBOutlet weak var answerLabel: UILabel!
	
	let layoutGuide = UILayoutGuide()
	var layoutGuideConstraint = NSLayoutConstraint() {
		didSet{
			oldValue.active = false
			layoutGuideConstraint.active = true
		}
	}
	
	// Model Layer
	let questions: [String] = [
		"From what is cognac made?",
		"What is 7+7?",
		"What is the capital of Vermont?"
	]
	
	let answers: [String] = [
		"Grapes",
		"14",
		"Montpelier"
	]
	
	var currentQuestionIndex: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		currentQuestionLabel.text = questions[currentQuestionIndex]
		
		view.addLayoutGuide(layoutGuide)
		layoutGuide.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
		currentQuestionLabelCenterXConstraint = layoutGuide.trailingAnchor.constraintEqualToAnchor(currentQuestionLabel.centerXAnchor)
		nextQuestionLabelCenterXConstraint = layoutGuide.leadingAnchor.constraintEqualToAnchor(nextQuestionLabel.centerXAnchor)
		
		currentQuestionLabelCenterXConstraint.active = true
		nextQuestionLabelCenterXConstraint.active = true
		
		updateOffScreenLabel()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// Set the label's initial alpha
		nextQuestionLabel.alpha = 0
		
	}
	
	@IBAction func showNextQuestion(sender: AnyObject) {
		currentQuestionIndex += 1
		if currentQuestionIndex == questions.count {
			currentQuestionIndex = 0
		}
		let question: String = questions[currentQuestionIndex]
		nextQuestionLabel.text = question
		answerLabel.text = "???"
		
		animateLabelTransition()
	}
	
	@IBAction func showAnswer(sender: AnyObject) {
		let answer: String = answers[currentQuestionIndex]
		answerLabel.text = answer
	}
	
	func animateLabelTransition(){
		
		// Force view to lay out its subviews before the animation begins
		view.layoutIfNeeded()
		
		// Animate the alpha
		// and the center X constraints
		
		layoutGuideConstraint = layoutGuide.centerXAnchor.constraintEqualToAnchor(view.trailingAnchor)
		
		UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.CurveLinear], animations: {
			self.currentQuestionLabel.alpha = 0
			self.nextQuestionLabel.alpha = 1
			
			// Recalculate the frames when we are done editing constraints
			self.view.layoutIfNeeded()
			
			}, completion: { _ in
				
				swap(&self.currentQuestionLabel.text, &self.nextQuestionLabel.text)
				self.updateOffScreenLabel()
				
		})
	}
	
	func updateOffScreenLabel(){
		layoutGuideConstraint = layoutGuide.centerXAnchor.constraintEqualToAnchor(view.leadingAnchor)
		currentQuestionLabel.alpha = 1
		nextQuestionLabel.alpha = 0
	}
}


