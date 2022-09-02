const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
var db = admin.firestore();
var fcm = admin.messaging();

exports.notificationFunction = functions.firestore.document("notification/{notification_id}").onCreate(async snap => {

  const notifiacation = snap.data();
  var userList = [];


  if (notifiacation["type"] == "application-rejected" || notifiacation["type"] == "application-accepted") {
    userList.push(
      await admin.firestore().collection("applicationResponse").doc(notifiacation["sentTo"][0]).get()
    );
  } else {
    for (var i = 0; i < notifiacation["sentTo"].length; i++) {
      userList.push(
        await admin.firestore().collection("user").doc(notifiacation["sentTo"][i]).get()
      );
    }
  }


  const payload = {
    "data": {
      "action": notifiacation["type"],
      click_action: 'FLUTTER_NOTIFICATION_CLICK',

      "title": notifiacation["content"],
      'sound': 'default',
    },
    "notification": {
      click_action: 'FLUTTER_NOTIFICATION_CLICK',

      "title": notifiacation["content"],
      'sound': 'default',

    },

  };

  var options = {
    priority: 'high',
    contentAvailable: true,//<-- will give content-available: 1
  };


  //sendMail to admin

  for (var i = 0; i < userList.length; i++) {

    admin.messaging().sendToDevice([userList[i].data()["fcmToken"]], payload, options).then(function (response) {
      console.log("=> Push sent :", response);
    })
      .catch(function (error) {
        console.log("=> Push error :", error);
      });
  }


  return;
});