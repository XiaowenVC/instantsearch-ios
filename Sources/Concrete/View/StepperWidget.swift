//
//  StepperWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

/// Widget that controls the Numeric value of attribute. Built on top of `UIStepper`.
/// + Remark: You must assign a value to the `attribute` property since the refinement table cannot operate without one. 
/// A FatalError will be thrown if you don't specify anything.
@objc public class StepperWidget: UIStepper, NumericControlViewDelegate, AlgoliaWidget {
    
    @IBInspectable public var attribute: String = Constants.Defaults.attribute
    @IBInspectable public var `operator`: String = Constants.Defaults.operatorNumericControl
    @IBInspectable public var inclusive: Bool = Constants.Defaults.inclusive
    
    @IBInspectable public var index: String = Constants.Defaults.index
    @IBInspectable public var variant: String = Constants.Defaults.variant
    
    // Note: can't have optional Float because IBInspectable have to be bridgable to objc
    // and value types optional cannot be bridged.
    public var clearValue: NSNumber = 0
    
    public var viewModel: NumericControlViewModelDelegate
    
    public override init(frame: CGRect) {
        viewModel = NumericControlViewModel()
        super.init(frame: frame)
        viewModel.view = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = NumericControlViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
    }
    
    public func set(value: NSNumber) {
        self.value = value.doubleValue
    }
    
    public func configureView() {
        addTarget(self, action: #selector(numericFilterValueChanged), for: .valueChanged)
        
        // We add the initial value of the slider to the Search
        viewModel.updateNumeric(value: NSNumber(value: value), doSearch: false)
    }
    
    @objc func numericFilterValueChanged() {
        viewModel.updateNumeric(value: NSNumber(value: value), doSearch: true)
    }
}
