//
//  MasterViewController.swift
//  Persistencia
//
//  Created by Timo Siegle on 02.07.16.
//  Copyright © 2016 Timo Siegle. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {
    
    var books = [Libro]()
    var contexto: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let libroEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        let peticion = libroEntidad?.managedObjectModel.fetchRequestTemplateForName("petLibros")
        do {
            let libroEntidades = try self.contexto?.executeFetchRequest(peticion!)
            for libro in libroEntidades! {
                let isbn = libro.valueForKey("isbn") as! String
                let titulo = libro.valueForKey("titulo") as! String
                let imagen = UIImage(data: libro.valueForKey("imagen") as! NSData)
                
                let autoreEntidades = libro.valueForKey("tiene") as! Set<NSObject>
                var autores: [String] = []
                for autor in autoreEntidades {
                    let nombre = autor.valueForKey("nombre") as! String
                    autores.append(nombre)
                }
                books.append(Libro(isbn: isbn, titulo: titulo, autores: autores, imagen: imagen!))
            }
        } catch {
            
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = books[indexPath.row].titulo
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueDetail" {
            (segue.destinationViewController as! DetailViewController).book = books[tableView.indexPathForSelectedRow!.row]
        } else if segue.identifier == "segueSearch" {
            (segue.destinationViewController as! IsbnVC).bookSource = self
        }
    }
}

