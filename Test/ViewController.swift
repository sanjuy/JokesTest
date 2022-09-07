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
    private var jokesArray:[JokesModel] = []
    weak var timer: Timer?
    var jokeID:Int = 0
    
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
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timerHandler(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func timerHandler(_ timer: Timer) {
        getRequest()
        
    }
    
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    
    func getStoredJokes(){
        viewModel?.getJokesData{ jokeObj in
            
            if self.jokesArray.count <= 9{
                self.jokesArray.append(jokeObj)
            }
            
            if self.jokesArray.count == 0{
                self.getRequest()
            }
            self.startTimer()
            
            DispatchQueue.main.async {
                self.jokeList?.reloadData()
            }
        }
    }
    

    func getRequest(){
        viewModel?.getAPICall { joke in
            DispatchQueue.main.async {
                self.viewModel?.saveJokeData(joke: joke)
            }
            
            let jokeData = JokesModel.init(joke: joke)
            if self.jokesArray.count == 10{
                self.updateJokesList(jokeData: jokeData)
            }else{
                self.jokesArray.append(jokeData)
            }
            
            DispatchQueue.main.async {
                self.jokeList?.reloadData()
            }
        }
    }
    
    
    
    func updateJokesList(jokeData:JokesModel){
        switch self.jokeID{
        case 0:
            self.jokesArray.remove(at: 0)
            self.jokesArray.insert(jokeData, at: 0)
            DispatchQueue.main.async {
                self.viewModel?.deleteJokeData(obj: self.jokesArray[0])
            }
            self.jokeID = 1
        case 1:
            self.jokesArray.remove(at: 1)
            self.jokesArray.insert(jokeData, at: 1)
            DispatchQueue.main.async {
                self.viewModel?.deleteJokeData(obj: self.jokesArray[1])
            }
            self.jokeID = 2
        case 2:
            self.jokesArray.remove(at: 2)
            self.jokesArray.insert(jokeData, at: 2)
            DispatchQueue.main.async {
                self.viewModel?.deleteJokeData(obj: self.jokesArray[2])
            }
            self.jokeID = 3
        case 3:
            self.jokesArray.remove(at: 3)
            self.jokesArray.insert(jokeData, at: 3)
            DispatchQueue.main.async {
                self.viewModel?.deleteJokeData(obj: self.jokesArray[3])
            }
            self.jokeID = 4
        case 4:
            self.jokesArray.remove(at: 4)
            self.jokesArray.insert(jokeData, at: 4)
            DispatchQueue.main.async {
                self.viewModel?.deleteJokeData(obj: self.jokesArray[4])
            }
            self.jokeID = 5
        case 5:
            self.jokesArray.remove(at: 5)
            self.jokesArray.insert(jokeData, at: 5)
            DispatchQueue.main.async {
                self.viewModel?.deleteJokeData(obj: self.jokesArray[5])
            }
            self.jokeID = 6
        case 6:
            self.jokesArray.remove(at: 6)
            self.jokesArray.insert(jokeData, at: 6)
            DispatchQueue.main.async {
                self.viewModel?.deleteJokeData(obj: self.jokesArray[6])
            }
            self.jokeID = 7
        case 7:
            self.jokesArray.remove(at: 7)
            self.jokesArray.insert(jokeData, at: 7)
            DispatchQueue.main.async {
                self.viewModel?.deleteJokeData(obj: self.jokesArray[7])
            }
            self.jokeID = 8
        case 8:
            self.jokesArray.remove(at: 8)
            self.jokesArray.insert(jokeData, at: 8)
            DispatchQueue.main.async {
                self.viewModel?.deleteJokeData(obj: self.jokesArray[8])
            }
            self.jokeID = 9
        case 9:
            self.jokesArray.remove(at: 9)
            self.jokesArray.insert(jokeData, at: 9)
            DispatchQueue.main.async {
                self.viewModel?.deleteJokeData(obj: self.jokesArray[9])
            }
            self.jokeID = 1
        default:
            break
        }
        
    }
    
    
}

// MARK: - table view datasource and delegates........

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokesCell")
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text = jokesArray[indexPath.row].joke
        cell?.selectionStyle = .none

        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


