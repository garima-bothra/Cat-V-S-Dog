//
//  ImageViewController.swift
//  Cat VS Dog
//
//  Created by Garima Bothra on 05/05/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    //Create outlets
    @IBOutlet weak var previewImageView: UIImageView!
    //Create variables
    var previewImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        // Do any additional setup after loading the view.
    }
    
    func setupImageView() {
        print(previewImage)
        self.previewImageView.image = previewImage
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
