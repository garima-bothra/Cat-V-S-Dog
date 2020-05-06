//
//  ImageViewController.swift
//  Cat VS Dog
//
//  Created by Garima Bothra on 05/05/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit
import CoreML

class ImageViewController: UIViewController {

    //Create outlets
    @IBOutlet weak var previewImageView: UIImageView!
    //Create variables
    var previewImage: UIImage!
    var model = classifier()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
    }

    //Function to present clicked image on screen
    func setupImageView() {
        self.previewImageView.image = previewImage
    }

    //Function to predict and present home screen when user confirms to use image
    @IBAction func predictItem(_ sender: Any) {

        getModelPrediction()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "home") as! ViewController
        self.navigationController!.pushViewController(homeViewController, animated: true) 
    }

    //Function to resize image to 64x64
    func resizedImageWith(image: UIImage) -> UIImage {
           let newSize = CGSize(width: 64,  height: 64)
           let rect = CGRect(x: 0, y: 0, width: 64, height: 64)
           UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
           image.draw(in: rect)
           let newImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return newImage!
       }

    //Function to predict using model and update the results
    func getModelPrediction() {
        let input = resizedImageWith(image: previewImage).pixelBuffer()
        let prediction = try? model.prediction(image: input!)
        for (_, value) in prediction!.output {
            if value == 0.0 {
                let catsCount = UserDefaults.standard.integer(forKey: "catCount") + 1
                    UserDefaults.standard.set(catsCount, forKey: "catCount")
            }
            else {
                let dogCount = UserDefaults.standard.integer(forKey: "dogCount") + 1
                UserDefaults.standard.set(dogCount, forKey: "dogCount")
            }
        }
    }
}
