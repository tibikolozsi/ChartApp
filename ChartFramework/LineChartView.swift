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
let kDefaultArrayOfPoints:Array<CGPoint> = [CGPoint(x:10.0, y:100),
                                            CGPoint(x:1.0*kDefaultStep, y: 300),
                                            CGPoint(x:2.0*kDefaultStep, y: 40),
                                            CGPoint(x:3.0*kDefaultStep, y: 120),
                                            CGPoint(x:4.0*kDefaultStep, y: 230),
                                            CGPoint(x:5.0*kDefaultStep , y: 200),
                                            CGPoint(x:6.0*kDefaultStep , y: 100),
                                            CGPoint(x:7.0*kDefaultStep , y: 20),
                                            CGPoint(x:8.0*kDefaultStep , y: 150),
                                            CGPoint(x:9.0*kDefaultStep , y: 300)];




@IBDesignable public class LineChartView: UIView, UIGestureRecognizerDelegate{
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
    @IBInspectable var animationTime: CGFloat = 0
    
    
    @IBInspectable let topColor: UIColor = UIColor.redColor()
    @IBInspectable let bottomColor: UIColor = UIColor.redColor()

    @IBInspectable var dotSize:CGFloat = 5.0
    @IBInspectable var dotColor:UIColor = UIColor.blueColor()

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
    
   
    let topAlpha: CGFloat = 1.0
    let bottomAlpha: CGFloat = 1.0
    
    let frameOffset: CGFloat = 0.0

    
    // Gesture recognizers
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    
    
    // Line when touching
    var touchLine: UIView = UIView()
    var touchLineColor: UIColor = UIColor.grayColor()
    var touchLineWidth: CGFloat = 1.0
    
    var closestDot:DotView!
    var dots:Array<DotView> = Array<DotView>()
    
    var lineLayer:CALayer = CALayer()
    
    // MARK: init methods
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(self.lineLayer)
        addTouchLineToView()
        
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        self.initGestureRecognizers()
        self.backgroundColor = UIColor.clearColor()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.addSublayer(self.lineLayer)
        
        addTouchLineToView()
        
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        self.initGestureRecognizers()
        self.bezierCurveIsEnabled = false
        let diff = self.frame.width / 10
        
        for var i:CGFloat=0; i<=self.frame.width; i+=diff {
            self.arrayOfHorizontalLineReferencePoints.append(i)
            self.arrayOfVerticalLineReferencePoints.append(i)
        }
    }
    
    func initGestureRecognizers() {
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapHandler:"))
        self.tapGestureRecognizer.delegate = self
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panHandler:"))
        self.panGestureRecognizer.delegate = self
        self.panGestureRecognizer.maximumNumberOfTouches = 1
        self.addGestureRecognizer(self.tapGestureRecognizer)
        self.addGestureRecognizer(self.panGestureRecognizer)
        
    }
    
    // MARK: Drawing methods
    
    override public func drawRect(rect: CGRect)
    {
        eraseLineView()
        refreshPoints()
//        //  TODO: fix it
//        var gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.frame
//        let arrayColors: NSArray = [self.topColor,self.bottomColor]
//        gradientLayer.colors = arrayColors
//        self.layer.addSublayer(gradientLayer)
        
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
            self.lineLayer.addSublayer(pathLayer)
        }
        drawDots()
    }
    
    func drawLine() -> UIBezierPath {
        var linePath = UIBezierPath()
        var modPoints = self.points
        if (self.points.count < 2) {
            return linePath
        }
        modPoints.insert(points.first!, atIndex: 0)
        modPoints.insert(points.last!, atIndex: points.count)
        linePath.moveToPoint(points.first!)
        for (index,point) in enumerate(modPoints) {
            if (index >= 1 && index < modPoints.count - 2) {
                var nextPoint:CGPoint = modPoints[index+1]
                var secondNextPoint:CGPoint = modPoints[index+2]
                var previousPoint:CGPoint = modPoints[index-1]
                
                if index == 1 {
                    previousPoint = CGPoint(x: point.x-(nextPoint.x-point.x), y: nextPoint.y)
                }
                if index == modPoints.count - 3 {
                    var diff:CGFloat = point.x-previousPoint.x
                    nextPoint = CGPoint(x: point.x+diff, y: nextPoint.y)
                    secondNextPoint = CGPoint(x: point.x + diff * 2.0, y:nextPoint.y)
                }
                
                
                var d1 = vectorLength(point - previousPoint)
                var d2 = vectorLength(nextPoint - point)
                var d3 = vectorLength(secondNextPoint - nextPoint)
                
                let falpha:Float = Float(0.8)
                var b1:CGPoint =  powf(Float(d1), Float(2.0)*falpha)*nextPoint
                b1 = b1 - powf(Float(d2), Float(2.0)*falpha) * previousPoint
                b1 = b1 + (2.0 * powf(Float(d1), Float(2.0)*falpha) + Float(3.0)*powf(Float(d1), falpha)*powf(Float(d2), falpha) + powf(Float(d2), 2.0*falpha)) * point
                b1 = (1.0 / (3.0*powf(Float(d1), falpha)*(powf(Float(d1), falpha)+powf(Float(d2), falpha)))) * b1
                
                var b2 = powf(Float(d3), 2.0*falpha) * point
                b2 = b2 - powf(Float(d2), 2.0*falpha) * secondNextPoint
                b2 = b2 + (2.0*powf(Float(d3), 2.0*falpha) + 3.0*powf(Float(d3), falpha)*powf(Float(d2), falpha) + powf(Float(d2), 2.0*falpha)) * nextPoint
                b2 = (1.0 / (3.0*powf(Float(d3), falpha)*(powf(Float(d3), falpha)+powf(Float(d2), falpha)))) * b2
                println("curve:\(nextPoint) controlPoint1:\(b1) controlPoint2:\(b2)")
                
                linePath.addCurveToPoint(nextPoint, controlPoint1: b1, controlPoint2: b2)
            }
        }
        return linePath
    }
    
    func drawReferenceLines()  -> UIBezierPath {
        Logger.Log(className: NSStringFromClass(self.classForCoder))
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
    
    func drawDots() {
        self.dots.removeAll(keepCapacity: false)
        for point in points {
            var dot:DotView = DotView(frame: CGRect(x: 0, y: 0, width: self.dotSize, height: self.dotSize))
            dot.center = point
            dot.alpha = 0.0
            dot.value = point.y
            dot.color = self.dotColor
            self.addSubview(dot)
            self.dots.append(dot)
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                dot.alpha = 0.7
            })
        }
    }
    
    
    func eraseLineView() {
        self.lineLayer.sublayers = nil
        for dot in self.dots {
            dot.removeFromSuperview()
        }
    }
    
    func addTouchLineToView()
    {
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        self.touchLine = UIView(frame: CGRect(x: 0, y: 0, width: self.touchLineWidth, height: self.frame.size.height))
        self.addSubview(self.touchLine)
    }

    
    func refreshPoints() {
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        self.points = Array<CGPoint>()
        var step:CGFloat = CGFloat(self.frame.width)/CGFloat(self.values.count-1)
        for (index,value) in enumerate(values) {
            var pointToAdd = CGPoint(x: CGFloat(step)*CGFloat(index), y: value)
            self.points.append(pointToAdd)
        }
        self.setNeedsDisplay()
    }

   
    // MARK: Animation methods
    
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

    
    // MARK: Gesture recognizer handlers
    
    func tapHandler(recognizer:UIPanGestureRecognizer){
        Logger.Log(className: NSStringFromClass(self.classForCoder))
    }
    
    func panHandler(recognizer:UIPanGestureRecognizer){
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        
        let translation = recognizer.locationInView(self.viewForBaselineLayout())
        // To make sure the vertical line doesn't go beyond the frame of the graph.
        if (!((translation.x + self.frame.origin.x) <= self.frame.origin.x) &&
            !((translation.x + self.frame.origin.x) >= self.frame.origin.x + self.frame.size.width))
        {
            var origin = CGPoint(x: translation.x - self.touchLineWidth/2.0, y: 0.0)
            var size = CGSize(width: self.touchLineWidth, height: self.frame.size.height)
            self.touchLine.frame = CGRect(origin: origin, size: size)
            self.touchLine.backgroundColor = UIColor.redColor()
            
        }
        self.touchLine.alpha = 1.0
        if self.closestDot != nil {
            self.closestDot.color = self.dotColor
        }
        
        self.closestDot = self.closestDotFromTouchLine(self.touchLine)
        self.closestDot.color = UIColor.whiteColor()
        
        
        if (recognizer.state == UIGestureRecognizerState.Ended) {
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.touchLine.alpha = 0.0
                self.closestDot.color = self.dotColor
                
                }, completion: nil)
            
        }
    }
    
    func closestDotFromTouchLine(line:UIView) -> DotView {
        self.closestDot = self.dots.first
        var closestDiff: CGFloat = self.frame.width*2.0
        let lineXPos = line.frame.origin.x
        for dot in self.dots {
            var currentDif = fabs(dot.frame.origin.x - lineXPos)
            if currentDif <= closestDiff{
                closestDiff = currentDif
                self.closestDot = dot
            }
        }
        println(self.closestDot)
        return self.closestDot
    }
    
    public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        return true
    }
    
    public func vectorLength(point:CGPoint) -> CGFloat {
        return sqrt(point * point)
    }
    
    // MARK: Interface builder helper
    
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
}

public func -(lhs: CGPoint, rhs:CGPoint) -> CGPoint {
    return CGPoint(x:lhs.x-rhs.x,y:lhs.y-rhs.y)
}

public func +(left: CGPoint, right:CGPoint) -> CGPoint {
    return CGPoint(x:left.x+right.x,y:left.y+right.y)
}

public func *(left: CGPoint, right:CGPoint) -> CGFloat {
    return CGFloat(left.x * right.x + left.y * right.y)
}

public func *(lhs: CGFloat, rhs:CGPoint) -> CGPoint {
    return CGPoint(x:lhs * rhs.x,y: lhs * rhs.y)
}
public func *(lhs: Float, rhs:CGPoint) -> CGPoint {
    return CGPoint(x:CGFloat(lhs) * rhs.x,y: CGFloat(lhs) * rhs.y)
}





