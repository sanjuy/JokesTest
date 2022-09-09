//
//  ViewModel.swift
//  Test
//
//  Created by sanju on 07/09/22.
//

import Foundation
import UIKit
import CoreData

class JokesViewModel{
    
    var jokesArray:[JokesModel] = []
    var jokeID:Int = 0
    
    init(){}
    
    func getAPICall(_ completionHandler: @escaping ()->Void){
        
        let url = "https://geek-jokes.sameerkumar.website/api?format=json"
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url,timeoutInterval: 20.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let json = jsonObject as! [String: String]
                    if let joke = json["joke"]{
                        
                        DispatchQueue.main.async {
                            self.saveJokeData(joke: joke)
                        }
                        let jokeData = JokesModel.init(joke: joke)
                        
                        self.jokesArray.count == 10 ? self.updateJokesList(jokeData: jokeData) : self.jokesArray.append(jokeData)
                        
                        
                        completionHandler()
                    }
                    
                } catch {
                    print(error)
                }
                
            }
        }.resume()
    }
    
   // MARK: - update jokes list....
    func updateJokesList(jokeData:JokesModel){
        switch self.jokeID{
        case 0:
            getDelete(0)
            jokeID = 1
        case 1:
            getDelete(1)
            jokeID = 2
        case 2:
            getDelete(2)
            jokeID = 3
        case 3:
            getDelete(3)
            jokeID = 4
        case 4:
            getDelete(4)
            jokeID = 5
        case 5:
            getDelete(5)
            jokeID = 6
        case 6:
            getDelete(6)
            jokeID = 7
        case 7:
            getDelete(7)
            jokeID = 8
        case 8:
            getDelete(8)
            jokeID = 9
        case 9:
            getDelete(9)
            jokeID = 0
        default:
            break
        }
        
        func getDelete(_ int:Int){
            DispatchQueue.main.async {
                self.deleteJokeData(obj: self.jokesArray[int])
            }
            jokesArray.remove(at: int)
            jokesArray.insert(jokeData, at: int)
        }
        
    }
    
    
    
    //MARK: -- save product data -=-=-
    func saveJokeData(joke:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "JokeData", in: managedContext)!
        let jk = NSManagedObject(entity: userEntity, insertInto: managedContext)
        jk.setValue(joke, forKeyPath: "joke")
        do {
            try managedContext.save()

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: --  getting products data from storage  -=-=-
    func getJokesData(_ completionHandler: @escaping () -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "JokeData")

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let obj = JokesModel.init(joke: data.value(forKey: "joke") as! String)

                if self.jokesArray.count <= 9{
                    self.jokesArray.append(obj)
                }
            }
            completionHandler()
            
        } catch {
            print("Failed")
        }
    }
    
    //MARK: --  function to delete product from local storage and product list  -=-=-
    func deleteJokeData(obj:JokesModel){
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
       let managedContext = appDelegate.persistentContainer.viewContext
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "JokeData")
        fetchRequest.predicate = NSPredicate(format: "joke = %@", obj.joke!)
       do{
           let test = try managedContext.fetch(fetchRequest)
           let objectToDelete = test[0] as! NSManagedObject
           managedContext.delete(objectToDelete)
           do{
               try managedContext.save()
               
           }catch{
               print(error)
           }
           
       }catch{
           print(error)
       }
   }
    
    
}
