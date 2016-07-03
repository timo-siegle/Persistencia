//
//  DetailViewController.swift
//  Persistencia
//
//  Created by Timo Siegle on 02.07.16.
//  Copyright © 2016 Timo Siegle. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var book : Libro2!
    
    @IBOutlet weak var isbn: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var autores: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        
        isbn.text = book.isbn
        titulo.text = book.titulo
        autores.text = book.autores.joinWithSeparator(", ")
        imagen.image = book.imagen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
