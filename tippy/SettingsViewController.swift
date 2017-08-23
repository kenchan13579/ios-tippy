//
//  SettingsViewController.swift
//  tippy
//
//  Created by Leung Wai Chan on 8/13/17.
//  Copyright © 2017 Leung Wai Chan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let TIP_PERCENTAGE = [0.15, 0.18, 0.2]
    @IBOutlet weak var defaultTipsPercent: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let defaultTip = defaults.double(forKey: "DEFAULT_TIP_PERCENTAGE")
        
        let index = TIP_PERCENTAGE.index(of: defaultTip)
        
        defaultTipsPercent.selectedSegmentIndex = index == nil ? 0 : index!
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onDefaultTipChanged(_ sender: Any) {
        let defaults: UserDefaults = UserDefaults.standard
        let percent: Double = TIP_PERCENTAGE[defaultTipsPercent.selectedSegmentIndex]
        
        defaults.set(percent, forKey: "DEFAULT_TIP_PERCENTAGE")
        defaults.synchronize()
        
    }
    

}
