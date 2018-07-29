//
//  SenderInputViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 27/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit


class SenderInputViewController: UIViewController {
    
    @IBOutlet weak var toMotionButton: UIButton!
    @IBOutlet weak var testTextTransferTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handle tapping to deactivate keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Calls this function when the tap is recognized
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case Constants.Segue.senderInfoToMotion:
            let destination = segue.destination as! MotionViewController
            destination.testLabelText = testTextTransferTextField.text ?? "No text entered"
            UserService.updateUserText(User.current, childNode: Constants.UserDictionary.sender, passableTestText: testTextTransferTextField.text ?? "No text entered")
        case Constants.Segue.backFromSender:
            UserService.deleteUserReference(User.current)
            User.current.type = Constants.UserDictionary.unselected
        default:
            print("error no correct segue identified")
        }
    }
    
    @IBAction func toMotionButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segue.senderInfoToMotion, sender: self)
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue){
    }
    
    
    
}
