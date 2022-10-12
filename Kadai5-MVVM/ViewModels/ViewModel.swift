//
//  ViewModel.swift
//  Kadai5-MVVM
//
//  Created by 近藤米功 on 2022/10/12.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

// MARK: - Inputs
protocol ViewModelInputs {
    var number1TextFieldObservable: Observable<String> { get }
    var number2TextFieldObservable: Observable<String> { get }
    var calcButtonTapObservable: Observable<Void> { get }
}

// MARK: - Outputs
protocol ViewModelOutputs {
    var calcResultPublishRelay: PublishRelay<String> { get }
}

// MARK: - Type
protocol ViewModelType {
    var inputs: ViewModelInputs { get }
    var outputs: ViewModelOutputs { get }
}

class ViewModel: ViewModelInputs, ViewModelOutputs {

    // MARK: - Inputs
    var number1TextFieldObservable: RxSwift.Observable<String>
    var number2TextFieldObservable: RxSwift.Observable<String>
    var calcButtonTapObservable: RxSwift.Observable<Void>

    // MARK: - Outputs
    var calcResultPublishRelay = RxRelay.PublishRelay<String>()

    let calculator = Calculator()

    private let disposedBag = DisposeBag()

    private var number1: Int?
    private var number2: Int?
    private var calcResult = Double()

    init(number1TextFieldObservable: Observable<String>,
         number2TextFieldObservable: Observable<String>, calcButtonTapObservable: Observable<Void>){
        self.number1TextFieldObservable = number1TextFieldObservable
        self.number2TextFieldObservable = number2TextFieldObservable
        self.calcButtonTapObservable = calcButtonTapObservable
        setupBindings()
    }

    private func setupBindings() {
        let totalInput = Observable.combineLatest(number1TextFieldObservable, number2TextFieldObservable)

        totalInput.subscribe { number1,number2 in
            self.number1 = Int(number1) ?? nil
            self.number2 = Int(number2) ?? nil
        }.disposed(by: disposedBag)

        calcButtonTapObservable.subscribe (onNext: { _ in

            if(self.number1 == nil) {
                self.calcResultPublishRelay.accept(AlertType.number1IsNil.rawValue)
            }else if (self.number2 == nil) {
                self.calcResultPublishRelay.accept(AlertType.number2IsNil.rawValue)
            }else if (self.number2 == 0) {
                self.calcResultPublishRelay.accept(AlertType.number2IsZero.rawValue)
            }else{
                guard let number1 = self.number1, let number2 = self.number2 else { return }
                self.calcResult = self.calculator.divi(number1: number1, number2: number2)
                self.calcResultPublishRelay.accept(String(self.calcResult))
            }
        }).disposed(by: disposedBag)
    }


}

// MARK: - ViewModelType
extension ViewModel: ViewModelType {
    var inputs: ViewModelInputs { return self }

    var outputs: ViewModelOutputs { return self }
}


