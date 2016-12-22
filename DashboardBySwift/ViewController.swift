//
//  ViewController.swift
//  DashboardBySwift
//
//  Created by 储诚鹏 on 16/12/21.
//  Copyright © 2016年 RUIYI. All rights reserved.
//

import UIKit

extension UIViewController {
    var bounds : CGRect {
        get {
            return view.bounds
        }
    }
}

extension UIColor {
    class func CG_COLOR(颜色数组 values : Array<CGFloat>) -> CGColor {
        let r = values[0]
        let g = values[1]
        let b = values[2]
        let a = values[3]
        return UIColor.init(red: r, green: g, blue: b, alpha: a).cgColor
    }
}

class ViewController: UIViewController {
    var progressLayer : CAShapeLayer?
    var aLabel : UILabel?
    var isContaint : Bool?
    var needleLayer : CAShapeLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        isContaint = false
        self.drawProgressLayer()
        self.drawGradientLayer()
        self.drawScale()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //根据半径画圆
    func drawCurve(Radius r : CGFloat) -> CAShapeLayer {
        let path = UIBezierPath.init(arcCenter: view.center, radius: r, startAngle: -(CGFloat)(M_PI), endAngle: 0, clockwise: true)
        let curve = CAShapeLayer.init()
        curve.lineWidth = 5.0
        curve.fillColor = UIColor.clear.cgColor
        curve.strokeColor = UIColor.white.cgColor
        curve.path = path.cgPath
        return curve
    }
    
    //进度图层
    func drawProgressLayer() {
        let outArc = self.drawCurve(Radius: 147.5)
        let inArc = self.drawCurve(Radius: 82.5)
        view.layer.addSublayer(outArc)
        view.layer.addSublayer(inArc)
        let progressPath = UIBezierPath.init(arcCenter: view.center, radius: 115, startAngle: -(CGFloat)(M_PI), endAngle: 0, clockwise: true)
        progressLayer = CAShapeLayer()
        progressLayer?.lineWidth = 60.0
        progressLayer?.fillColor = UIColor.clear.cgColor
        progressLayer?.strokeColor = UIColor.white.cgColor
        progressLayer?.strokeStart = 0
        progressLayer?.strokeEnd = 0.5
        progressLayer?.path = progressPath.cgPath
        view.layer.addSublayer(progressLayer!)
    }
    
    //渐变图层
    func drawGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.CG_COLOR(颜色数组: [0.09,0.58,0.15,1.00]),UIColor.CG_COLOR(颜色数组: [0.20,0.63,0.25,1.00]),UIColor.CG_COLOR(颜色数组: [0.60,0.82,0.22,1.00]),UIColor.CG_COLOR(颜色数组: [0.97,0.65,0.22,1.00]),UIColor.CG_COLOR(颜色数组: [0.96,0.08,0.10,1.00])]
        gradientLayer.locations = [0,0.25,0.5,0.75,1.0]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        gradientLayer.mask = progressLayer
        view.layer.addSublayer(gradientLayer)
        
    }
    
    //刻度
    func drawScale() {
        let perAngle : CGFloat = CGFloat(M_PI) / 50
        let calWidth : CGFloat = perAngle / 5
        for i in 0...50 {
            let startAngel = CGFloat(-M_PI) + perAngle*CGFloat(i)
            let endAngel = startAngel + calWidth
            let tickPath = UIBezierPath.init(arcCenter: view.center, radius: 140, startAngle: startAngel, endAngle: endAngel, clockwise: true)
            let perLayer = CAShapeLayer()
            if i % 5 == 0 {
                perLayer.strokeColor = UIColor.white.cgColor
                perLayer.lineWidth = 10.0
                let point = self.calculateTextPosition(center: view.center, angle: -startAngel)
                let calibrationLabel = UILabel.init(frame: CGRect.init(x: point.x - 10, y: point.y - 10, width: 20, height: 20))
                calibrationLabel.text = String.init(format: "%d", i * 2)
                calibrationLabel.font = UIFont.systemFont(ofSize: 10)
                calibrationLabel.textColor = UIColor.white
                calibrationLabel.textAlignment = .center
                view.addSubview(calibrationLabel)
            }
            else {
                perLayer.strokeColor = UIColor.CG_COLOR(颜色数组: [0.22,0.66,0.87,1.0])
                perLayer.lineWidth = 5
            }
            perLayer.path = tickPath.cgPath
            view.layer.addSublayer(perLayer)
        }
        
        needleLayer = CAShapeLayer()
        needleLayer?.fillColor = UIColor.white.cgColor
        needleLayer?.lineWidth = 1.0
        needleLayer?.strokeColor = UIColor.clear.cgColor
        view.layer.addSublayer(needleLayer!)
        self.showDataLabel()
        self.drawNeedle(progressValue: 0.5)
    }
    
    func drawNeedle(progressValue value:CGFloat) {
        let centerCircle = UIBezierPath.init(arcCenter: view.center, radius: 20, startAngle: CGFloat(-M_PI / 16), endAngle: CGFloat(17 / 16 * M_PI), clockwise: false)
        let centerCircleLayer = CAShapeLayer()
        centerCircleLayer.strokeColor = UIColor.white.cgColor
        centerCircleLayer.lineWidth = 3.0
        centerCircleLayer.path = centerCircle.cgPath
        centerCircleLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(centerCircleLayer)
        let angel = CGFloat(M_PI) * (1 - value)
        let leewayX : CGFloat = CGFloat(2 * sinf(Float(angel)))
        var leewayY : CGFloat = CGFloat(2 * cosf(Float(angel)))
        if (value <= 0.05) || (value >= 0.95) {
            leewayY = 1
        }
        let startPX = CGFloat(20 * cosf(Float(angel))) + view.center.x
        let startPY = CGFloat(-20*sinf(Float(angel))) + view.center.y
        let startPX1 = startPX - leewayX
        let startPX2 = startPX + leewayX
        let startPY1 = startPY - leewayY
        let startPY2 = startPY + leewayY
        let endPX = CGFloat(120 * cosf(Float(angel))) + view.center.x
        let endPY = CGFloat(-120 * sinf(Float(angel))) + view.center.y
        let needlePath = UIBezierPath.init()
        needlePath.move(to: CGPoint.init(x: startPX1, y: startPY1))
        needlePath.addLine(to: CGPoint.init(x: endPX, y: endPY))
        needlePath.addLine(to: CGPoint.init(x: startPX2, y: startPY2))
        needleLayer?.path = needlePath.cgPath
    }
    
    //计算label位置
    func calculateTextPosition(center:CGPoint,angle:CGFloat) -> CGPoint {
        let calRadius:Float = 125.0
        let x = calRadius * cosf(Float(angle))
        let y = calRadius * sinf(Float(angle))
        return CGPoint.init(x: CGFloat(x) + center.x, y: -CGFloat(y) + center.y)
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        progressLayer?.strokeEnd = CGFloat(sender.value)
        self.drawNeedle(progressValue: CGFloat(sender.value))
        self.displayShowLabel(sliderP: CGFloat(sender.value))
    }
    
    func showDataLabel() {
        aLabel = UILabel.init(frame: CGRect.init(x: 0, y: view.center.y + 20, width: self.bounds.size.width, height: 50))
        aLabel?.textColor = UIColor.white
        aLabel?.text = "0"
        aLabel?.font = UIFont.boldSystemFont(ofSize: 35)
        aLabel?.textAlignment = .center
        view.addSubview(aLabel!)
        self.displayShowLabel(sliderP: 0.5)
    }
    
    func displayShowLabel(sliderP progress:CGFloat) {
        let numberS : String = String.init(format: "%.2f", progress*100)
        aLabel?.text = numberS
    }

}

