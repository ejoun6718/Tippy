//
//  SettingsViewController.swift
//  tippy
//
//  Created by Erika Joun on 1/8/18.
//  Copyright © 2018 Erika Joun. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
  let defaults = UserDefaults.standard
  
  @IBOutlet weak var tipControl: UISegmentedControl!
  @IBOutlet weak var tipReplaceButton: UIButton!
  @IBOutlet weak var tipReplaceField: UITextField!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Update tip percentage options if they were changed
    let firstTip = defaults.integer(forKey: "firstTip")
    let secondTip = defaults.integer(forKey: "secondTip")
    let thirdTip = defaults.integer(forKey: "thirdTip")
    tipControl.setTitle(String(format: "%d%%", firstTip), forSegmentAt: 0)
    tipControl.setTitle(String(format: "%d%%", secondTip), forSegmentAt: 1)
    tipControl.setTitle(String(format: "%d%%", thirdTip), forSegmentAt: 2)
    
    tipControl.selectedSegmentIndex = defaults.integer(forKey: "tipPercentagesIndex")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.tipReplaceField.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func changeTip(_ sender: Any) {
    defaults.set(tipControl.selectedSegmentIndex, forKey: "tipPercentagesIndex")
  }
  
  // MARK: - Saves the new tip percentage value
  @IBAction func tipReplace(_ sender: Any) {
    let newTip = Int(tipReplaceField.text!) ?? 0
    let index = tipControl.selectedSegmentIndex
    if index == 0 {
      defaults.set(newTip, forKey: "firstTip")
    }
    if index == 1 {
      defaults.set(newTip, forKey: "secondTip")
    }
    if index == 2 {
      defaults.set(newTip, forKey: "thirdTip")
    }
    tipControl.setTitle(String(format: "%d%%", newTip), forSegmentAt: index)
    clearTip()
  }
  func clearTip() {
    tipReplaceField.text = ""
  }
  
  // MARK: - Check that the user enters valid values
  func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
  {
    let text = textField.text
    let isBackspace = strcmp(string, "\\b")
    
    // Prevent decimal places
    if string == "." {
      return false
    }
    
    // Limit entry to 2 digits unless user is trying to type 100
    if text == "10" {
      if string != "0" && isBackspace != -92 {
        return false
      }
    }
    else if text?.count ?? 0 >= 2 && isBackspace != -92 {
      return false
    }
    
    // Prevent leading zeroes
    if text == "0" && isBackspace != -92 && string != "." {
      textField.text = ""
    }
    return true
  }
}
