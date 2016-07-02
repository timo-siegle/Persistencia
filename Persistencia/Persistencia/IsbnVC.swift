//
//  IsbnVC.swift
//  Persistencia
//
//  Created by Timo Siegle on 02.07.16.
//  Copyright © 2016 Timo Siegle. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class IsbnVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var input: UITextField!
    
    var book: Libro!
    var bookSource: MasterViewController!
    var contexto: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        (segue.destinationViewController as! DetailViewController).book = self.book
    }
    
    func fetchBookDetails(isbn: String) -> Libro? {
        
        var titulo = ""
        var portada = UIImage()
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = NSURL(string: urls)
        let datos = NSData(contentsOfURL: url!)
        
        if datos == nil {
            // En caso de falla en Internet, se muestra una alerta indicando ese problema
            let alertController = UIAlertController(title: "Internet connection", message:
                "Please check your connection and try again!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let dico1 = json as! NSDictionary
                if dico1.allKeys.count > 0 {
                    let dico2 = dico1["ISBN:\(isbn)"] as! NSDictionary
                    titulo = dico2["title"] as! NSString as String
                    
                    if dico2["cover"]?.count > 0 {
                        let dico3 = dico2["cover"] as! NSDictionary
                        let portadaString = dico3["large"] as! NSString as String
                        
                        let portadaUrl = NSURL(string: portadaString)
                        let portadaData = NSData(contentsOfURL: portadaUrl!)
                        portada = UIImage(data: portadaData!)!
                    }
                    
                    var autores: [String] = []
                    if dico2["authors"]?.count > 0 {
                        let dico4 = dico2["authors"] as! NSArray
                        for item in dico4 {
                            let obj = item as! NSDictionary
                            let name = obj["name"] as! NSString as String
                            autores.append(name)
                        }
                    }
                    
                    return Libro(isbn: isbn, titulo: titulo, autores: autores, imagen: portada)
                }
            } catch {
                print("Error info: \(error)")
            }
        }
        return nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if let isbn = textField.text where !isbn.isEmpty {
            if let book = bookSource.books.filter({$0.isbn == isbn}).first {
                self.book = book
                performSegueWithIdentifier("segueDetail", sender: textField)
                
            } else {
                if let result = fetchBookDetails(isbn) {
                    
                    let nuevaLibroEntidad = NSEntityDescription.insertNewObjectForEntityForName("Libro", inManagedObjectContext: contexto!)
                    nuevaLibroEntidad.setValue(result.isbn, forKey: "isbn")
                    nuevaLibroEntidad.setValue(result.titulo, forKey: "titulo")
                    nuevaLibroEntidad.setValue(UIImagePNGRepresentation(result.imagen), forKey: "imagen")
                    nuevaLibroEntidad.setValue(creaAutoresEntidad(result.autores!), forKey: "tiene")
                    
                    self.book = result
                    self.bookSource.books.append(result)
                    
                    performSegueWithIdentifier("segueDetail", sender: textField)
                } else {
                    let alertController = UIAlertController(title: "Wrong ISBN", message:
                        "Please enter a valid ISBN and try again!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return false
                }
            }
        } else {
            let alertController = UIAlertController(title: "Missing ISBN", message:
                "Please enter a ISBN and try again!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func creaAutoresEntidad(autores: [String]) -> Set<NSObject> {
        
        var entidades = Set<NSObject>()
        for autor in autores {
            let autorEntidad = NSEntityDescription.insertNewObjectForEntityForName("Autor", inManagedObjectContext: self.contexto!)
            autorEntidad.setValue(autor, forKey: "nombre")
            entidades.insert(autorEntidad)
        }
        return entidades
    }
}
