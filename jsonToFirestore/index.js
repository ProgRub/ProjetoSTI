// Imports
const firestoreService = require('firestore-export-import');
const firebaseConfig = require('./config.js');
const serviceAccount = require('./serviceAccount.json');
const request = require('request');
var fs = require('fs');


// JSON To Firestore
async function jsonToFirestore() {
  try {
    console.log('Initializing Firebase');
    await firestoreService.initializeFirebaseApp(serviceAccount, firebaseConfig.databaseURL);
    console.log('Firebase Initialized');

    await firestoreService.restore('jsonToFirestore\\moviesBACKUP.json');
    console.log('Upload Success');

    await firestoreService.restore('jsonToFirestore\\tvShowsBACKUP.json');
    console.log('Upload Success');
  }
  catch (error) {
    console.log(error);
  }
}

async function exportFirestore() {
  console.log('Initializing Firebase');
  await firestoreService.initializeFirebaseApp(serviceAccount, firebaseConfig.databaseURL);
  console.log('Firebase Initialized');
  await firestoreService.backup("movies").then((data) =>
  fs.writeFile('jsonToFirestore\\moviesBACKUP.json', JSON.stringify(data), 'utf8',()=>{}));
  console.log('Backup Success');
  await firestoreService.backup("tvShows").then((data) =>
  fs.writeFile('jsonToFirestore\\tvShowsBACKUP.json', JSON.stringify(data), 'utf8',()=>{}));
  console.log('Backup Success');
} 

jsonToFirestore()