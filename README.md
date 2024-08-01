# Turns

<img src="https://github.com/AppleFoundationTurns/Turns/blob/main/images/AppIcon.png" alt="App Icon" style="width: 100px; height: 100px;">

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Gallery](#gallery)
- [Tools and Techniques](#tools-and-techniques)
- [Running the Project](#running-the-project)
- [Conclusion](#conclusion)
- [Credits](#credits)

## Overview

Turns is an engaging and cooperative platformer game developed in Swift as the Final Project for the "Apple Foundation Program 2024" at the University of Palermo. Inspired by the excitement of playing video games with friends during childhood, it allows two players to take turns controlling their characters, each with unique abilities, to navigate through levels and reach the goal. The game features a strategic "Turn" button to switch control between players, emphasizing teamwork and coordination.

You can download the [Keynote Pitch Presentation](https://www.parthenokit.cloud/kn/PALS124/Turns.key) that was showcased to Daryl Hawes from Apple and Michele Di Capua, Ignazio Finizio, and Luigi D'Acunto from the University Parthenope of Naples.

For more information about the Apple Foundation Course, visit [Palermo S1 Standard Course - July 19, 2024](https://www.parthenokit.cloud/finalreviewpal.aspx?cr=PALS124).

<p align="center">
  <a href="https://www.parthenokit.cloud/finalreviewpal.aspx?cr=PALS124" target="_blank">
    <img src="https://www.parthenokit.cloud/images/review/iospabianco.png" alt="UniPa Apple" style="width:30%;height:auto;">
  </a>
</p>

## Features

- **Cooperative Gameplay**: Players control two different characters, each with distinct abilities, and must work together to reach the end of the level.
- **Unique Turn Mechanic**: Players alternate control by pressing the "Turn" button, switching visibility and control between the two.
- **Single Tutorial Level**: A tutorial level helps players understand the game's mechanics and how to utilize the turn-based cooperation effectively.
- **Custom Assets**: All assets, including the logo, sprites, and music, are either created from scratch or sourced from free-to-use, non-copyrighted materials.

## Gallery

<img src="https://github.com/AppleFoundationTurns/Turns/blob/main/images/Menu.PNG" alt="Home Screen"> | <img src="https://github.com/AppleFoundationTurns/Turns/blob/main/images/Tutorial.PNG" alt="Tutorial">
:-------------------------:|:-------------------------:
|<img src="https://github.com/AppleFoundationTurns/Turns/blob/main/images/Player1.gif" alt="Player1"><br><b>Player 1 View</b>|<img src="https://github.com/AppleFoundationTurns/Turns/blob/main/images/Player2.gif" alt="Player2"><br><b>Player 2 View</b>|

## Tools and Techniques

### Swift and SwiftUI

**Swift** is the primary programming language used for the development of this project. Swift is known for its performance, safety, and modern syntax, which facilitates the creation of efficient and reliable code. 

**SwiftUI** is employed for building the user interface. SwiftUI is a framework that allows developers to design interfaces declaratively. It integrates seamlessly with Swift, enabling the creation of flexible and dynamic UIs using a minimal amount of code. Key features utilized include:
- **State Management**: Using `@State` and `@Binding` to manage state within views.
- **Composable Views**: Creating reusable and modular UI components.
- **Dynamic UIs**: Building responsive and adaptive interfaces that adjust to different device sizes and orientations.

### SpriteKit

**SpriteKit** is the framework used for 2D game development within this project. It provides a robust infrastructure for animation, physics simulation, and rendering. Key functionalities utilized include:
- **Node System**: Managing game elements as nodes, which can be hierarchically organized.
- **Physics Engine**: Implementing realistic physics interactions, such as collisions and movements.
- **Animation**: Creating smooth and performant animations using texture atlases and actions.

### AVFoundation

**AVFoundation** is employed for audio playback within the game. It supports a wide range of audio operations, such as playing background music and sound effects. Specific uses include:
- **AVAudioPlayer**: Used to manage and play audio files, providing controls for volume, looping, and playback.
- **Sound Management**: Functions to start and stop audio playback based on views changes, ensuring an immersive audio experience.

### Multipeer Connectivity

The project incorporates multiplayer functionality using a custom-built interface. This includes:
- **Peer-to-Peer Communication**: Managing connections between multiple players to synchronize game states.
- **State Synchronization**: Sending and receiving game state information to ensure all players have a consistent view of the game.
- **Error Handling**: Managing connectivity issues and ensuring robust communication channels.

### Custom Physics and Collision Handling

Advanced custom physics and collision handling mechanisms are implemented to create unique gameplay experiences. This involves:
- **Custom Physics Bodies**: Defining physics bodies for various game elements, including custom shapes and sizes.
- **Collision Detection**: Implementing detailed collision detection algorithms to handle interactions between game elements.
- **Tile Map Physics**: Assigning physics properties to tile maps, enabling realistic movement and interactions on platforms and other surfaces.

### Algorithmic Tile Grouping

To optimize performance, an algorithm for grouping tiles is used. This algorithm:
- **Tile Grouping**: Groups adjacent tiles into larger physics bodies to reduce the number of individual physics calculations.
- **Optimization**: Enhances performance by minimizing the complexity of the physics simulation, allowing for smoother gameplay.

### Multi-Touch Handling

Multi-touch handling is crucial for the game’s control system. This includes:
- **Touch Events**: Detecting and managing multiple simultaneous touch events to allow for complex control schemes.

### Animation and Texture Management

Efficient management of animations and textures is achieved using:
- **Texture Atlases**: Storing multiple textures in a single image to reduce memory usage and improve performance.
- **Animation Sequences**: Creating smooth animations by sequencing textures and managing frame rates.

### Data Persistence

Data persistence is managed to save before sending and load after receiving game states between the two devices. This involves:
- **GameState**: Storing various pieces of game data, such as the player position, collected items, and player velocities. Complex game state information is serialized using the Codable protocol for efficient saving and loading.
- **AppState**: Storing small pieces of data, such as if the player is the host and which view to show during the gameplay.

## Running the Project

To run the project, you have two options:

### Option 1: Using Xcode (macOS only)

1. **Xcode**: Install the latest version of Xcode to build and run the application.
2. **macOS**: Ensure your Mac is running a recent version of macOS that supports the latest Swift, SwiftUI and SpriteKit features.

### Option 2: Installing from IPA File using AltStore (works on macOS and Windows)

Alternatively, you can install the app using an IPA file. Follow these steps to install the IPA file using AltStore:

   1. Go to the latest release on the [releases page](https://github.com/AppleFoundationTurns/Turns/releases).
   2. Download the IPA file to your computer.
   3. Download and install AltStore on your computer from [altstore.io](https://altstore.io).
   4. Open AltStore and connect your iOS device to your computer.
   5. Go to the “My Apps” tab in AltStore.
   6. Click the "+" button and select the downloaded IPA file.
   7. Enter your Apple ID and password if prompted.
   8. The app will be installed on your device.
   9. Navigate to "General" -> "Device Management" (or "Profiles & Device Management").
   10. Find the profile for the app you just installed and trust it.
   11. Now you can run the app from your device's home screen!

By following these steps, you can install the app using the IPA file with AltStore on your iOS device. This method is useful if you do not have a Mac or prefer not to build the app from Xcode directly.

## Conclusion

Through the development of Turns, we learned valuable lessons in cooperative game design and the implementation of unique gameplay mechanics. The project enhanced our skills in Swift programming and game development with SpriteKit. We also acquired hands-on experience with multiplayer functionality using Multipeer Connectivity and mastered the MVVM design pattern, which improved our ability to build modular and maintainable codebases. Overall, creating Turns was an enriching experience that deepened our understanding of game development and collaborative programming.

## Credits

- Federico Agnello - Coder / Game Designer / Video Editor
- Giuseppe Damiata - Coder / Game Designer
- Davide Testaverde - Software Engineer
- Alberto Scannaliato - Coder / Game Designer / Field Researcher
- Paolosalvatore Piazza - Coder / Field Researcher / Video Editor
- Fabrizio Mistretta - Graphic Designer / Game Designer
- Christopher Gallo - Game Designer / Field Researcher
- Irene Palazzolo - Game Designer / Field Researcher
- Antonino Pecoraro - SFX Designer
