const String kNotificationKeyPost = "post";
const String kNotificationKeyChat = "chat";
const String kNotificationKeyFollowRequest = "follow-request";
const String kNotificationKeyFollowAccepted = "follow-accepted";
const String kNotificationKeyLike = "like";
const String kNotificationKeyApplicationAccepted = "application-accepted";
const String kNotificationKeyApplicationRejected = "application-rejected";
const String kNotificationKeyComment = "comment";
const String kNotificationKeyPoke = "poke";
const String kDefaultPrivacySetting = "Everyone In College";

enum ApplicationStatus {
  Accepted, // take the user to the home screen
  Rejected, // show the user rejection letter, and help him try again
  Pending,
  NotYetApplied, // show the  user the applcation is pending screen.
}
