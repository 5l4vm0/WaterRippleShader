# 🌊 Unity Water Ripple System

A dynamic ripple effect system for Unity that visualises water surface interaction through both **object collisions** and **mouse input**. This system is ideal for simulations, stylised water surfaces, or interactive environments.

https://github.com/user-attachments/assets/de1b14c9-ebf9-4d1f-a244-fc54cb6afe06

[YoutubeLink](https://youtu.be/0kJwr1bbHis)

## 💧 Ripple Types
### 1. **Object-Triggered Ripple**
  - Dynamic ripple trails following moving objects, such as boats trials.
### 2. **Mouse Input Ripple**
  - Ring ripples triggered by mouse clicks, ideal for user mouse interaction.
### 3. **Raindrop Ripple**
  - Simulates environmental raindrops using randomised UV inputs.
### 4.**Continuous Ripple**
  - Used for static floating objects like boats that floating up and down.

## 📌 Features

### 1. Two Interaction Types: 

- Object Collision Ripples
- Mouse Input Ripples
### 2. Addition Control: 
- Boat Movement control 
- Boat Floating Control


## 🎮 Interaction Types

### 1. Object Collision Ripples

Drag and drop ObjectTriggeredRippleWaterPlane prefab. 

- Ripples are triggered when the object enters the defined `waterTrigger`. The ripple’s centre is derived from a downward raycast that collects `textureCoord` from the collision with the water plane.
- Optional buoyancy behaviour moves the object up with ripple peaks.

### 2. Mouse Input Ripples

- Drag and drop RaindropSurface prefab.
- Left click on mouse, a ray is cast from the screen. If it hits the water surface (layer `"Water"`), it triggers ripples.

