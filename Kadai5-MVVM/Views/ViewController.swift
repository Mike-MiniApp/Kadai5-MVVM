//
//  ViewController.swift
//  Kadai5-MVVM
//
//  Created by 近藤米功 on 2022/10/12.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class ViewController: UIViewController {

    @IBOutlet private weak var number1TextField: UITextField!
    @IBOutlet private weak var number2TextField: UITextField!
    @IBOutlet private weak var calcButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

