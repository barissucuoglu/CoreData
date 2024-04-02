//
//  DetailViewController.swift
//  41- Core Data
//
//  Created by Barış Sucuoğlu on 22.03.2024.
//

import UIKit
import SnapKit
import CoreData

class DetailViewController: UIViewController {
    var person: NSManagedObject?
    let nameLabel = UILabel()
    let ageLabel = UILabel()
    let emailLabel = UILabel()
    let birthplaceLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayPersonInfo()
    }

    func setupUI() {
        title = "Person Detail"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .white

        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }

        ageLabel.textAlignment = .center
        ageLabel.font = UIFont.boldSystemFont(ofSize: 25)
        view.addSubview(ageLabel)
        ageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
        }

        emailLabel.textAlignment = .center
        emailLabel.font = UIFont.boldSystemFont(ofSize: 25)
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ageLabel.snp.bottom).offset(20)
        }

        birthplaceLabel.textAlignment = .center
        birthplaceLabel.font = UIFont.boldSystemFont(ofSize: 25)
        view.addSubview(birthplaceLabel)
        birthplaceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
        }
    }

    func displayPersonInfo() {
        guard let person = person else {
            return
        }
        nameLabel.text = "\(person.value(forKeyPath: "firstName") ?? "") \(person.value(forKeyPath: "lastName") ?? "")"
        ageLabel.text = "Age: \(person.value(forKeyPath: "age") ?? "")"
        emailLabel.text = "Email: \(person.value(forKeyPath: "email") ?? "")"
        birthplaceLabel.text = "Birthplace: \(person.value(forKeyPath: "birthplace") ?? "")"
    }
}
