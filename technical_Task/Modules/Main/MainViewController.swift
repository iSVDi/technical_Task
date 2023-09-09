//
//  MainViewController.swift
//  technical_Task
//
//  Created by Daniil on 07.09.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func commonInit() {
        applyDefaultSettings()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let label = ViewsFactory.defaultLabel(textColor: .appWhite)
        //TODO: localize
        label.text = "Главный экран"
        let leftBarButton = UIBarButtonItem(customView: label)
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        
        let rightBarButton = UIBarButtonItem(image: AppImage.settings.uiImageWith(tint: .appWhite), style: .plain, target: self, action: #selector(rightBarButtonHandler))
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        applyTransparentAppearance(color: .appSystemBlue)
        
    }
    
    // MARK: - Handlers
    
    @objc
    private func rightBarButtonHandler() {
        let settings = SettingsViewController()
        pushViewController(settings)
    }
    
}
