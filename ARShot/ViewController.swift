//
//  ViewController.swift
//  ARShot
//
//  Created by David Peng on 2018/12/5.
//  Copyright © 2018 David Peng. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
//        sceneView.scene = scene
        addTapGestureToSceneView()
        
        addBall(x: 0, y: 0, z: -0.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer: )))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        
        let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
        if let hitTestResultsWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
            print(hitTestResultsWithFeaturePoints.worldTransform.columns.3.x,
                  hitTestResultsWithFeaturePoints.worldTransform.columns.3.y,
                  hitTestResultsWithFeaturePoints.worldTransform.columns.3.z)
        } else {
            print("No feature points detected.")
        }
        
    }
    
    func addBall(x: Float = 0, y: Float = 0, z: Float = 0) {
//        guard let frame = sceneView.session.currentFrame else { return }
//        let camMatrix = SCNMatrix4(frame.camera.transform)
//        let direction = SCNVector3Make(-camMatrix.m31 * 5.0, -camMatrix.m32 * 10.0, -camMatrix.m33 * 5.0)
        
        let ball = SCNSphere(radius: 0.01)
        
        let ballNode = SCNNode()
        ballNode.geometry = ball
        ballNode.position = SCNVector3(x, y, z)
        ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        ballNode.physicsBody?.categoryBitMask = 3
        ballNode.physicsBody?.contactTestBitMask = 1
        
        sceneView.scene.rootNode.addChildNode(ballNode)
        ballNode.runAction(SCNAction.sequence([SCNAction.wait(duration: 10.0), SCNAction.removeFromParentNode()]))
//        ballNode.physicsBody?.applyForce(direction, asImpulse: true)
    }
}
