# 🚀 Socketing

### 📲 Download on the App Store
<a href="https://apps.apple.com/kr/app/socketing/id6741525412">
    <img src="https://github.com/user-attachments/assets/4c37a2ce-69b1-4f4b-9ef3-6ece2f0979d8" width="120">
</a>

https://apps.apple.com/kr/app/socketing/id6741525412  

---
### 📝 Description
- This project is built upon [everyone-falls-asleep](https://github.com/everyone-falls-asleep)
- The original project provides a web-based real-time ticketing program, and this app extends its functionality to a mobile platform using Swift and UIKit.  
---
### 🎥 Demo

<img src="https://github.com/user-attachments/assets/7a4f35c1-73ba-42df-8665-2e13461b0f5a" width="30%">


---
### ⚙️ System Requirements
- Xcode Version: 15.0
- macOS Version: Ventura 13.5 (M2)

### 🔧 Project Requirements
- Swift Version: 5.9
- iOS Deployment Target: 15.0 or later
- Dependencies: RxSwift, SocketIO, SnapKit, Starscream, Toast
  
---
### ⚙️ Installation

1️⃣ **Clone the repository**
```
git clone https://github.com/yeonupark/socketing-iOS
```
2️⃣ **Open the project**
```
cd socketing-iOS
xed .
``` 
3️⃣ **Set up environment variables**   

The project uses .xcconfig files to manage environment variables.     

🔹 Steps to Configure Environment Variables:
1. Navigate to the Configurations folder:
```
cd Configurations
```
2. Create .xcconfig files for different configurations:
- ```Debug.xcconfig```
- ```Release.xcconfig```
  
💡```.xcconfig``` files are ignored by Git

3. Inside each .xcconfig file, add the following variables
```
BASE_URL = [your-api-url]
SOCKET_URL = [your-socket-url]
QUEUE_URL = [your-queue-url]
```
4. Verify the configuration is applied correctly in Xcode:
- Go to Project → Info → Configurations
- Ensure the Debug and Release configurations reference the corresponding ```.xcconfig``` files.

▶️ **Running the App**

1. Open the project in Xcode

2. Select a simulator or physical device

3. Press Cmd + R to run the app

---
### 📌 Project Structure
```

📂 Socketing
 ├── 📂 Utils          
 ├── 📂 Components     
 ├── 📂 Extensions     
 ├── 📂 Base          
 ├── 📂 Network        
 ├── 📂 Views          
 ├── 📂 Controllers    
 ├── 📂 ViewModels     

```
- Utils: Reusable utility functions and helpers
- Extensions: Swift extensions for enhanced functionality
- Base: Base classes and protocols
- Network: Networking layer
- Views: UI screens
- Controllers: View controllers for handling UI logic and user interaction
- ViewModels: Business logic and data binding (MVVM)
---

### 🔗 Dependencies

Swift Package Manager (SPM) will automatically resolve dependencies when opening the project in Xcode.     
List of dependencies:  

- **[RxSwift](https://github.com/ReactiveX/RxSwift)** → Used for reactive programming, handling UI events and network responses asynchronously with `Relay`, `Driver`, `Subject`.  
- **[Socket.IO-Client-Swift](https://github.com/socketio/socket.io-client-swift)** → Enables real-time data communication using WebSocket-based Socket.IO for message exchange with the server.
- **[Starscream](https://github.com/daltoniam/Starscream)** → Manages WebSocket connections, facilitating real-time communication with the server.    
- **[SnapKit](https://github.com/SnapKit/SnapKit)** → Simplifies Auto Layout implementation, allowing for intuitive and concise UI layout management in code.  
- **[Toast-Swift](https://github.com/scalessec/Toast-Swift.git)** → Displays brief notifications or error messages in a toast-style popup.  

---
### 🌟 Key Features

✔ **Socket-based communication** – Real-time ticketing system powered by Socket.IO.

✔ **Reactive programming with RxSwift** – Efficient event-driven programming.  

✔ **WebView-based SVG rendering** – Renders a seating chart SVG in a WebView and overlays coordinate-based seat data.

✔ **Secure environment configuration** –  Manages environment variables using `.xcconfig` to protect sensitive information.

✔ **MVVM architecture** – Separates UI and business logic, improving modularity and maintainability.

---

### 📬 Contact

If you have any questions, feel free to reach out at [idepix5@gmail.com](mailto:idepix5@gmail.com).

