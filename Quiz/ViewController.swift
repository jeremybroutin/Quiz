//
//  ViewController.swift
//  Quiz
//
//  Created by Jeremy Broutin on 6/28/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var currentQuestionLabel: UILabel!
	@IBOutlet weak var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var nextQuestionLabel: UILabel!
	@IBOutlet weak var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var answerLabel: UILabel!
	@IBOutlet var showAnswerButton: UIButton!
	
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
		
		//updateOffScreenLabel() // disabling as it conflicts with stack view
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// Set the label's initial alpha
		// nextQuestionLabel.alpha = 0 // disabling as it conflicts with stack view
		
	}

	@IBAction func showNextQuestion(sender: AnyObject) {
		currentQuestionIndex += 1
		if currentQuestionIndex == questions.count {
			currentQuestionIndex = 0
		}
		let question: String = questions[currentQuestionIndex]
		currentQuestionLabel.text = question
		//nextQuestionLabel.text = question
		answerLabel.text = "???"
		
		showAnswerButton.enabled = true
		
		//animateLabelTransition() // disabling as it conflicts with stack view
	}

	@IBAction func showAnswer(sender: AnyObject) {
		let answer: String = answers[currentQuestionIndex]
		answerLabel.text = answer
		showAnswerButton.enabled = false
		
	}
	
	func animateLabelTransition(){
		
		// Force view to lay out its subviews before the animation begins
		view.layoutIfNeeded()
		
		// Animate the alpha
		// and the center X constraints
		
		let screenWidth = view.frame.width
		self.nextQuestionLabelCenterXConstraint.constant = 0
		self.currentQuestionLabelCenterXConstraint.constant += screenWidth
		
		UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.CurveLinear], animations: {
			self.currentQuestionLabel.alpha = 0
			self.nextQuestionLabel.alpha = 1
			
			// Recalculate the frames when we are done editing constraints
			self.view.layoutIfNeeded()
			
			}, completion: { _ in
				swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
				swap(&self.currentQuestionLabelCenterXConstraint, &self.nextQuestionLabelCenterXConstraint)
				self.updateOffScreenLabel()
		})
	}
	
	func updateOffScreenLabel(){
		let screenWidth = view.frame.width
		nextQuestionLabelCenterXConstraint.constant = -screenWidth
	}
}

