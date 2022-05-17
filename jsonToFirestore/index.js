// Imports
const firestoreService = require('firestore-export-import');
const firebaseConfig = require('./config.js');
const serviceAccount = require('./serviceAccount.json');
const request = require('request');


// JSON To Firestore
async function jsonToFirestore() {
  try {
    console.log('Initializing Firebase');
    await firestoreService.initializeFirebaseApp(serviceAccount, firebaseConfig.databaseURL);
    console.log('Firebase Initialized');

    await firestoreService.restore('movies.json');
    console.log('Upload Success');

    await firestoreService.restore('tvShows.json');
    console.log('Upload Success');
  }
  catch (error) {
    console.log(error);
  }
}

const actorInformations = async (name) => {
  console.log("Photo "+name);
  request(`https://en.wikipedia.org/w/api.php?action=parse&format=json&page=List_of_awards_and_nominations_received_by_${name.replace(" ", "_")}&prop=wikitext&formatversion=2`, (err, res, body) => {
    if (err) { return console.log(err); }
    // console.log(JSON.parse( res.body)["pages"]);
    var text=JSON.parse(body).parse.wikitext;
    const result=text.split(/\r?\n/);
    const wins = result.filter(function (element) { return element.includes("{{won|"); });
    const noms = result.filter(function (element) { return element.includes("{{nom|"); });
    // console.log(wins);
    // console.log(noms);
    const lastWins = wins[wins.length - 1];
    const lastNoms = noms[noms.length - 1];
    if(lastWins.includes("colspan")){
      console.log("WINS: "+lastWins.split("{{")[1].split("}}")[0].split("|")[1]);
    }else{
      var numberOfWins=0;
      for (let index = 0; index < 5; index++) {
        numberOfWins += parseInt(wins[index].split("{{")[1].split("}}")[0].split("|")[1]);        
      }
      console.log("WINS: "+numberOfWins);
    }
    if(lastNoms.includes("colspan")){
      console.log("NOMINATIONS: "+lastNoms.split("{{")[1].split("}}")[0].split("|")[1]);
    }else{
      var numberOfNoms=0;
      for (let index = 0; index < 5; index++) {
        numberOfNoms += parseInt(noms[index].split("{{")[1].split("}}")[0].split("|")[1]);        
      }
      console.log("NOMINATIONS: "+numberOfNoms);
    }
    // console.log("WINS: "+lastWins.split("{{")[1].split("}}")[0].split("|")[1]);
    // console.log("NOMINATIONS: "+lastNoms.split("{{")[1].split("}}")[0].split("|")[1]);
  });
  console.log();
  request(`https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=${name.replace(" ", "%20")}`, (err, res, body) => {
    if (err) { return console.log(err); }
    var json=JSON.parse(body);
    const newLocal = json.query;
    const newLocal_1 = newLocal.pages;
    for (const key in newLocal_1) {
      if (Object.hasOwnProperty.call(newLocal_1, key)) {
        console.log(newLocal_1[key].extract.split('\n')[0]);
        console.log();
        return;
      }
    }
  });

}

actorInformations("Kevin Spacey");