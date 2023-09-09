//
//  SettingsViewController.swift
//  technical_Task
//
//  Created by Daniil on 09.09.2023.
//

import UIKit
import TinyConstraints

class SettingsViewController: UIViewController {
    
    private let tableView = ViewsFactory.defaultTableView()
    private let settings = SettingPreferenceManager()
    private lazy var sections = settings.sectionsOrder
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func commonInit() {
        setupNavigationBar()
        setupViews()
    }
    
    // TODO: change color of back chevron, localize
    private func setupNavigationBar() {
        
        navigationItem.title = "Настройки"
        navigationController?.navigationBar.barTintColor = .appWhite
        applyTransparentAppearance(color: .appSystemBlue, tintColor: .appWhite)
        
        let rightBarButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(rightBarButtonHandler))
        rightBarButton.tintColor = .appWhite
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
        tableView.backgroundColor = .appBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.isEditing = true
    }
    
    @objc
    private func rightBarButtonHandler() {
        settings.sectionsOrder = sections
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
 
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = sections[indexPath.row]
        cell.backgroundColor = .appSystemGray5
        let imageView = ViewsFactory.defaultImageView(contentMode: .scaleAspectFit, image: AppImage.lines.uiImageWith(tint: .appSystemGray))
        cell.accessoryView = imageView
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let fromId = sourceIndexPath.row
        let toId = destinationIndexPath.row
        sections.swapAt(fromId, toId)
        let isEnabled = settings.sectionsOrder != sections
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
}
