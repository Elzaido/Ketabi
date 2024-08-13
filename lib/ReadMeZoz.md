# Ketabi project: 
An app where you can sell, donate, buy, or get a book for free ... Ketabi designed specifically for the university students, so they can do the operations mentioned apove. Also, there is a chat service so they can make the deal done with no need to go outside the app.

# State management system:
BloC.
# Back-end technology:
Firebase.

### BloC Notes ###
- Cubit folder consist of there sup-folder, each one is handling the logic of a part of the app.
- In eacn of them, Cubit file contains the logic of the app where the functions are implemented, and the state file contains the states of the app. 
- Unlike GetX, in BloC states are initialized and emitted manually. 

### Firebase Notes ###
Firebase Messeging: used for notifications.
Firebase Options file: created direclty when connect the app to firebase, it contains the the keys and Ids responsable about the connection.
Firebase storage: used for storing media, like photos, videos, etc.
Firebase Auth: used for the authentication process.
Cloud Firestore: used to store the data of our app, like users, posts, chats, etc.
Http: this backage used in this app to use the Firebase messeging API which is responsable about sending chat notifications. 

-- to be continued ...