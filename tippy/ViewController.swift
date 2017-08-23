//
//  ViewController.swift
//  tippy
//
//  Created by Leung Wai Chan on 8/7/17.
//  Copyright © 2017 Leung Wai Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var segControlButtons: UISegmentedControl!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var taxField: UITextField!
    @IBOutlet weak var tipIncludeTax: UISwitch!
    @IBOutlet weak var friendSplit: UIStepper!
    @IBOutlet weak var numberOfSplit: UILabel!
    @IBOutlet weak var totalTax: UILabel!
    
    let TIP_PERCENTAGE = [0.15, 0.18, 0.2]
    let defaultSaleTax = 9.25
    var isResultHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segControlButtons.layer.cornerRadius = 4.0
        self.segControlButtons.clipsToBounds = true
        self.billField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resultView.center.x = self.view.bounds.width / 2
        if billField.text!.count == 0 {
            toggleResultDisplay(shown: false)
        }
        let defaults = UserDefaults.standard
        let defaultTip = defaults.double(forKey: "DEFAULT_TIP_PERCENTAGE")
        let index = TIP_PERCENTAGE.index(of: defaultTip)
        
        segControlButtons.selectedSegmentIndex = index == nil ? 0 : index!
        
        let lastTaxVal = defaults.double(forKey: "LAST_SALE_TAX")
        
        if lastTaxVal == 0 {
            defaults.set(defaultSaleTax, forKey: "LAST_SALE_TAX")
            defaults.synchronize()
            taxField.text = String(defaultSaleTax)
        } else {
            taxField.text = String(lastTaxVal)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
     }
    
    @IBAction func onBillFieldTouchDown(_ sender: Any) {
        if billField.text!.count == 0 {
            toggleResultDisplay(shown: false)
        }
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        self.calculate()
        
        if billField.text!.count > 0 {
             toggleResultDisplay(shown: true)
        }
        
    }
    
    
    @IBAction func onSegCtrlChange(_ sender: Any) {
        self.calculate()
        view.endEditing(true)
    }
    
    
    private func toggleResultDisplay(shown: Bool) {
        
        if shown && self.resultView.center.y > self.view.bounds.height{
            UIView.animate(withDuration: 0.5) {
                self.resultView.center.y -= self.view.bounds.height
                self.isResultHidden = false
            }
        } else if !shown && self.resultView.center.y < self.view.bounds.height {
            UIView.animate(withDuration: 0.5) {
                self.resultView.center.y += self.view.bounds.height
                self.isResultHidden = true
            }
        }
    }
    
    @IBAction func onSaleTaxChange(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        defaults.set(Double(taxField.text!), forKey: "LAST_SALE_TAX")
        defaults.synchronize()
        self.calculate()
    }
    @IBAction func onSplitStepperChange(_ sender: Any) {
        numberOfSplit.text = String(Int(friendSplit.value))
        self.calculate()
        view.endEditing(true)
    }
    @IBAction func onTipBeforeTaxSwitchChange(_ sender: Any) {
        self.calculate()
        view.endEditing(true)
    }
    
    private func calculate() {
        let tax = Double(taxField.text!) ?? 0
        let bill = Double(billField.text!) ?? 0
        let billAfterTax = bill * (100 + tax) / 100
        let tip: Double = (tipIncludeTax.isOn ? billAfterTax : bill) * TIP_PERCENTAGE[segControlButtons.selectedSegmentIndex]
        let total = (billAfterTax + tip) / friendSplit.value
        
        totalTax.text = "$" + String(format: "%.2f", tax);
        tipLabel.text = "$" + String(format: "%.2f", tip);
        totalLabel.text = "$" + String(format: "%.2f", total);
        
        if billField.text!.count > 0 {
            self.toggleResultDisplay(shown: true)
        }
    }
    
    
}

