//
//  OnboardingDoneViewController.swift
//  FLINT
//
//  Created by 김호성 on 2026.01.19.
//

import UIKit

class OnboardingDoneViewController: BaseViewController<OnboardingDoneView> {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar(.init(left: .back))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
