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




//@IBDesignable
public class LineChartView: UIView, UIGestureRecognizerDelegate{
    // MARK: Inspectable properties
    
    // reference lines related properties
    @IBInspectable var enableReferenceLine: Bool = true
    @IBInspectable var enableReferenceFrame: Bool = true
    
    // graph line related properties
    @IBInspectable var lineAlpha: Float = 1.0
    @IBInspectable var lineColor: UIColor = UIColor.redColor()
    @IBInspectable var lineWidth:CGFloat = 1.0
    @IBInspectable public var bezierCurveIsEnabled: Bool = true {
        didSet {
            self.lineType = bezierCurveIsEnabled ? LineType.LineTypeSpline : LineType.LineTypeSimple
        }
    }
    @IBInspectable var animationType: LineViewAnimationType = LineViewAnimationType.LineViewAnimationTypeDraw
    @IBInspectable var animationTime: CGFloat = 0
    
    
    @IBInspectable let topColor: UIColor = UIColor.redColor()
    @IBInspectable let bottomColor: UIColor = UIColor.redColor()

    @IBInspectable var dotSize:CGFloat = 5.0
    @IBInspectable var dotColor:UIColor = UIColor.blueColor()

    let xAxisBackgroundColor: UIColor = UIColor.redColor()
    let xAxisBackgroundColorAlpha: CGFloat = 1.0
    
    let referenceLineColor = UIColor.blackColor()
    
    let startPoint: CGPoint = CGPointMake(0, 0)
    let endPoint: CGPoint = CGPointMake(0, 0)
    var nextPoint: CGPoint = CGPointMake(0, 0)
    var previousPoint: CGPoint = CGPointMake(0, 0)
    var values: Array<Float> = [] {
        didSet {
            refreshPoints()
        }
    }
    
    let topAlpha: CGFloat = 1.0
    let bottomAlpha: CGFloat = 1.0
    
    let frameOffset: CGFloat = 0.0

    
    // Gesture recognizers
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    var doubleTapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    
    
    // Line when touching
    var touchLine: InterractionView?
    var touchLineColor: UIColor = UIColor.grayColor()
    var touchLineWidth: CGFloat = 1.0
    
    var closestDot:DotView!
    var dots:Array<DotView> = Array<DotView>()
    
    var lineLayer:CALayer = CALayer()
    
    var maxValue:Float = 0.0
    var minValue:Float = 0.0
    
    var line:Line = Line()
    var points:Array<LinePoint> = Array<LinePoint>()
    var lineType:LineType = LineType.LineTypeSpline {
        didSet {
            self.line.lineType = self.lineType
        }
    }
    
    var lineView:UIView!
    var horizontalLabelsView:UIView!
    var verticalLabelsView:UIView!
    
    var verticalLabels:Array<UILabel>!
    var horizontalLabels:Array<UILabel>!
    
        var fillToBottom:CAShapeLayer = CAShapeLayer()
    
    // MARK: init methods
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initAll()
        

        

        self.backgroundColor = UIColor.clearColor()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initAll()
        
        
        self.bezierCurveIsEnabled = false
    }

    func addView() {
        self.lineView = UIView()
        
        self.lineView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(self.lineView)
        self.verticalLabelsView = UIView()
        self.verticalLabelsView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(self.verticalLabelsView)
        self.verticalLabelsView.backgroundColor = UIColor.clearColor()

        self.horizontalLabelsView = UIView()
        self.horizontalLabelsView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(self.horizontalLabelsView)
        self.horizontalLabelsView.backgroundColor = UIColor.clearColor()
        
        let metrics = ["lHeight" : 20.0, "lWidth" : 40]
        let views = ["vlView": self.verticalLabelsView, "superView" : self, "lineView" : self.lineView, "hView" : self.horizontalLabelsView]
        let hConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[vlView]-2.0-[lineView]|", options: NSLayoutFormatOptions(0), metrics: metrics, views:views)
        let hConstraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[vlView]-2.0-[hView]|", options: NSLayoutFormatOptions(0), metrics: metrics, views:views)

        let vConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[vlView(superView)]", options: NSLayoutFormatOptions(0), metrics: metrics, views:views)
        let vConstraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[lineView]-2.0-[hView]|", options: NSLayoutFormatOptions(0), metrics: metrics, views:views)
        self.addConstraints(hConstraint)
        self.addConstraints(vConstraint)
        self.addConstraints(vConstraint2)
        self.addConstraints(hConstraint2)
        self.addConstraint(NSLayoutConstraint(item: self.verticalLabelsView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 0.1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.horizontalLabelsView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 0.1, constant: 0))
        
        self.bringSubviewToFront(self.lineView)
        
        self.layoutIfNeeded()

    }
    
    func initAll() {
        self.addView()
        self.initLayers()
        self.initGestureRecognizers()
        self.addTouchLineToView()
    }
    
    func initLayers() {
        self.lineView.layer.addSublayer(self.lineLayer)
    }
    
    func initGestureRecognizers() {
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapHandler:"))
        self.tapGestureRecognizer.delegate = self
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panHandler:"))
        self.panGestureRecognizer.delegate = self
        self.panGestureRecognizer.maximumNumberOfTouches = 1
        self.lineView.addGestureRecognizer(self.tapGestureRecognizer)
        self.lineView.addGestureRecognizer(self.panGestureRecognizer)
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("doubleTapHandler:"))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(self.doubleTapGestureRecognizer)
        
    }
    
    // MARK: Drawing methods
    
    override public func drawRect(rect: CGRect)
    {
        eraseLineView()
        refreshPoints()
       
        println("LineChartView.drawRect");
        println("brezier: \(self.bezierCurveIsEnabled)")
        
        var referenceLinesShapeLayer = self.drawReferenceLines()
        var line = Line(points:self.points, type: self.lineType)
        
        if self.animationTime == 0 {
            self.lineColor.set()
            line.path.lineWidth = self.lineWidth
            line.path.strokeWithBlendMode(kCGBlendModeNormal, alpha: CGFloat(self.lineAlpha))
            
            if self.enableReferenceLine {
                referenceLinesShapeLayer.lineWidth = self.lineWidth/2.0
//                referenceLinesShape.strokeWithBlendMode(kCGBlendModeNormal, alpha: CGFloat(self.lineAlpha/2.0))
            }
        } else {
            var pathLayer: CAShapeLayer = CAShapeLayer()
            pathLayer.frame.size = self.lineView.frame.size
            pathLayer.path = line.path.CGPath
            pathLayer.strokeColor = self.lineColor.CGColor
            pathLayer.fillColor = nil
            pathLayer.lineWidth = 2//self.lineWidth
            pathLayer.lineJoin = kCALineJoinBevel
            pathLayer.lineCap = kCALineCapRound
            self.animateForLayer(pathLayer, animationType:LineViewAnimationType.LineViewAnimationTypeDraw, isAnimatingReferenceLine:true)
            self.animateForLayer(referenceLinesShapeLayer, animationType: LineViewAnimationType.LineViewAnimationTypeDraw, isAnimatingReferenceLine: true)
            self.lineLayer.addSublayer(pathLayer)
            self.lineLayer.addSublayer(referenceLinesShapeLayer)
            
            if line.points.count > 0 {
                var fillToBottomPath = line.path //UIBezierPath(CGPath: self.line.path.CGPath)
                fillToBottomPath.addLineToPoint(CGPoint(x:line.points.last!.position.x,y:self.lineView.frame.size.height))
                fillToBottomPath.addLineToPoint(CGPoint(x:line.points.first!.position.x,y:self.lineView.frame.size.height))
                fillToBottomPath.closePath()
                self.fillToBottom = CAShapeLayer()
                self.fillToBottom.path = fillToBottomPath.CGPath
                self.fillToBottom.strokeColor = nil
                self.fillToBottom.fillColor = UIColor.whiteColor().CGColor
                self.fillToBottom.frame.size = self.lineView.frame.size
                
                var gradientLayer = CAGradientLayer()
                gradientLayer.anchorPoint = CGPointZero
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                
                var topColor:CGColorRef = UIColor(white: 1.0, alpha: 0.4).CGColor
                var bottomColor:CGColorRef = UIColor(white: 1.0, alpha: 0.0).CGColor
                
                gradientLayer.colors = [topColor,bottomColor]
                gradientLayer.locations = [Float(0.0),Float(1.0)]
                gradientLayer.bounds = CGRect(origin: CGPointZero, size: self.lineView.bounds.size)
                self.fillToBottom.mask = gradientLayer
                self.animateForLayer(fillToBottom, animationType: LineViewAnimationType.LineViewAnimationTypeDraw, isAnimatingReferenceLine: true)
                self.lineLayer.addSublayer(self.fillToBottom)
            }

        }
        drawDots()
    }
    
    func makeAxisLabel(position:CGPoint,labelText:String) -> UILabel
    {
        var label = UILabel(frame: CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 50, height: 20)))
        label.text = labelText
        label.font = UIFont.systemFontOfSize(12.0)
        label.sizeToFit()
        label.center = position
        label.textAlignment = NSTextAlignment.Center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.0
        return label
    }

    // Draw Reference Lines
    func drawReferenceLines()  -> CAShapeLayer {
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        var referenceLinePathLayer = CAShapeLayer()
        if (self.enableReferenceLine) {
            // customize path
            var referenceLinePath: UIBezierPath = UIBezierPath()
            referenceLinePath.lineCapStyle = kCGLineCapButt
            referenceLinePath.lineWidth = 0.1
            referenceLinePath.strokeWithBlendMode(kCGBlendModeNormal, alpha: 1.0)
            self.verticalLabels = Array<UILabel>()
            for view in self.verticalLabelsView.subviews
            {
                view.removeFromSuperview()
            }
            self.horizontalLabels = Array<UILabel>()
            for view in self.horizontalLabelsView.subviews
            {
                view.removeFromSuperview()
            }
            

            let diff:Int = 2 // step for drawing reference lines if we dont need them all
            // draw vertical reference lines
            for var i = 0; i < self.points.count; i+=diff {
                let pointX = self.points[i].position.x
                let initialPoint:CGPoint = CGPointMake(pointX, self.lineView.frame.size.height - self.frameOffset)
                let finalPoint:CGPoint = CGPointMake(pointX, 0)
                referenceLinePath.moveToPoint(initialPoint)
                referenceLinePath.addLineToPoint(finalPoint)
                let point:LinePoint = self.points[i]
 
                var label = self.makeAxisLabel(CGPoint(x:point.position.x,y:self.horizontalLabelsView.frame.size.height/2.0), labelText: point.label)
                
                if (self.horizontalLabels.count >= 1 ) {
                    let previousLabel = self.horizontalLabels.last!
                    println("previousLabel frame : \(previousLabel.frame)")
                    println("currentLabel frame : \(label.frame)")
                    if (fabs(previousLabel.center.x - label.center.x) > label.frame.size.width * 2) {
                        self.horizontalLabels.append(label)
                        self.horizontalLabelsView.addSubview(label)
                    }
                } else {
                    self.horizontalLabels.append(label)
                    self.horizontalLabelsView.addSubview(label)
                }
                
            }
            
            // sort points for drawing every diff. lines (eg. only 2nd lines)
            let sortedPoints = sorted(self.points, { (p1:LinePoint, p2:LinePoint) -> Bool in
                return p1.position.y > p2.position.y
            })
            // draw horizontal lines
            for var i = 0; i < sortedPoints.count; i+=diff {
                let pointY = sortedPoints[i].position.y
                var initialPoint:CGPoint = CGPointMake(0, pointY)
                var finalPoint:CGPoint = CGPointMake(self.lineView.frame.size.width, pointY)
                referenceLinePath.moveToPoint(initialPoint)
                referenceLinePath.addLineToPoint(finalPoint)

                let point:LinePoint = sortedPoints[i]
                var label = self.makeAxisLabel(CGPoint(x:self.verticalLabelsView.frame.size.width/2.0,y:point.position.y), labelText: String("\(point.value)"))
                if (self.verticalLabels.count >= 1 ) {
                    let previousLabel = self.verticalLabels.last!
                    println("previousLabel frame : \(previousLabel.frame)")
                    println("currentLabel frame : \(label.frame)")
                    if (fabs(previousLabel.center.y - label.center.y) > label.frame.size.height * 2) {
                        self.verticalLabels.append(label)
                        self.verticalLabelsView.addSubview(label)
                    }
                } else {
                    self.verticalLabels.append(label)
                    self.verticalLabelsView.addSubview(label)
                }
            }
            
//            if (self.enableReferenceFrame) {
//                referenceLinePath.moveToPoint(CGPointMake(0, self.lineView.frame.size.height - self.frameOffset))
//                referenceLinePath.addLineToPoint(CGPointMake(self.lineView.frame.size.width, self.lineView.frame.size.height - self.frameOffset))
//                
//                referenceLinePath.moveToPoint(CGPointMake(0+self.lineWidth/4, self.lineView.frame.size.height - self.frameOffset))
//                referenceLinePath.addLineToPoint(CGPointMake(0+self.lineWidth/4, 0))
//            }
            referenceLinePath.closePath()
            
            // add path to self.layer
            referenceLinePathLayer.frame.size = self.lineView.frame.size
            referenceLinePathLayer.path = referenceLinePath.CGPath
            referenceLinePathLayer.opacity = self.lineAlpha/2.0
            referenceLinePathLayer.strokeColor = self.referenceLineColor.CGColor
            referenceLinePathLayer.fillColor = nil
            referenceLinePathLayer.lineWidth = 0.3
        }
        return referenceLinePathLayer
    }
    
    
    func drawDots() {
        self.dots.removeAll(keepCapacity: false)
        for point in points {
            var dot:DotView = DotView(frame: CGRect(x: 0, y: 0, width: self.dotSize, height: self.dotSize))
            dot.center = point.position
            dot.alpha = 0.0
            dot.value = point.value
            dot.color = self.dotColor
            self.lineView.addSubview(dot)
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
        self.touchLine = InterractionView(frame: CGRect(x: 0, y: 0, width: self.touchLineWidth, height: self.lineView.frame.size.height))
        self.touchLine?.alpha = 0
        self.lineView.addSubview(self.touchLine!)
    }

    
    func refreshPoints() {
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        let oldMin:Float = self.minValue < 0 ? Float(self.minValue) : 0
        let oldMax:Float = Float(self.maxValue)
        let newMargin:Float = 10.0
        let newMin:Float = Float(0.0) + newMargin
        let newMax:Float = Float(self.lineView.frame.size.height) - newMargin
        var oldRange:Float = Float(oldMax) - Float(oldMin)
        let newRange:Float = newMax - newMin
        self.points = Array<LinePoint>()
        var step:CGFloat = CGFloat(self.lineView.frame.width)/CGFloat(self.values.count-1)
        for (index,value) in enumerate(values) {
            var newValue:Float = newMax-(((Float(value) - Float(oldMin))*Float(newRange)) / Float(oldRange)) + Float(newMin)
            var pointToAdd = LinePoint(value: value, position: CGPoint(x: CGFloat(step)*CGFloat(index), y: CGFloat(newValue)))
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
    
    public func addValueToLine(value:Float) {
        let v:Float = Float(value)
        if self.values.count == 0 {
            self.maxValue = v
            self.minValue = v
        } else {
            if self.maxValue <= v {
                self.maxValue = v
            }
            if self.minValue >= v {
                self.minValue = v
            }
        }
        self.values.append(value)
        self.setNeedsDisplay()
    }
    
    func addRandomValueToLine() {
        var randomValue: Float = Float(arc4random_uniform(2000))
        var minus:Float = Float(arc4random_uniform(4))
        
        if minus == 2 {
            randomValue *= -1
        }
        

        println("added value: \(randomValue)")
        
        self.addValueToLine(randomValue)
    }
    
    // MARK: Gesture recognizer handlers
    
    func tapHandler(recognizer:UIPanGestureRecognizer){
        Logger.Log(className: NSStringFromClass(self.classForCoder))
    }
    
    func doubleTapHandler(recognizer:UIPanGestureRecognizer){
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        addRandomValueToLine()
    }
    
    func panHandler(recognizer:UIPanGestureRecognizer){
        Logger.Log(className: NSStringFromClass(self.classForCoder))
        
        self.touchLine!.alpha = 1.0
        if self.closestDot != nil {
            self.closestDot.color = self.dotColor
        }
        
        self.closestDot = self.closestDotFromTouchLine(self.touchLine!)
        self.closestDot.color = UIColor.whiteColor()
        
        let translation = recognizer.locationInView(self.lineView.viewForBaselineLayout())
        // To make sure the vertical line doesn't go beyond the frame of the graph.
        if (!((translation.x + self.lineView.frame.origin.x) <= self.lineView.frame.origin.x) &&
            !((translation.x + self.lineView.frame.origin.x) >= self.lineView.frame.origin.x + self.lineView.frame.size.width))
        {
            var origin = CGPoint(x: translation.x - self.touchLineWidth/2.0, y: 0.0)
            var frame = self.touchLine!.frame
            frame.origin = origin
            self.touchLine?.frame = frame
            self.touchLine?.center.x = translation.x
            self.touchLine?.pin.center.y = self.closestDot.center.y
            self.touchLine?.text = closestDot.value.description
            self.touchLine?.line.frame.size.height = self.lineView.frame.size.height
//            self.touchLine!.backgroundColor = UIColor.redColor()
            
        }

        
        
        if (recognizer.state == UIGestureRecognizerState.Ended) {
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.touchLine!.alpha = 0.0
                self.closestDot.color = self.dotColor
                
                }, completion: nil)
            
        }
    }
    
    func closestDotFromTouchLine(line:UIView) -> DotView {
        self.closestDot = self.dots.first
        var closestDiff: CGFloat = self.lineView.frame.width*2.0
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
    

    
    // MARK: Interface builder helper
    
    public override func prepareForInterfaceBuilder() {
        // provide sample data for Interface Builder
        
        self.values = [0,100,30,180,10,200]
        drawDots()
    }
    
    
}



