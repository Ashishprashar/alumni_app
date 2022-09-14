const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { user } = require("firebase-functions/v1/auth");

admin.initializeApp();
var db = admin.firestore();
var fcm = admin.messaging();

exports.notificationFunction = functions.firestore.document("notification/{notification_id}").onCreate(async snap => {

  const notifiacation = snap.data();
  var userList = [];


  if (notifiacation["type"] == "application-rejected") {

    for (var i = 0; i < notifiacation["sentTo"].length; i++) {
      const userData = await admin.firestore().collection("temporary_fcm_token").doc(notifiacation["sentTo"][i]).get()

      userList.push(
        userData.data()["fcm_token"]
      );

    }
  }
  else {
    for (var i = 0; i < notifiacation["sentTo"].length; i++) {
      const userData = await admin.firestore().collection("user").doc(notifiacation["sentTo"][i]).get()

      userList.push(
        userData.data()["fcmToken"]
      );
      try {
        var count = 0;
        if (userData.data()["unread_notifications"]) {
          count = userData.data()["unread_notifications"];
        }
        await admin.firestore().collection("user").doc(notifiacation["sentTo"][0]).update({ "unread_notifications": count + 1 });
      } catch (error) {
        await admin.firestore().collection("user").doc(notifiacation["sentTo"][0]).update({ "unread_notifications": 1 });
      }

    }
  }
  console.log(userList)
  // else {
  //     userList.push(
  //       await admin.firestore().collection("user").doc(notifiacation["sentTo"][i]).get()
  //     );
  //   }
  // }


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

    admin.messaging().sendToDevice([userList[i]], payload, options).then(function (response) {
      console.log("=> Push sent :", response);
    })
      .catch(function (error) {
        console.log("=> Push error :", error);
      });
  }


  return;
});


// exports.postFunction = functions.firestore.document("post/{post_id}").onCreate(async snap => {
//   let uploaded_by = snap.data()["owner_id"];
//   const userData = await admin.firestore().collection("user").doc(uploaded_by).get()
//   var followerList = userData.data()["follower"]

//   await admin.firestore().collection("user").doc(uploaded_by).collection("feed").doc(snap.data()["id"]).set({
//     id: snap.data()["id"]
//   })

//   for (let index = 0; index < followerList.length; index++) {

//     await admin.firestore().collection("user").doc(followerList[i]).collection("feed").doc(snap.data()["id"]).set({
//       id: snap.data()["id"]
//     })
//   }


// })