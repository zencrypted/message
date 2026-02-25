// MessageRoundedCorner.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI

struct MessageRoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: RectCorner = .allCorners

    // Custom enum to replace UIRectCorner
    struct RectCorner: OptionSet {
        let rawValue: Int
        static let topLeft     = RectCorner(rawValue: 1 << 0)
        static let topRight    = RectCorner(rawValue: 1 << 1)
        static let bottomLeft  = RectCorner(rawValue: 1 << 2)
        static let bottomRight = RectCorner(rawValue: 1 << 3)
        static let allCorners: RectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(self.radius, min(rect.width, rect.height) / 2)
        // Determine which corners to round
        let tl = corners.contains(.topLeft)
        let tr = corners.contains(.topRight)
        let bl = corners.contains(.bottomLeft)
        let br = corners.contains(.bottomRight)
        // Start at top-left (adjusted if rounded)
        path.move(to: CGPoint(x: rect.minX + (tl ? radius : 0), y: rect.minY))
        // Top side + top-right corner
        path.addLine(to: CGPoint(x: rect.maxX - (tr ? radius : 0), y: rect.minY))
        if tr {
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                        radius: radius,
                        startAngle: Angle(degrees: -90),
                        endAngle: Angle(degrees: 0),
                        clockwise: false)
        }
        // Right side + bottom-right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - (br ? radius : 0)))
        if br {
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                        radius: radius,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 90),
                        clockwise: false)
        }
        // Bottom side + bottom-left corner
        path.addLine(to: CGPoint(x: rect.minX + (bl ? radius : 0), y: rect.maxY))
        if bl {
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                        radius: radius,
                        startAngle: Angle(degrees: 90),
                        endAngle: Angle(degrees: 180),
                        clockwise: false)
        }
        // Left side + top-left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + (tl ? radius : 0)))
        if tl {
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                        radius: radius,
                        startAngle: Angle(degrees: 180),
                        endAngle: Angle(degrees: 270),
                        clockwise: false)
        }
        return path
    }
}

extension View {
    func roundedCornerWithBorder(borderColor: Color, radius: CGFloat, corners: MessageRoundedCorner.RectCorner) -> some View {
        self.clipShape(MessageRoundedCorner(radius: radius, corners: corners))
            .overlay(
                MessageRoundedCorner(radius: radius, corners: corners)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
}

