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

    // MARK: - UI Parts
    @IBOutlet private weak var number1TextField: UITextField!
    @IBOutlet private weak var number2TextField: UITextField!
    @IBOutlet private weak var calcButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!

    private lazy var viewModel = ViewModel(number1TextFieldObservable: number1TextField.rx.text.map{$0 ?? ""}.asObservable(),
                                           number2TextFieldObservable: number2TextField.rx.text.map{$0 ?? ""}, calcButtonTapObservable: calcButton.rx.tap.asObservable())

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.calcResultPublishRelay.subscribe { calcResult in
            let alertType = AlertType(rawValue: calcResult.element ?? "")
            switch alertType {
            case .number1IsNil:
                self.alert(message: calcResult.element ?? "")
            case .number2IsNil:
                self.alert(message: calcResult.element ?? "")
            case .number2IsZero:
                self.alert(message: calcResult.element ?? "")
            case .none:
                self.viewModel.calcResultPublishRelay.bind(to: self.resultLabel.rx.text).disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
    }

    private func alert(message: String) {
        let title = "課題5"
        let message = message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

