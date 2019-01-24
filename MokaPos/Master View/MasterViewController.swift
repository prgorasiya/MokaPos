//
//  MasterViewController.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    private let topStackView = UIStackView()
    
    fileprivate lazy var optionsView: OptionsListViewController = self.buildFromStoryboard("Main")
    fileprivate lazy var cartView: CartViewController = self.buildFromStoryboard("Main")
    fileprivate lazy var itemsView: OptionsListViewController = self.buildFromStoryboard("Detail")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        
        let nav = UINavigationController(rootViewController: optionsView)
        nav.view.frame = optionsView.view.frame
        optionsView.title = "Library"
        addContentController(nav, to: topStackView)
        addContentController(cartView, to: topStackView)
        optionsView.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        topStackView.axis = axisForSize(size)
    }
    
    
    private func addContentController(_ child: UIViewController, to stackView: UIStackView) {
        
        addChild(child)
        stackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }
    
    
    private func removeContentController(_ child: UIViewController, from stackView: UIStackView) {
        
        child.willMove(toParent: nil)
        stackView.removeArrangedSubview(child.view)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    
    private func setupStackView() {
        
        topStackView.axis = axisForSize(view.bounds.size)
        topStackView.alignment = .fill
        topStackView.distribution = .fillEqually
        topStackView.spacing = 8.0
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topStackView)
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            topStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0), view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 8.0)
            ])
    }
    
    
    private func axisForSize(_ size: CGSize) -> NSLayoutConstraint.Axis {
        return size.width > size.height ? .horizontal : .vertical
    }
    
    
    private func buildFromStoryboard<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let identifier = String(describing: T.self)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Missing \(identifier) in Storyboard")
        }
        return viewController
    }
}


extension MasterViewController: OptionsListViewDelegate {
    func didSelectOptionAt(index: Int) {
        
    }
}

