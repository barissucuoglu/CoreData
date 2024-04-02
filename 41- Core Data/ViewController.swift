//
//  ViewController.swift
//  41- Core Data
//
//  Created by Barış Sucuoğlu on 22.03.2024.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController, AddPersonDelegate {
    
    func didAddPerson() {
            fetchPeople()
            tableView.reloadData()
        }

    let tableView = UITableView()
    var people = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPeople()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func setupUI() {
        title = "People List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func addButtonTapped() {
        let addPersonVC = AddPersonViewController()
        addPersonVC.delegate = self
        navigationController?.pushViewController(addPersonVC, animated: true)
    }

    func fetchPeople() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")

        do {
            people = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(person.value(forKeyPath: "firstName") ?? "") \(person.value(forKeyPath: "lastName") ?? "")"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.person = person
        navigationController?.pushViewController(detailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let personToRemove = self.people[indexPath.row]
            self.deletePerson(personToRemove: personToRemove, at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deletePerson(personToRemove: NSManagedObject, at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(personToRemove)
        do {
            try managedContext.save()
            self.people.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
