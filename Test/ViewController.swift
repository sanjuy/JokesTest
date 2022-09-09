//
//  ViewController.swift
//  Test
//
//  Created by Sanju Kumar on 07/09/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private var jokeList:UITableView?
    weak var timer: Timer?
    var viewModel:JokesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = JokesViewModel()
        jokeList = UITableView()
        view.addSubview(jokeList!)
        jokeList?.translatesAutoresizingMaskIntoConstraints = false
        jokeList?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        jokeList?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        jokeList?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        jokeList?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        jokeList?.dataSource = self
        jokeList?.delegate = self
        jokeList?.register(UITableViewCell.self, forCellReuseIdentifier: "JokesCell")
        jokeList?.separatorStyle = .none
        getStoredJokes()

    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerHandler(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func timerHandler(_ timer: Timer) {
        getRequest()
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func getStoredJokes(){
        viewModel?.getJokesData{
            if self.viewModel?.jokesArray.count == 0{
                self.getRequest()
            }
            self.startTimer()
            DispatchQueue.main.async {
                self.jokeList?.reloadData()
            }
        }
    }

    func getRequest(){
        viewModel?.getAPICall {
            DispatchQueue.main.async {
                self.jokeList?.reloadData()
            }
        }
    }
}

// MARK: - table view datasource and delegates........
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.jokesArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokesCell")
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text = self.viewModel?.jokesArray[indexPath.row].joke
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


