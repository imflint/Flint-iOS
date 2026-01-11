//
//  FixedGradientView.swift
//  Flint
//
//  Created by 김호성 on 2025.03.12.
//

import UIKit

final class FixedGradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }
    
    var colors: [UIColor] = [] {
        didSet {
            gradientLayer?.colors = colors.map(\.cgColor)
        }
    }
    
    var locations: [NSNumber] = [] {
        didSet {
            gradientLayer?.locations = locations
        }
    }
    
    var startPoint: CGPoint = CGPoint(x: 0, y: 0.5) {
        didSet {
            fixPoints()
        }
    }
    
    var endPoint: CGPoint = CGPoint(x: 1, y: 0.5) {
        didSet {
            fixPoints()
        }
    }
    
    var type: CAGradientLayerType = .axial {
        didSet {
            gradientLayer?.type = type
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        fixPoints()
    }
}

extension FixedGradientView {
    /// 대각선 Gradient 구현을 위한 값 보정 함수
    /// See https://stackoverflow.com/a/43176174 for more information.
    func fixPoints() {
        if startPoint.x == endPoint.x || startPoint.y == endPoint.y {
            // Apple's implementation of horizontal and vertical gradients works just fine
            gradientLayer?.startPoint = startPoint
            gradientLayer?.endPoint = endPoint
            return
        }
        
        // 1. Convert to absolute coordinates
        let startEnd = LineSegment(startPoint, endPoint)
        let ab = startEnd.multiplied(multipliers: (x: bounds.width, y: bounds.height))
        let a = ab.p1
        let b = ab.p2
        
        // 2. Calculate perpendicular bisector
        let cd = ab.perpendicularBisector
        
        // 3. Scale to square coordinates
        let multipliers = calculateMultipliers(bounds: bounds.size)
        let lineSegmentCD = cd.multiplied(multipliers: multipliers)
        
        // 4. Create scaled perpendicular bisector
        let lineSegmentEF = lineSegmentCD.perpendicularBisector
        
        // 5. Unscale back to rectangle
        let ef = lineSegmentEF.divided(divisors: multipliers)
        
        // 6. Extend line
        let efLine = ef.line
        
        // 7. Extend two lines from a and b parallel to cd
        let aParallelLine = Line(m: cd.slope, p: a)
        let bParallelLine = Line(m: cd.slope, p: b)
        
        // 8. Find the intersection of these lines
        let g = efLine.intersection(with: aParallelLine)
        let h = efLine.intersection(with: bParallelLine)
        
        if let g = g, let h = h {
            // 9. Convert to relative coordinates
            let gh = LineSegment(g, h)
            let result = gh.divided(divisors: (x: bounds.width, y: bounds.height))
            gradientLayer?.startPoint = result.p1
            gradientLayer?.endPoint = result.p2
            return
        }
        gradientLayer?.startPoint = startPoint
        gradientLayer?.endPoint = endPoint
    }
}

extension FixedGradientView {
    private func calculateMultipliers(bounds: CGSize) -> (x: CGFloat, y: CGFloat) {
        if bounds.height <= bounds.width {
            return (x: 1, y: bounds.width/bounds.height)
        } else {
            return (x: bounds.height/bounds.width, y: 1)
        }
    }
    
    private struct LineSegment {
        let p1: CGPoint
        let p2: CGPoint
        
        init(_ p1: CGPoint, _ p2: CGPoint) {
            self.p1 = p1
            self.p2 = p2
        }
        
        init(p1: CGPoint, m: CGFloat, distance: CGFloat) {
            self.p1 = p1
            
            let line = Line(m: m, p: p1)
            let measuringPoint = line.point(x: p1.x + 1)
            let measuringDeltaH = LineSegment(p1, measuringPoint).distance
            
            let deltaX = distance/measuringDeltaH
            self.p2 = line.point(x: p1.x + deltaX)
        }
        
        var length: CGFloat {
            let dx = p2.x - p1.x
            let dy = p2.y - p1.y
            return sqrt(dx * dx + dy * dy)
        }
        var distance: CGFloat {
            return p1.x <= p2.x ? length : -length
        }
        var midpoint: CGPoint {
            return CGPoint(x: (p1.x + p2.x)/2, y: (p1.y + p2.y)/2)
        }
        var slope: CGFloat {
            return (p2.y-p1.y)/(p2.x-p1.x)
        }
        var perpendicularSlope: CGFloat {
            return -1/slope
        }
        var line: Line {
            return Line(p1, p2)
        }
        var perpendicularBisector: LineSegment {
            let p1 = LineSegment(p1: midpoint, m: perpendicularSlope, distance: -distance/2).p2
            let p2 = LineSegment(p1: midpoint, m: perpendicularSlope, distance: distance/2).p2
            return LineSegment(p1, p2)
        }
        
        func multiplied(multipliers: (x: CGFloat, y: CGFloat)) -> LineSegment {
            return LineSegment(
                CGPoint(x: p1.x * multipliers.x, y: p1.y * multipliers.y),
                CGPoint(x: p2.x * multipliers.x, y: p2.y * multipliers.y))
        }
        func divided(divisors: (x: CGFloat, y: CGFloat)) -> LineSegment {
            return multiplied(multipliers: (x: 1/divisors.x, y: 1/divisors.y))
        }
    }
    
    private struct Line {
        let m: CGFloat
        let b: CGFloat
        
        /// y = mx+b
        init(m: CGFloat, b: CGFloat) {
            self.m = m
            self.b = b
        }
        
        /// y-p.y = m(x-p.x)
        init(m: CGFloat, p: CGPoint) {
            self.m = m
            self.b = p.y - m*p.x
        }
        
        init(_ p1: CGPoint, _ p2: CGPoint) {
            self.init(m: LineSegment(p1, p2).slope, p: p1)
        }
        
        func y(x: CGFloat) -> CGFloat {
            return m*x + b
        }
        
        func point(x: CGFloat) -> CGPoint {
            return CGPoint(x: x, y: y(x: x))
        }
        
        func intersection(with line: Line) -> CGPoint? {
            // Line 1: y = mx + b
            // Line 2: y = nx + c
            let n = line.m
            let c = line.b
            if m-n == 0 {
                // lines are parallel
                return nil
            }
            let x = (c-b)/(m-n)
            return point(x: x)
        }
    }
}
