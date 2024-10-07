//
//  ViewController.swift
//  BozaSoundBoard
//
//  Created by Nilda Boza on 7/10/24.
//

import UIKit
import CoreData
import AVFoundation
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Conexión del TableView
    @IBOutlet weak var tablaGrabaciones: UITableView!
    
    // Arreglo vacío de objetos de tipo Grabacion
    var grabaciones: [Grabacion] = []
    var reproducirAudio:AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Asignar el delegado y el dataSource al TableView
        tablaGrabaciones.dataSource = self
        tablaGrabaciones.delegate = self
    }
    
    // Número de filas en la sección
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grabaciones.count
    }
    
    // Llenar el TableView con la lista de grabaciones
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let grabacion = grabaciones[indexPath.row]
        cell.textLabel?.text = grabacion.nombre
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grabacion = grabaciones[indexPath.row]
        do {
            reproducirAudio = try AVAudioPlayer(data: grabacion.audio! as Data)
            reproducirAudio?.play()
        } catch {
            print("Error al reproducir el audio")
        }
        
        // Deseleccionar la fila después de que se ha hecho clic
        tablaGrabaciones.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let grabacion = grabaciones[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(grabacion)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                grabaciones = try context.fetch(Grabacion.fetchRequest())
                tablaGrabaciones.reloadData()
            } catch {
                // Manejo de error
            }
        }
    }

    // Cargar las grabaciones cuando la vista aparece
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            grabaciones = try context.fetch(Grabacion.fetchRequest())
            tablaGrabaciones.reloadData()
        } catch {
            print("Error al cargar grabaciones")
        }
    }
}

