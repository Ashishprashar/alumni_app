
var fs = require("firebase-admin");

var serviceAccount = require("./the-hive-net-firebase-adminsdk-wfap0-6371045bb2.json");
fs.initializeApp({
    credential: fs.credential.cert(serviceAccount)
});
const db = fs.firestore();
function toTimestamp(strDate) {
    var datum = Date.parse(strDate);
    return datum / 1000;
}
async function trigger() {
    const usersDb = db.collection('user');
    // const liam = usersDb.doc('lragozzine');
    for (var i = 0; i <= 50; i++) {
        await usersDb.doc(i.toString()).set({
            favorite_music: [],
            gender: "Male",
            admin: true,
            bio: "",
            // created_at:Date.t,
            follower_count: 0,
            branch: "CSE",
            usn: "mzjxndmd",
            // updated_at: toTimestamp('02/13/2009 23:31:30'),
            favorite_shows_movies: [],
            tech_stack: [],
            profile_privacy_setting: "Everyone In College",
            connection: [],
            search_name: "TEST thisforscripttest" + i.toString(),
            id: i.toString(),
            fcmToken: "doP-QZltSz-mHIhOglrTPL:APA91bERD1X_bnayrkdIX7J3ihGuhs2bskeVsoc364E0_xMpO1NpjB3dEBt2kGhHzYM0w1vD7xrWaKRF3U0aRqeoMekIrf28KOyO0P7BBkxIIkwk_9yffyZy4TvyLf8rQ9MPdLYSxFie",
            email: "testpagination@gmail.com",
            unread_notifications: null,
            follow_request: [],
            follower: [],
            profile_pic: "https://lh3.googleusercontent.com/a/AItbvmlo6jUMppXTfnq01gzczMc0IPcCGQTtxS-fkYGe=s96-c",
            post_privacy_setting: "Everyone In College",
            link_to_social: { "twitter": "", "github": "", "facebook": "", "instagram": "", "linkedin": '', "email": "testpagination@gmail.com" },
            following_count: 0,
            following: [],
            name: "test thisforscripttest" + i.toString(),
            semester: "", post_count: 0,
            interests: [],
            status: "Alumnus/Alumna"
        }).then((v) => {
            console.log(v)

        });
    }

}
trigger()