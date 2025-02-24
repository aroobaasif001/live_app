const functions = require("firebase-functions");
const { RtcTokenBuilder, RtcRole } = require("agora-access-token");

// Hard-coded Agora credentials (consider using environment config in production)
const appId = "8f1bc40d90374b78be10a2e851ba9140";
const appCertificate = "a70411bd58d44c118544a86b469f3323";

exports.generateAgoraToken = functions.https.onCall((data, context) => {
  // Extract parameters from the incoming data object
  const channelName = data.channelName;
  const uid = data.uid;

  // Log received parameters for debugging
  console.log("Received channelName:", channelName);
  console.log("Received uid:", uid);

  // Validate that channelName is a non-empty string
  if (typeof channelName !== "string" || channelName.trim() === "") {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing or invalid channelName."
    );
  }

  // Validate that uid is provided (0 is allowed, so check for undefined or null)
  if (uid === undefined || uid === null) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing or invalid uid."
    );
  }

  // Set the role for the token
  const role = RtcRole.PUBLISHER;

  // Define token validity: 1 hour (3600 seconds)
  const expirationTimeInSeconds = 3600;
  const currentTimeInSeconds = Math.floor(Date.now() / 1000);
  const privilegeExpiredTs = currentTimeInSeconds + expirationTimeInSeconds;

  // Build the Agora token
  const token = RtcTokenBuilder.buildTokenWithUid(
    appId,
    appCertificate,
    channelName,
    uid,
    role,
    privilegeExpiredTs
  );

  // Return the token to the caller
  return { token };
});
