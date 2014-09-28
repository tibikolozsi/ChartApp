//
//  LineChartView.swift
//  ChartApp
//
//  Created by Tibi Kolozsi on 28/09/14.
//  Copyright (c) 2014 tibikolozsi. All rights reserved.
//

import UIKit

enum LineViewAnimationType {
    case LineViewAnimationTypeDraw
    case LineViewAnimationTypeFade
    case LineViewAnimationTypeNone
}

let kDefaultNumberOfItems = 10;
let kDefaultStep:CGFloat = 320.0/CGFloat(kDefaultNumberOfItems);
let kDefaultArrayOfPoints:Array<CGPoint> = [CGPoint(x:0.0, y:100),
                                            CGPoint(x:1.0*kDefaultStep, y: 300),
                                            CGPoint(x:2.0*kDefaultStep, y: 40),
                                            CGPoint(x:3.0*kDefaultStep, y: 120),
                                            CGPoint(x:4.0*kDefaultStep, y: 230),
                                            CGPoint(x:5.0*kDefaultStep , y: 200),
                                            CGPoint(x:6.0*kDefaultStep , y: 100),
                                            CGPoint(x:7.0*kDefaultStep , y: 20),
                                            CGPoint(x:8.0*kDefaultStep , y: 150),
                                            CGPoint(x:9.0*kDefaultStep , y: 300)];


@IBDesignable public class LineChartView: UIView, UIGestureRecognizerDelegate {
    // MARK: Inspectable properties
    
    // reference lines related properties
    @IBInspectable var enableReferenceLine: Bool = true
    @IBInspectable var enableReferenceFrame: Bool = true
    
    // graph line related properties
    @IBInspectable var lineAlpha: Float = 1.0
    @IBInspectable var lineColor: UIColor = UIColor.redColor()
    @IBInspectable var lineWidth:CGFloat = 1.0
    @IBInspectable public var bezierCurveIsEnabled: Bool = true
    @IBInspectable var animationType: LineViewAnimationType = LineViewAnimationType.LineViewAnimationTypeDraw
    @IBInspectable var animationTime: CGFloat = 0.0
    
    
    let topColor: UIColor = UIColor.redColor()
    let bottomColor: UIColor = UIColor.redColor()
    let xAxisBackgroundColor: UIColor = UIColor.redColor()
    let xAxisBackgroundColorAlpha: CGFloat = 1.0
    
    
    
    let startPoint: CGPoint = CGPointMake(0, 0)
    let endPoint: CGPoint = CGPointMake(0, 0)
    var nextPoint: CGPoint = CGPointMake(0, 0)
    var previousPoint: CGPoint = CGPointMake(0, 0)
    var values: Array<CGFloat> = [] {
        didSet {
            refreshPoints()
        }
    }
    var points: Array<CGPoint> = [] // calculated from values
    var arrayOfVerticalLineReferencePoints: Array<CGFloat> = []
    var arrayOfHorizontalLineReferencePoints: Array<CGFloat> = []
    
    @IBInspectable var dotSize:CGFloat = 5.0
    @IBInspectable var dotColor:UIColor = UIColor.blueColor()
    
    var previousOrientaion: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation;
    
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    // Colors
    //    let lineGradient: CGGradientRef
    
    
    
    
    //----- ALPHA -----//
    
    /// The line alpha
    
    let topAlpha: CGFloat = 1.0
    let bottomAlpha: CGFloat = 1.0
    
    //----- SIZE -----//
    
    /// The width of the line
    
    
    //----- BEZIER CURVE -----//
    
    
    //----- ANIMATION -----//
    
    
    
    
    //----- FRAME -----//
    let frameOffset: CGFloat = 0.0
    
    
    func tapHandler(){
        Logger.Log(className: NSStringFromClass(self.classForCoder))
    }
    
    func panHandler(){
        Logger.Log(className: NSStringFromClass(self.classForCoder))
    }
    
    func initGestureRecognizers() {
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(tapHandler()))
        self.tapGestureRecognizer.delegate = self
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector(panHandler()))
        self.panGestureRecognizer.delegate = self
        self.panGestureRecognizer.maximumNumberOfTouches = 1
        self.addGestureRecognizer(self.tapGestureRecognizer)
        self.addGestureRecognizer(self.panGestureRecognizer)

    }
    
    func refreshPoints() {
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        self.points = Array<CGPoint>()
        var step:CGFloat = CGFloat(self.frame.width)/CGFloat(self.values.count-1)
        for (index,value) in enumerate(values) {
            var pointToAdd = CGPoint(x: CGFloat(step)*CGFloat(index), y: value)
            println("pointToAdd:\(pointToAdd)")
            self.points.append(pointToAdd)
        }
        self.setNeedsDisplay()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        self.initGestureRecognizers()
        self.bezierCurveIsEnabled = false
        let diff = self.frame.width / 10
        
        for var i:CGFloat=0; i<=self.frame.width; i+=diff {
            self.arrayOfHorizontalLineReferencePoints.append(i)
            self.arrayOfVerticalLineReferencePoints.append(i)
        }
    }
    
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        self.initGestureRecognizers()
        self.backgroundColor = UIColor.clearColor()
    }
    
    func drawReferenceLines()  -> UIBezierPath {
        // Draw Reference Lines
        var referenceLinePath: UIBezierPath = UIBezierPath()
        referenceLinePath.lineCapStyle = kCGLineCapButt
        referenceLinePath.lineWidth = 0.7
        
        if (self.enableReferenceLine) {
            for pointX in self.arrayOfVerticalLineReferencePoints {
                var initialPoint:CGPoint = CGPointMake(pointX, self.frame.size.height - self.frameOffset)
                var finalPoint:CGPoint = CGPointMake(pointX, 0)
                referenceLinePath.moveToPoint(initialPoint)
                referenceLinePath.addLineToPoint(finalPoint)
            }
            
            
            
            if (self.arrayOfHorizontalLineReferencePoints.count > 0) {
                for pointY in self.arrayOfHorizontalLineReferencePoints {
                    var initialPoint:CGPoint = CGPointMake(0, pointY)
                    var finalPoint:CGPoint = CGPointMake(self.frame.size.width, pointY)
                    referenceLinePath.moveToPoint(initialPoint)
                    referenceLinePath.addLineToPoint(finalPoint)
                }
            }
            
            if (self.enableReferenceFrame) {
                referenceLinePath.moveToPoint(CGPointMake(0, self.frame.size.height - self.frameOffset))
                referenceLinePath.addLineToPoint(CGPointMake(self.frame.size.width, self.frame.size.height - self.frameOffset))
                
                referenceLinePath.moveToPoint(CGPointMake(0+self.lineWidth/4, self.frame.size.height - self.frameOffset))
                referenceLinePath.addLineToPoint(CGPointMake(0+self.lineWidth/4, 0))
            }
            referenceLinePath.closePath()
            
            referenceLinePath.lineWidth = self.lineWidth / 2
            referenceLinePath.strokeWithBlendMode(kCGBlendModeNormal, alpha: 1.0)
            
            if self.enableReferenceLine {
                var referenceLinePathLayer = CAShapeLayer()
                referenceLinePathLayer.frame = self.bounds
                referenceLinePathLayer.path = referenceLinePath.CGPath
                referenceLinePathLayer.opacity = self.lineAlpha/2.0
                referenceLinePathLayer.strokeColor = self.lineColor.CGColor
                referenceLinePathLayer.fillColor = nil
                referenceLinePathLayer.lineWidth = self.lineWidth/2
                self.layer.addSublayer(referenceLinePathLayer)
            }
        }
        return referenceLinePath
    }
    
    func drawLines() -> UIBezierPath {
                return drawLine()
    }
    
    override public func drawRect(rect: CGRect)
    {
        eraseLineView()
        refreshPoints()
        println("LineChartView.drawRect");
        println("brezier: \(self.bezierCurveIsEnabled)")

        var referenceLinesPath = self.drawReferenceLines()
        var line = self.drawLines()
        
        if self.animationTime == 0 {
            self.lineColor.set()
            line.lineWidth = self.lineWidth
            line.strokeWithBlendMode(kCGBlendModeNormal, alpha: CGFloat(self.lineAlpha))
            
            if self.enableReferenceLine {
                referenceLinesPath.lineWidth = self.lineWidth/2.0
                referenceLinesPath.strokeWithBlendMode(kCGBlendModeNormal, alpha: CGFloat(self.lineAlpha/2.0))
            }
        } else {
                var pathLayer: CAShapeLayer = CAShapeLayer()
                pathLayer.frame = self.bounds
                pathLayer.path = line.CGPath
                pathLayer.strokeColor = self.lineColor.CGColor
                pathLayer.fillColor = nil
                pathLayer.lineWidth = self.lineWidth
                pathLayer.lineJoin = kCALineJoinBevel
                pathLayer.lineCap = kCALineCapRound
                self.animateForLayer(pathLayer, animationType:LineViewAnimationType.LineViewAnimationTypeDraw, isAnimatingReferenceLine:true)
                self.layer.addSublayer(pathLayer)
        }
        drawDots()
    }
    
    func getCurvePoints(points: Array<CGPoint>, tension: Float = 0.5) -> Array<CGPoint> {
        var modPoints = points
        var curvePoints = Array<CGPoint>()
        let segments = 16
        if self.bezierCurveIsEnabled {
            // The algorithm needs a previous and a next point so we need to copy first and last element
            modPoints.insert(modPoints[0], atIndex: 0)
            modPoints.append(modPoints.last!)

            for var i:Int=1; i<modPoints.count-2; i++ {
                for var t:Int=0; t<=segments; t++ {
                    
                    var currentPont = modPoints[i]
                    var previousPoint = modPoints[i-1]
                    var nextPoint = modPoints[i+1]
                    var nextNextPoint = modPoints[i+2]
                    
                    // calculate tension vectors
                    var t1x:CGFloat = (CGFloat(nextPoint.x) - CGFloat(previousPoint.x))*CGFloat(tension)
                    var t2x:CGFloat = (CGFloat(nextNextPoint.x) - CGFloat(currentPont.x))*CGFloat(tension)
                    
                    var t1y:CGFloat = (CGFloat(nextPoint.y)-CGFloat(previousPoint.y))*CGFloat(tension)
                    var t2y:CGFloat = (CGFloat(nextNextPoint.y)-CGFloat(currentPont.y))*CGFloat(tension)
                    
                    // calculate step
                    var step:CGFloat = CGFloat(t) / CGFloat(segments)
                    
                    // calc cardinals
                    var pow3:CGFloat = CGFloat(powf(Float(step), 3.0))
                    var pow2:CGFloat = CGFloat(powf(Float(step), 2.0))
                    
                    var c1 =  2.0 * pow3 - 3.0 * pow2 + 1.0;
                    var c2 = -2.0 * pow3 + 3.0 * pow2;
                    var c3 = pow3 - 2.0 * pow2 + step;
                    var c4 = pow3 - pow2;
                
                    // calculate x and y coords with common control vectors
                    var x:CGFloat = c1 * currentPont.x + c2 * nextPoint.x + c3 * t1x + c4 * t2x;
                    var y:CGFloat = c1 * currentPont.y + c2 * nextPoint.y + c3 * t1y + c4 * t2y;
                    curvePoints.append(CGPoint(x:x, y:y))
                }
            }
        } else {
            for point in points {
                curvePoints.append(point)
            }
            
        }
        return curvePoints
    }
    
    func drawLine() -> UIBezierPath {
        var linePath = UIBezierPath()
        if(self.points.count > 2) {
            var curvePoints = getCurvePoints(self.points, tension: 0.5)
        

        linePath.moveToPoint(curvePoints[0])
        for p in curvePoints {
            linePath.addLineToPoint(p)
        }
            
        }
        return linePath
    }
    
    func animateForLayer(shapeLayer: CAShapeLayer, animationType:LineViewAnimationType, isAnimatingReferenceLine:Bool)
    {
        if (animationType == LineViewAnimationType.LineViewAnimationTypeNone) {
            return
        } else if (animationType == LineViewAnimationType.LineViewAnimationTypeFade) {
            var animation = CABasicAnimation(keyPath: "opacity")
            animation.duration = CFTimeInterval(self.animationTime)
            animation.fromValue = 0.0
            if (isAnimatingReferenceLine) {
                animation.toValue = self.lineAlpha/2.0
            } else {
                animation.toValue = self.lineAlpha
            }
            shapeLayer.addAnimation(animation, forKey: "opacity")
        } else {
            var animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = CFTimeInterval(self.animationTime)
            animation.fromValue = 0.0
            animation.toValue = 1.0
            shapeLayer.addAnimation(animation, forKey: "strokeEnd")
        }
    }
    
    public func addValueToLine(value:CGFloat) {
        self.values.append(value)
        self.setNeedsDisplay()
    }

    
    public override func prepareForInterfaceBuilder() {
        // provide sample data for Interface Builder
        let diff = self.frame.width / 10
        
        for var i:CGFloat=0; i<=self.frame.width; i+=diff {
            self.arrayOfHorizontalLineReferencePoints.append(i)
            self.arrayOfVerticalLineReferencePoints.append(i)
        }
        self.values = [0,100,30,180,10,200]
        drawDots()
    }
    
    func drawDots() {
        for point in points {
            var dot:DotView = DotView(frame: CGRect(x: 0, y: 0, width: self.dotSize, height: self.dotSize))
            dot.center = point
            dot.alpha = 0.0
            dot.value = point.y
            dot.color = self.dotColor
            self.addSubview(dot)
            
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                dot.alpha = 0.7
            })
        }
    }
    
    
    func eraseLineView() {
        self.layer.sublayers = nil
    }

}
