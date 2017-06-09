//
//  SmartViewController.swift
//  CoreMLSample
//
//  Created by Bruno Rocha on 6/9/17.
//  Copyright © 2017 Bruno Rocha. All rights reserved.
//

import UIKit

protocol SmartViewController {
    associatedtype SmartView: UIView
}

extension SmartViewController where Self: UIViewController {
    var smartView: SmartView {
        guard let smartView = view as? SmartView else {
            fatalError("Expected this view controller's view to be of type \(SmartView.self) but got \(type(of: view))")
        }
        return smartView
    }
}
