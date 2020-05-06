//
//  ViewController.swift
//  Cat VS Dog
//
//  Created by Garima Bothra on 05/05/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Create outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var loverLabel: UILabel!
    @IBOutlet weak var numbersLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //Labels and NavBar should be updated everytime the view is presented
    override func viewDidAppear(_ animated: Bool) {
        setupNavBar()
        updateLabels()
    }

    //Function to setup Navigation Bar
    func setupNavBar() {
        navigationItem.title = "PET LOVERS"
        navigationItem.rightBarButtonItem = cameraButton
        navigationItem.leftBarButtonItem?.isEnabled = false;
        navigationItem.hidesBackButton = true
    }

    //Function to update labels according to model output
    func updateLabels() {
        let catCount = UserDefaults.standard.integer(forKey: "catCount")
        let dogCount = UserDefaults.standard.integer(forKey: "dogCount")
        numbersLabel.text = "\(catCount) Cats V/S \(dogCount) Dogs"
        if(catCount > dogCount){
            loverLabel.text = "CAT LOVER!"
        }
        else if(dogCount > catCount){
            loverLabel.text = "DOG LOVER!"
        }
        else{
            loverLabel.text = "PET LOVER!"
        }
    }

    //Function to present camera view when the camera button is pressed
    @IBAction func cameraButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCam", sender: Any.self)
    }


}

