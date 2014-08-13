//
//  InfiniteScrollingNode.swift
//  Blue Shift
//
//  Created by Yongxu Ren on 8/4/14.
//  Copyright (c) 2014 Yongxu Ren. All rights reserved.
//

import SpriteKit
@objc protocol InfiniteScrollingNodeDelegate{
    func nodeInDisplay(node:SKNode)
    func nodeOutDisplay(node:SKNode)
    optional func nodeWillMove(node:SKNode,toPosition pos:CGPoint)
}


class InfiniteScrollingNode:SKNode{
    var center=CGPointMake(0, 0)
    var nodesSize:CGSize!
    var delegate:InfiniteScrollingNodeDelegate?
    //00 01
    //10 11
    var nodes:[[SKNode!]]=[[nil,nil],[nil,nil]]
    var nodesList:[SKNode]!
    var nodesInDisplay=[Bool](count: 4, repeatedValue: false)
    //nodes bolder area
    var left:CGFloat
    var right:CGFloat
    var top:CGFloat
    var bottom:CGFloat
    required init(coder aDecoder: NSCoder!)
    {
        left=0
        right=0
        top=0
        bottom=0
        super.init(coder: aDecoder)
    }
    
    init(topLeftNode:SKNode,topRightNode:SKNode,
        bottomLeftNode:SKNode,bottomRightNode:SKNode,nodesSize:CGSize){
        self.nodesSize=nodesSize
        left=(-nodesSize.width*0.5)
        right=nodesSize.width*0.5
        top=nodesSize.height*0.5
        bottom=(-nodesSize.height*0.5)
        super.init()
        nodes[0][0]=topLeftNode
        nodes[0][1]=topRightNode
        nodes[1][0]=bottomLeftNode
        nodes[1][1]=bottomRightNode
        nodesList=[topLeftNode,topRightNode,bottomLeftNode,bottomRightNode]
        setNodesPosition()
        addChild(nodes[0][0])
        addChild(nodes[0][1])
        addChild(nodes[1][0])
        addChild(nodes[1][1])
    }
    
    func setNodesPosition(){
        setNodePosition(0, 0)
        setNodePosition(0, 1)
        setNodePosition(1, 0)
        setNodePosition(1, 1)
    }
    
    func setNodePosition(x:CGFloat,_ y:CGFloat){
        nodes[Int(x)][Int(y)].position = CGPointMake(CGFloat(nodesSize.width)*(-0.5+y), CGFloat(nodesSize.height)*(0.5-x))
    }
    
    func update(worldCenter:CGPoint){
        let p=worldCenter
        let size=nodesSize
        if p.x<left{
            var pos=CGPointMake(nodes[0][1].position.x-2*size.width, nodes[0][1].position.y)
            delegate?.nodeWillMove?(nodes[0][1], toPosition: pos)
            nodes[0][1].position = pos
            pos=CGPointMake(nodes[1][1].position.x-2*size.width, nodes[1][1].position.y)
            delegate?.nodeWillMove?(nodes[1][1], toPosition: pos)
            nodes[1][1].position = pos
            var t=nodes[0][0]
            nodes[0][0]=nodes[0][1]
            nodes[0][1]=t
            t=nodes[1][0]
            nodes[1][0]=nodes[1][1]
            nodes[1][1]=t
            left-=size.width
            right-=size.width
        }
        if p.x>right{
            var pos=CGPointMake(nodes[0][0].position.x+2*size.width, nodes[0][0].position.y)
            delegate?.nodeWillMove?(nodes[0][0], toPosition: pos)
            nodes[0][0].position = pos
            pos=CGPointMake(nodes[1][0].position.x+2*size.width, nodes[1][0].position.y)
            delegate?.nodeWillMove?(nodes[1][0], toPosition: pos)
            nodes[1][0].position = pos
            var t=nodes[0][0]
            nodes[0][0]=nodes[0][1]
            nodes[0][1]=t
            t=nodes[1][0]
            nodes[1][0]=nodes[1][1]
            nodes[1][1]=t
            left+=size.width
            right+=size.width
        }
        if p.y>top{
            var pos=CGPointMake(nodes[1][0].position.x, nodes[1][0].position.y+size.height*2)
            delegate?.nodeWillMove?(nodes[1][0], toPosition: pos)
            nodes[1][0].position=pos
            pos=CGPointMake(nodes[1][1].position.x, nodes[1][1].position.y+size.height*2)
            delegate?.nodeWillMove?(nodes[1][1], toPosition: pos)
            nodes[1][1].position=pos
            var t=nodes[0][0]
            nodes[0][0]=nodes[1][0]
            nodes[1][0]=t
            t=nodes[0][1]
            nodes[0][1]=nodes[1][1]
            nodes[1][1]=t
            top+=size.height
            bottom+=size.height
        }
        if p.y<bottom{
            var pos=CGPointMake(nodes[0][0].position.x, nodes[0][0].position.y-2*size.height)
            delegate?.nodeWillMove?(nodes[0][0], toPosition: pos)
            nodes[0][0].position = pos
            pos=CGPointMake(nodes[0][1].position.x, nodes[0][1].position.y-2*size.height)
            delegate?.nodeWillMove?(nodes[0][1], toPosition: pos)
            nodes[0][1].position = pos
            var t=nodes[0][0]
            nodes[0][0]=nodes[1][0]
            nodes[1][0]=t
            t=nodes[0][1]
            nodes[0][1]=nodes[1][1]
            nodes[1][1]=t
            top-=size.height
            bottom-=size.height
        }
        if let d=delegate{
            let sceneRect=CGRectMake(p.x-scene.size.width/2, p.y-scene.size.height/2, scene.size.width, scene.size.height)
            for i in 0...3{
                let node=nodesList[i]
                let nodeRect=CGRectMake(node.position.x-size.width/2, node.position.y-size.height/2, size.width, size.height)
                if CGRectIntersectsRect(nodeRect,sceneRect){
                    if nodesInDisplay[i]==false{
                        d.nodeInDisplay(node)
                    }
                    nodesInDisplay[i]=true
                }else{
                    if nodesInDisplay[i]==true{
                        d.nodeOutDisplay(node)
                    }
                    nodesInDisplay[i]=false
                }
            }
        }
    }
    
    
}