const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { logger } = require("firebase-functions");
const { RtcTokenBuilder, RtcRole } = require("agora-access-token");

// Hard-coded Agora credentials (consider using environment config in production)
const appId = "0f0b7dc97d754349a53fa35ee828ab03";
const appCertificate = "0f0b7dc97d754349a53fa35ee828ab03";

exports.generateAgoraToken = onCall((request) => {
  const data = request.data;
  const channelName = data.channelName;
  const uid = data.uid;

  logger.info("Received channelName:", channelName);
  logger.info("Received uid:", uid);

  // Validate that channelName is a non-empty string
  if (typeof channelName !== "string" || channelName.trim() === "") {
    throw new HttpsError("invalid-argument", "Missing or invalid channelName.");
  }

  // Validate that uid is provided (0 is allowed, so check for undefined or null)
  if (uid === undefined || uid === null) {
    throw new HttpsError("invalid-argument", "Missing or invalid uid.");
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
