//
//  SettingsViewController.swift
//  technical_Task
//
//  Created by Daniil on 09.09.2023.
//

import UIKit
import TinyConstraints
import Combine

class SettingsViewController: UIViewController {
    
    private let tableView = ViewsFactory.defaultTableView()
    private let settings = SettingPreferenceManager()
    private lazy var sections = settings.sectionsOrder
    
    private let output: PassthroughSubject<[String], Never> = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    func transform() -> AnyPublisher<[String],Never> {
        return output.eraseToAnyPublisher()
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
        output.send(sections)
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
        let title: String = {
            guard let key = String.SectionsName.init(rawValue: sections[indexPath.row]) else {
                return ""
            }
            return ^key
        }()
        cell.textLabel?.text = title
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
        let item = sections[fromId]
        sections.remove(at: fromId)
        let toId = destinationIndexPath.row
        
        sections.insert(item, at: toId)
        
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
