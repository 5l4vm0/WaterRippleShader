# Object & Input-Driven Ripple System for Unity

A dynamic ripple effect system for Unity that visualises water surface interaction through both **object collisions** and **mouse input**. This system is ideal for simulations, stylised water surfaces, or interactive environments.

https://github.com/user-attachments/assets/de1b14c9-ebf9-4d1f-a244-fc54cb6afe06

[YoutubeLink](https://youtu.be/0kJwr1bbHis)


## Features

- **RingRipple Shader**: Concentric ring waves ideal for object splashes or waves
- **DropRipple Shader**: Cosine-based drop ripples 
- **Object Collision Detection**: Ripples triggered on contact with a water plane
- **Mouse Input Support**: Interactively create ripples using mouse clicks
-  Customisable ripple behaviour 


## Interaction Types

### 1. Object Collision Ripples

Drag and drop ObjectTriggeredDropRippleWaterPlane or ObjectTriggeredRingRippleWaterPlane. 

-Ripples are triggered when the object enters the defined `waterTrigger`. The ripple’s centre is derived from a downward raycast that collects `textureCoord` from the collision with the water plane.
- Optional buoyancy behaviour moves the object up with ripple peaks.

### 2. Mouse Input Ripples

Drag and drop MouseInputDropRippleWaterPlane or MouseInputRingRippleWaterPlane.

- Right click on mouse, a ray is cast from the screen. If it hits the water surface (layer `"Water"`), it triggers ripples.

