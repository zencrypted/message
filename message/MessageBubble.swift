// MessageBubble.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI

struct MessageBubble: Shape {
    func path(in rect: CGRect) -> Path {
        let path = Path { path in
            let cornerRadius: Double = 16
            let tailWidth: Double = 8
            let tailHeight = cornerRadius
            let bubbleWidth = rect.width - tailWidth
            let tailEndpointX = (bubbleWidth - cornerRadius) + cornerRadius * cos(.pi / 4)
            let tailEndpointY = (rect.height - cornerRadius) + cornerRadius * sin(.pi / 4)
            path.move(to: CGPoint(x: cornerRadius, y: rect.minY))
            path.addLine(to: CGPoint(x: bubbleWidth - cornerRadius, y: rect.minY))
            path.addArc(
                center: CGPoint(x: bubbleWidth - cornerRadius, y: cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: -90),
                endAngle: Angle(degrees: 0),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: bubbleWidth, y: cornerRadius))
            path.addLine(to: CGPoint(x: bubbleWidth, y: rect.height - cornerRadius))
            path.addQuadCurve(
                to: CGPoint(x: rect.width, y: rect.height),
                control: CGPoint(x: bubbleWidth, y: rect.height - (tailHeight / 2))
            )
            path.addQuadCurve(
                to: CGPoint(x: tailEndpointX, y: tailEndpointY),
                control: CGPoint(x: bubbleWidth, y: rect.height)
            )
            path.addArc(
                center: CGPoint(x: bubbleWidth - cornerRadius, y: rect.height - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 45),
                endAngle: Angle(degrees: 90),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: bubbleWidth - cornerRadius - tailWidth, y: rect.height))
            path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.height))
            path.addArc(
                center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 180),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.minX, y: rect.height - cornerRadius))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
            path.addArc(
                center: CGPoint(x: cornerRadius, y: cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false
            )
            path.closeSubpath()
        }
        return path
    }
}

struct MessageBubbleStyle: ViewModifier {
    let isFromYou: Bool
    let shouldSendInTheFuture: Bool
    var messageFillColor: Color {
        if shouldSendInTheFuture {
            return Color.clear
        } else if isFromYou {
            return Color.blue
        } else {
            return Color.secondary.opacity(0.2)
        }
    }
    var forgroundColor: Color {
        if shouldSendInTheFuture {
            return Color.blue
        } else if isFromYou {
            return Color.white
        } else {
            return Color.primary
        }
    }

    func body(content: Content) -> some View {
            content
                .foregroundStyle(forgroundColor)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .padding(isFromYou ? .trailing : .leading, 8) // 8 is the tail width
                .background(
                    MessageBubble()
                        .fill(messageFillColor)
                        .stroke(Color.blue, style: StrokeStyle(dash: [shouldSendInTheFuture ? 6 : 0]))
                        .rotation3DEffect(isFromYou ? .degrees(0) : .degrees(180), axis: (x: 0, y: 1, z: 0))
                )
    }
}

extension View {
    func messageBubbleStyle(isFromYou: Bool, shouldSendInTheFuture: Bool = false) -> some View {
        modifier(MessageBubbleStyle(isFromYou: isFromYou, shouldSendInTheFuture: shouldSendInTheFuture))
    }
}

@ViewBuilder
func ImageAttachmentView(_ thumbnail: Image, isFromYou: Bool, shouldSendInTheFuture: Bool) -> some View {
    var forgroundColor: Color {
        if shouldSendInTheFuture {
            return Color.blue
        } else if isFromYou {
            return Color.white
        } else {
            return Color.primary
        }
    }

    thumbnail
        .resizable()
        .scaledToFit()
        .mask(
            MessageBubble()
                .fill()
                .stroke(Color.blue, style: StrokeStyle(dash: [shouldSendInTheFuture ? 6 : 0]))
                .rotation3DEffect(isFromYou ? .degrees(0) : .degrees(180), axis: (x: 0, y: 1, z: 0))
        )
}

@ViewBuilder
func VideoAttachmentView(_ thumbnail: Image, isFromYou: Bool, shouldSendInTheFuture: Bool) -> some View {
    var forgroundColor: Color {
        if shouldSendInTheFuture {
            return Color.blue
        } else if isFromYou {
            return Color.white
        } else {
            return Color.primary
        }
    }

    ZStack {
        thumbnail
            .resizable()
            .scaledToFit()
            .mask(
                MessageBubble()
                    .fill()
                    .stroke(Color.blue, style: StrokeStyle(dash: [shouldSendInTheFuture ? 6 : 0]))
                    .rotation3DEffect(isFromYou ? .degrees(0) : .degrees(180), axis: (x: 0, y: 1, z: 0))
            )

        Image(systemName: "play.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 10)
            .padding(8)
            .background(.ultraThinMaterial)
            .foregroundStyle(.black)
            .clipShape(Circle())
    }
}

@ViewBuilder
func OtherAttachmentView(_ thumbnail: Image, fileName: String, docType: String, fileSize: String, isFromYou: Bool, shouldSendInTheFuture: Bool) -> some View {
    var messageFillColor: Color {
        if shouldSendInTheFuture {
            return Color.clear
        } else if isFromYou {
            return Color.blue
        } else {
            return Color.secondary.opacity(0.2)
        }
    }

    var forgroundColor: Color {
        if shouldSendInTheFuture {
            return Color.blue
        } else if isFromYou {
            return Color.white
        } else {
            return Color.primary
        }
    }

    HStack {
        thumbnail

        VStack {
            Text(fileName).bold()
            HStack {
                Text(docType)
                Text(fileSize)
            }
            .font(.callout)
            .foregroundStyle(.secondary)
        }
    }
    .messageBubbleStyle(isFromYou: isFromYou, shouldSendInTheFuture: shouldSendInTheFuture)
}
