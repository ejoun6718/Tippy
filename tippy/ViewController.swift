//
//  ViewController.swift
//  tippy
//
//  Created by Erika Joun on 1/5/18.
//  Copyright © 2018 Erika Joun. All rights reserved.
//

import UIKit

extension Double {
  
  // Truncates double to a certain number of decimal places
  func truncate(places : Int) -> Double
  {
    return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
  }
}

extension UITextField {
  
  // Replaces textfield with underline
  func useUnderline() {
    let border = CALayer()
    let borderWidth = CGFloat(1.0)
    self.borderStyle = UITextBorderStyle.none
    border.borderColor  = UIColor(red: 0.63, green: 0.96, blue: 1, alpha: 0.76).cgColor
    border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
    border.borderWidth = borderWidth
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
  }
}

class ViewController: UIViewController, UITextFieldDelegate {
  
  let defaults = UserDefaults.standard
  @IBOutlet weak var settingsButton: UIBarButtonItem!
  @IBOutlet weak var billField: UITextField!
  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var tipControl: UISegmentedControl!
  
  @IBOutlet weak var twoCost: UILabel!
  @IBOutlet weak var threeCost: UILabel!
  @IBOutlet weak var fourCost: UILabel!
  
  @IBOutlet weak var numOfDinersField: UITextField!
  @IBOutlet weak var nthSymbol: UIImageView!
  @IBOutlet weak var nthCost: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    if(!launchedBefore) {
      setDefaultTips()
      print("First launch")
      UserDefaults.standard.set(true, forKey: "launchedBefore")
    }
    
    calculateTip(self)
    self.billField.delegate = self
    self.numOfDinersField.delegate = self
    
    billField.borderStyle = UITextBorderStyle.none
    numOfDinersField.useUnderline()
    tipControl.layer.cornerRadius = 4
    billField.placeholder = "$"
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onTap(_ sender: Any) {
    view.endEditing(true)
  }
  
  @IBAction func calculateTip(_ sender: Any) {
    let firstTip = defaults.integer(forKey: "firstTip")
    let secondTip = defaults.integer(forKey: "secondTip")
    let thirdTip = defaults.integer(forKey: "thirdTip")
    
    let tipPercentages = [firstTip, secondTip, thirdTip]
    let tipPercentagesIndex = tipControl.selectedSegmentIndex
    
    // Calculate the bill
    let bill = Double(billField.text!) ?? 0
    let tip = bill * Double(tipPercentages[tipPercentagesIndex]) / 100
    let total = bill + tip
    
    tipLabel.text = String(format: "$%.2f", tip)
    totalLabel.text = String(format: "$%.2f", total)
    
    // Save the bill amount
    defaults.set(bill, forKey: "bill")
    
    // Split bill among diners
    let costs = [ twoCost, threeCost, fourCost]
    for index in 0...costs.count - 1 {
      let numberOfDiners = index + 2
      calculateSplitBill(total: total, numberOfDiners: numberOfDiners, label: costs[index]!)
    }
    
    // Show split bill among the entered number of diners
    let savedNumOfDiners = defaults.integer(forKey: "numOfDiners")
    if(savedNumOfDiners != 0) {
      numOfDinersField.text = String(savedNumOfDiners)
    }
    let numberOfDiners = Int(numOfDinersField.text!)
    if(numberOfDiners ?? 0 > 0) {
      nthCost.isHidden = false
      nthSymbol.isHidden = false
      
      calculateSplitBill(total: total, numberOfDiners: numberOfDiners!, label: nthCost)
      
      // Save the number of diners amount
      defaults.set(numberOfDiners, forKey: "numberOfDiners")
    }
    else {
      nthCost.isHidden = true
      nthSymbol.isHidden = true
    }
    
    // Save the number of diners amount
    defaults.set(bill, forKey: "bill")
  }
  
  /* Calculates and displays the cost of the split bill */
  func calculateSplitBill(total: Double, numberOfDiners: Int, label: UILabel) {
    var costPerDiner = total / Double(numberOfDiners)
    costPerDiner = costPerDiner.truncate(places: 2)
    label.text = String(format: "$%.2f x %d", costPerDiner, numberOfDiners)
    
    // Show the extra cents that need to be paid
    let remainder = total - (costPerDiner * Double(numberOfDiners))
    if(!(remainder <= 0.009)) {
      label.text = (label.text)! + String(format: " (+$%.2f)", remainder)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("view will appear")
    
    // Retrieve the default tip percentage and update the tip amount
    tipControl.selectedSegmentIndex = defaults.integer(forKey: "tipPercentagesIndex")
    
    // Update tip percentage options if they were changed
    let firstTip = defaults.integer(forKey: "firstTip")
    let secondTip = defaults.integer(forKey: "secondTip")
    let thirdTip = defaults.integer(forKey: "thirdTip")
    tipControl.setTitle(String(format: "%d%%", firstTip), forSegmentAt: 0)
    tipControl.setTitle(String(format: "%d%%", secondTip), forSegmentAt: 1)
    tipControl.setTitle(String(format: "%d%%", thirdTip), forSegmentAt: 2)
    
    // Retrieve saved bill
    let bill = defaults.double(forKey: "bill")
    if(bill != 0) {
      billField.text = String(bill)
    }
    
    // Automatically show keyboard
    billField.becomeFirstResponder()
    
    calculateTip(self)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("view did appear")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    print("view will disappear")
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("view did disappear")
  }
  
  /* Sets the default values for the tip percentages */
  func setDefaultTips() {
    let defaultFirstTip = 18
    let defaultSecondTip = 20
    let defaultThirdTip = 25
    
    defaults.set(defaultFirstTip, forKey: "firstTip")
    defaults.set(defaultSecondTip, forKey: "secondTip")
    defaults.set(defaultThirdTip, forKey: "thirdTip")
  }
  
  /* Check that the user enters valid values */
  func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
  {
    let text = textField.text
    let isBackspace = strcmp(string, "\\b")
    
    if(textField == numOfDinersField) {
      // Limit entry to numbers only
      if(string == ".") {
        return false
      }
      // Prevent entering zero diners
      if(text?.count ?? 0 == 0 && string == "0") {
        return false
      }
      // Limit entry to 4 digits
      if(text?.count ?? 0 == 4 && isBackspace != -92) {
        return false
      }
    }
    else {
      // Limit entry to one dot
      let countdots = (textField.text?.components(separatedBy: (".")).count)! - 1
      if (countdots > 0 && string == "."){
        return false
      }
      
      // Limit entry to two decimal places
      if(text?.count ?? 0 > 2) {
        let dotFinder = text![text!.index(text!.endIndex, offsetBy: -3)]
        if(isBackspace != -92 && dotFinder == ".") {
          return false
        }
      }
      
      // Limit entry to the millions place
      if(countdots == 0 && text?.count ?? 0 == 7) {
        if(isBackspace != -92 && string != ".") {
          return false
        }
      }
      
      // Prevent leading zeroes
      if(text == "0" && isBackspace != -92 && string != ".") {
        textField.text = ""
      }
      
      // Automatically lead a 0 when "." is typed
      if(text?.count ?? 0 == 0 && string == ".") {
        textField.text = "0"
      }
    }
    return true
  }
}
