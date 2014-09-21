import SpriteKit

class GameScene: SKScene {
    var history: Array<String> = []

    override func didMoveToView(view: SKView) {
        backgroundColor = NSColor.whiteColor()

        view.window!.makeFirstResponder(self)
    }

    override func mouseMoved(theEvent: NSEvent!) {
        let center  = theEvent.locationInNode(self)
        let pointer = SKSpriteNode(imageNamed: "Pointer")

        pointer.position = NSPoint(x: center.x + 256, y: center.y)
        pointer.color = generateColor()
        pointer.colorBlendFactor = 1.0

        pointer.runAction(SKAction.waitForDuration(1), completion: {
            pointer.runAction(SKAction.fadeOutWithDuration(2), completion: {
                pointer.removeFromParent()
            })
        })

        addChild(pointer)
    }

    override func keyDown(theEvent: NSEvent!) {
        let characters = theEvent.characters
        if let _ = characters.rangeOfString("[A-Za-z0-9]", options: .RegularExpressionSearch) {
            history.append(characters)

            let word = history.reduce("", +)
            if word == "quit" {
                NSApplication.sharedApplication().terminate(self)
            } else {
                addLabel(characters)
            }

            if history.count > 3 {
                history.removeAtIndex(0)
            }
        } else if characters == " " {
            addShape()
        }
    }

    override func mouseDown(theEvent: NSEvent!) {
        addShape()
    }

    func addShape() {
        let shape = SKShapeNode()
        shape.path = CGPathCreateWithEllipseInRect(CGRect(x: 0, y: 0, width: 150, height: 150), nil)

        shape.fillColor = generateColor()
        shape.position = generatePoint()
        shape.antialiased = true
        shape.lineWidth = 0

        shape.runAction(SKAction.waitForDuration(1), completion: {
            shape.runAction(SKAction.fadeOutWithDuration(2), completion: {
                shape.removeFromParent()
            })
        })

        addChild(shape)
    }

    func addLabel(characters: String) {
        let label = SKLabelNode(fontNamed:"Comic Sans MS")
        label.text = characters

        label.fontSize = 150
        label.fontColor = generateColor()
        label.position = generatePoint()

        label.runAction(SKAction.scaleTo(1.5, duration: 1))

        label.runAction(SKAction.waitForDuration(1), completion: {
            label.runAction(SKAction.fadeOutWithDuration(2), completion: {
                label.removeFromParent()
            })
        })

        addChild(label)
    }
    
    func generateRandom(max: Double) -> Double {
        return Double(arc4random_uniform(UInt32(max)))
    }
    
    func generateColor() -> NSColor {
        let randomComponent = { () -> CGFloat in
            return CGFloat(self.generateRandom(255) / 255)
        }

        return NSColor(calibratedRed: randomComponent(), green: randomComponent(), blue: randomComponent(), alpha: 1.0)
    }

    func generatePoint() -> CGPoint {
        let xMargin = 50.0
        let yMargin = 75.0
        let width   = Double(self.frame.size.width)
        let height  = Double(self.frame.size.height)

        var xPos = 0.0
        var yPos = 0.0

        while xPos < xMargin || xPos > width - xMargin ||
              yPos < yMargin || yPos > height - yMargin {

            xPos = generateRandom(width)
            yPos = generateRandom(height)
        }

        return CGPoint(x: xPos - xMargin, y: yPos - yMargin)
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
