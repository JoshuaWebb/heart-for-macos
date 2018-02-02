//
//  ViewController.swift
//  Heart
//
//  Created by josh on 31/01/2018.
//  Copyright (c) 2018 joshuawebb. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var mainImageView: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: make dragging the image, drag the
        //       window... might need to subclass NSImage.
        //       Might be able to do it from here.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

