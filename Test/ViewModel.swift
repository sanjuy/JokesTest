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
    
    
    init(){}
    
    func getAPICall(_ completionHandler: @escaping (String)->Void){
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
                        completionHandler(joke)
                    }
                    
                } catch {
                    print(error)
                }
                
            }
        }.resume()
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
    func getJokesData(_ completionHandler: @escaping (JokesModel) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "JokeData")

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let obj = JokesModel.init(joke: data.value(forKey: "joke") as! String)
                
                completionHandler(obj)
                
                
            }
            
            
            
        } catch {
            print("Failed")
        }
    }
    
    //MARK: --  function to delete product from local storage and product list  -=-=-
    func deleteJokeData(obj:JokesModel){
//        let data = self.jokesArray[indx]
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
