# 🚀 Socketing 

### 📝 Description

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
cd Socketing
```
2️⃣ **Open the project**
```
xed .
``` 
3️⃣ **Install dependencies (if necessary)**
```
# Swift Package Manager (SPM) will automatically resolve dependencies when opening the project in Xcode.
# If needed, you can manually resolve dependencies using:

swift package resolve
```

4️⃣ **Set up environment variables (if necessary)**   


By default, the project has environment variables configured in Xcode's Edit Scheme, so no additional setup is required in most cases.
However, if environment variables are missing after cloning, follow one of these methods to set them in Xcode:

1. Go to Product → Scheme → Edit Scheme.

2. Navigate to Run → Arguments → Environment Variables.

3. Add the following:
- BASE_URL = https://socketing.hjyoon.me/api/
- SOCKET_URL = https://socket.hjyoon.me/
- QUEUE_URL = https://queue.hjyoon.me/

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

SPM is used as a dependency manager. List of dependencies:  

- **[RxSwift](https://github.com/ReactiveX/RxSwift)** → Used for reactive programming, handling UI events and network responses asynchronously with `Relay`, `Driver`, `Subject`.  
- **[Socket.IO-Client-Swift](https://github.com/socketio/socket.io-client-swift)** → Enables real-time data communication using WebSocket-based Socket.IO for message exchange with the server.
- **[Starscream](https://github.com/daltoniam/Starscream)** → Manages WebSocket connections, facilitating real-time communication with the server.    
- **[SnapKit](https://github.com/SnapKit/SnapKit)** → Simplifies Auto Layout implementation, allowing for intuitive and concise UI layout management in code.  
- **[Toast-Swift](https://github.com/scalessec/Toast-Swift.git)** → Displays brief notifications to users, commonly used for error messages or status updates in a toast-style popup.  

---
### 🌟 Key Features

✔ Socket-based communication

✔ Reactive programming with RxSwift

✔ MVVM architecture for better scalability

✔ User authentication & token validation  

