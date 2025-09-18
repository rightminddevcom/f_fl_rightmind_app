// web/firebase-messaging-sw.js

importScripts("https://www.gstatic.com/firebasejs/9.22.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.22.2/firebase-messaging-compat.js");

// Firebase config من مشروعك (نفس اللي في firebase_options.dart)
firebase.initializeApp({
  apiKey: "AIzaSyB9zU2SYtL-V3mwbwss7LQkuBFzL4FBlFw",
  authDomain: "rm-sys.firebaseapp.com",
  projectId: "rm-sys",
  storageBucket: "rm-sys.appspot.com",
  messagingSenderId: "1014851799383",
  appId: "1:1014851799383:web:85151567e27f5654c89612",
  measurementId: "G-LV7NL9HJ4P"
});

// Init messaging
const messaging = firebase.messaging();
