//
//  ViewController.swift
//  iProcess
//
//  Created by MSadri on 9/27/18.
//  Copyright © 2018 MSadri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var object : Processor? = nil
    var spectrumPerformanceUp : (red:Float,green:Float,blue:Float, contrast: Float) = (red:0.5,green:0.5,blue:0.5, contrast : 0.5)
    var flag = false
    @IBOutlet weak var imageLeft: UIImageView!
    @IBOutlet weak var imageRight: UIImageView!

    @IBOutlet weak var contrastSpectrum: UISlider!
    @IBOutlet weak var redSpectrum: UISlider!
    @IBOutlet weak var greenSpectrum: UISlider!
    @IBOutlet weak var blueSpectrum: UISlider!
    @IBOutlet weak var brightnessSpectrum: UISlider!
    
    @IBAction func brightnessSpectAction(_ sender: UISlider) {
        let i : Float = sender.value > 0.5 ? 1 : 0
        let a = 2 * abs ( sender.value - 0.5 )
        var previousValue : Float = 0.5
        redSpectrum.setValue(  spectrumPerformanceUp.red   + (i - spectrumPerformanceUp.red  ) * a , animated: true)
        greenSpectrum.setValue(spectrumPerformanceUp.green + (i - spectrumPerformanceUp.green) * a , animated: true)
        blueSpectrum.setValue( spectrumPerformanceUp.blue  + (i - spectrumPerformanceUp.blue ) * a , animated: true)
        if abs(previousValue - sender.value) > 0.05 {
            imageRight.image = object?.imageModifier(redSpectrum: redSpectrum.value/1, greenSpectrum: greenSpectrum.value/1, blueSpectrum: blueSpectrum.value/1, contrastSpectrum: contrastSpectrum.value/1)
            previousValue = sender.value
        }
        
    }
    @IBAction func SpectrumAction(_ sender: UISlider) {
        
        switch sender.accessibilityIdentifier {
        case "RedID" :
            if abs(spectrumPerformanceUp.red - sender.value) > 0.05 {
                spectrumPerformanceUp.red = Float(Int(sender.value * 10)) / 10
                flag = true
            }
            break
        case "GreenID" :
            if abs(spectrumPerformanceUp.green - sender.value) > 0.05 {
                spectrumPerformanceUp.green = Float(Int(sender.value * 10)) / 10
                flag = true
            }
            break
        case "BlueID" :
            if abs(spectrumPerformanceUp.blue - sender.value) > 0.05 {
                spectrumPerformanceUp.blue = Float(Int(sender.value * 10)) / 10
                flag = true
            }
        case "ContrastID" :
            if abs(spectrumPerformanceUp.contrast - sender.value) > 0.05 {
                spectrumPerformanceUp.contrast = Float(Int(sender.value * 10) ) / 10
                flag = true
            }
            break
        default:
            flag = false
        }
        
        if flag {
            imageRight.image = object?.imageModifier(redSpectrum: spectrumPerformanceUp.red, greenSpectrum: spectrumPerformanceUp.green, blueSpectrum: spectrumPerformanceUp.blue, contrastSpectrum: spectrumPerformanceUp.contrast)
            //print(spectrumPerformanceUp)
            brightnessSpectrum.setValue(0.5, animated: true)
            flag = false
        }
        
    }
    @IBAction func applyButton(_ sender: UIButton) {
        //logLabel.text = object.getAverageRGB().SpeedUp
        //        imageRight.image = object.getAverageRGB(myImage: imageLeft.image!)
    }
    @IBOutlet weak var logLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLeft.image  = UIImage(named: "ImageStory")
        imageRight.image = UIImage(named: "ImageStory")
        object = Processor(inputImage: imageLeft.image!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// there are two ways here : call function by spectrum or by apply button
