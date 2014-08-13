//
//  GameScene.swift
//  InfiniteScrollingScene
//
//  Created by Yongxu Ren on 8/13/14.
//  Copyright (c) 2014 Yongxu Ren. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, InfiniteScrollingNodeDelegate {
    var cn1,cn2,cn3,cn4:SKSpriteNode!
    var spaceshipRotateSpeed:CGFloat=0
    var spaceship:SKSpriteNode!
    var world=SKNode()
    var scrollingNode:InfiniteScrollingNode!
    var spaceshipSpeed:CGFloat = 700
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        anchorPoint=CGPointMake(0.5, 0.5)
        physicsWorld.gravity=CGVectorMake(0, 0)
        var size2x=CGSizeMake(size.width*2, size.height*2)
        cn1=SKSpriteNode(color: UIColor.redColor(), size: size2x)
        cn2=SKSpriteNode(color: UIColor.greenColor(), size: size2x)
        cn3=SKSpriteNode(color: UIColor.blueColor(), size: size2x)
        cn4=SKSpriteNode(color: UIColor.yellowColor(), size: size2x)
        cn1.name="red"
        cn2.name="green"
        cn3.name="blue"
        cn4.name="yellow"
        
        scrollingNode=InfiniteScrollingNode(topLeftNode: cn1, topRightNode: cn2, bottomLeftNode: cn3, bottomRightNode: cn4, nodesSize: size2x)
        scrollingNode.delegate=self
        world.addChild(scrollingNode)
        
        
        spaceship = SKSpriteNode(imageNamed: "Spaceship")
        spaceship.zPosition=1
        spaceship.name="spaceship"
        
        spaceship.xScale=0.5
        spaceship.yScale=0.5
        let body=SKPhysicsBody(texture: spaceship.texture,
            size: CGSize(width: spaceship.size.width*0.5,height: spaceship.size.height*0.5))
        body.velocity=CGVectorMake(0, 1000)
        body.mass=10
        body.dynamic=true
        spaceship.physicsBody=body
        spaceship.position=CGPointMake(0, 0)
        spaceship.zPosition=1000
        world.addChild(spaceship)
        addChild(world)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            spaceshipPhysicsUsingTouchLocation(location)
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        for touch: AnyObject in touches {
            spaceshipRotateSpeed=0
        }
    }
    
    func spaceshipPhysicsUsingTouchLocation(location:CGPoint){
        if location.x<0{
            //turnLeft
            spaceshipRotateSpeed = 2
        }else{
            //turnRight
            spaceshipRotateSpeed = -2
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        var rotation = spaceship.zRotation
        spaceship.physicsBody.velocity=CGVectorMake(spaceshipSpeed*CGFloat(sinf(-Float(rotation))), spaceshipSpeed*CGFloat(cosf(Float(rotation))))
        spaceship.physicsBody.angularVelocity=spaceshipRotateSpeed
    }
    override  func didSimulatePhysics() {
        centerOnNode(spaceship)
        scrollingNode.update(spaceship.position)
    }
    func nodeInDisplay(node:SKNode){
        println("\(node.name) IN.")
    }
    func nodeOutDisplay(node:SKNode){
        println("\(node.name) OUT.")
    }
    /*this function is optional*/
    func nodeWillMove(node:SKNode,toPosition pos:CGPoint){
        
    }
    
    func centerOnNode(node:SKNode!){
        let cameraPositionInScene=node.scene.convertPoint(node.position,fromNode:node.parent)
        node.parent.position=CGPointMake(node.parent.position.x - cameraPositionInScene.x,                                       node.parent.position.y - cameraPositionInScene.y)
    }
}
