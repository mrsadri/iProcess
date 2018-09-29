//: Playground - noun: a place where people can play

import UIKit

class Processor {
    
    init(inputImage:UIImage) {
        getAverageRGB(myImage: inputImage)
        myRGBImageContrastModified = RGBAImage.init(image: UIImage(named: "ImageStory")!)
    }
    
    func UInt8ToInt (input : UInt8) -> Int {
        
        //UInt8ToHashValue
        let newInput = (input.hashValue)
        
        //hashValueToInt
        var returner : Int = newInput
        if newInput < 0 {
            returner = 256 + newInput
        }
        return returner
    }
    var redAvr   : Int = 0
    var greenAvr : Int = 0
    var blueAvr  : Int = 0
    var counter  : Int = 0
    var myRGBImage : RGBAImage? = nil
    var myRGBImageContrastModified : RGBAImage? = nil
    
    private func getAverageRGB(myImage: UIImage) {//}-> (Red: Int, Green: Int, Blue: Int) {
        
        redAvr      = 0
        blueAvr     = 0
        greenAvr    = 0
        counter     = 0
        
        self.myRGBImage = RGBAImage.init(image: myImage)
        let Jumper : Int = Int(pow(Double(((myRGBImage?.width)! * (myRGBImage?.height)!)/1000), 0.5))
        
        for i in 1...((myRGBImage?.width)!/Jumper) {
            let x = (i-1) * Jumper
            for j in 1...((myRGBImage?.height)!/Jumper) {
                let y       = (j-1) * Jumper
                let index   = y * (myRGBImage?.width)! + x
                var pixelR  = myRGBImage?.pixels[index]
                redAvr      = UInt8ToInt(input: (pixelR?.red)!)   + redAvr
                greenAvr    = UInt8ToInt(input: (pixelR?.green)!) + greenAvr
                blueAvr     = UInt8ToInt(input: (pixelR?.blue)!)  + blueAvr
                counter += 1
            }
        }
        
        redAvr   /= counter
        greenAvr /= counter
        blueAvr  /= counter
    }
    
    var iRed    = 255
    var iGreen  = 255
    var iBlue   = 255
    
    var iRedRange   : (min: Int, max:Int)? = nil
    var iGreenRange : (min: Int, max:Int)? = nil
    var iBlueRange  : (min: Int, max:Int)? = nil
    
    func imageModifier (redSpectrum: Float, greenSpectrum: Float,blueSpectrum: Float, contrastSpectrum : Float) -> UIImage{
        let myRGBImageNew = RGBAImage.init(image: UIImage(named: "ImageStory")!)
        //
        let i : Float = abs( contrastSpectrum - 0.5) * 2
        if contrastSpectrum >= 0.5 {
            iRedRange    = (min:0, max:255)
            iGreenRange  = (min:0, max:255)
            iBlueRange   = (min:0, max:255)
            
        } else {
            iRedRange    = (min:redAvr  , max: redAvr  )
            iGreenRange  = (min:greenAvr, max: greenAvr)
            iBlueRange   = (min:blueAvr , max: blueAvr )
        }
        
        if redSpectrum   <= 0.5 {  iRed   = 0 } else {  iRed   = 255 }
        if greenSpectrum <= 0.5 {  iGreen = 0 } else {  iGreen = 255 }
        if blueSpectrum  <= 0.5 {  iBlue  = 0 } else {  iBlue  = 255 }
        
        for iIndex in 0..<(myRGBImageNew?.width)! {
            for jIndex in 0..<(myRGBImageNew?.height)! {
                let index = jIndex * (myRGBImageNew?.width)! + iIndex
                var pixel = myRGBImageNew?.pixels[index]
                
                let red     = UInt8ToInt(input: (myRGBImage?.pixels[index].red  )!)
                let green   = UInt8ToInt(input: (myRGBImage?.pixels[index].green)!)
                let blue    = UInt8ToInt(input: (myRGBImage?.pixels[index].blue )!)
                
                let aRed    = 2 * (redSpectrum   - 0.5)
                let aGreen  = 2 * (greenSpectrum - 0.5)
                let aBlue   = 2 * (blueSpectrum  - 0.5)
                
                pixel?.red    =  UInt8( Float(red  ) + Float (iRed   - red  ) * Float(abs(aRed  )) )
                pixel?.green  =  UInt8( Float(green) + Float (iGreen - green) * Float(abs(aGreen)) )
                pixel?.blue   =  UInt8( Float(blue ) + Float (iBlue  - blue ) * Float(abs(aBlue )) )
                
                myRGBImageNew?.pixels[index] = pixel!
            }
        }
        
        for iIndex in 0..<(myRGBImageNew?.width)! {
            for jIndex in 0..<(myRGBImageNew?.height)! {
                let index = jIndex * (myRGBImageNew?.width)! + iIndex
                var pixel = myRGBImageNew?.pixels[index]
                
                let red     = UInt8ToInt(input: (myRGBImageNew?.pixels[index].red  )!)
                let green   = UInt8ToInt(input: (myRGBImageNew?.pixels[index].green)!)
                let blue    = UInt8ToInt(input: (myRGBImageNew?.pixels[index].blue )!)
                
                if red > redAvr {
                    pixel?.red =  UInt8( Float(red) + Float ((iRedRange?.max)! - red) * i)
                } else {
                    pixel?.red =  UInt8( Float(red) + Float ((iRedRange?.min)! - red) * i)
                }
                
                if green > greenAvr {
                    pixel?.green =  UInt8( Float(green) + Float ((iRedRange?.max)! - green) * i)
                } else {
                    pixel?.green =  UInt8( Float(green) + Float ((iRedRange?.min)! - green) * i)
                }
                if blue > blueAvr {
                    pixel?.blue =  UInt8( Float(blue) + Float ((iRedRange?.max)! - blue) * i)
                } else {
                    pixel?.blue =  UInt8( Float(blue) + Float ((iRedRange?.min)! - blue) * i)
                }
               myRGBImageNew?.pixels[index] = pixel!
            }
        }
        return (myRGBImageNew?.toUIImage())!
    }
}
