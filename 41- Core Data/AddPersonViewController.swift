//
//  AddPersonViewController.swift
//  41- Core Data
//
//  Created by Barış Sucuoğlu on 22.03.2024.
//

import UIKit
import SnapKit
import CoreData

protocol AddPersonDelegate: AnyObject {
    func didAddPerson()
}

class AddPersonViewController: UIViewController {

    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let ageTextField = UITextField()
    let emailTextField = UITextField()
    let birthplaceTextField = UITextField()
    let saveButton = UIButton()
    
    weak var delegate: AddPersonDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        title = "Add Person"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .white

        firstNameTextField.placeholder = "First Name"
        firstNameTextField.borderStyle = .roundedRect
        view.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }

        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.borderStyle = .roundedRect
        view.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(firstNameTextField)
        }

        ageTextField.placeholder = "Age"
        ageTextField.borderStyle = .roundedRect
        view.addSubview(ageTextField)
        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(firstNameTextField)
        }

        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(ageTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(firstNameTextField)
        }

        birthplaceTextField.placeholder = "Birthplace"
        birthplaceTextField.borderStyle = .roundedRect
        view.addSubview(birthplaceTextField)
        birthplaceTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(firstNameTextField)
        }

        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .orange
        saveButton.layer.cornerRadius = 15
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(birthplaceTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
    }
    @objc func emailTextFieldDidChange(_ textField: UITextField) {
            textField.text = textField.text?.lowercased()
        }

    @objc func saveButtonTapped() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(firstNameTextField.text ?? "", forKeyPath: "firstName")
        person.setValue(lastNameTextField.text ?? "", forKeyPath: "lastName")
        person.setValue(Int(ageTextField.text ?? "") ?? 0, forKeyPath: "age")
        person.setValue(emailTextField.text ?? "", forKeyPath: "email")
        person.setValue(birthplaceTextField.text ?? "", forKeyPath: "birthplace")
        
        do {
                try managedContext.save()
                delegate?.didAddPerson()
                showAlert()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }

        func showAlert() {
            let alert = UIAlertController(title: "Success", message: "Data saved successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
}

