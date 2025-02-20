const functions = require("firebase-functions");
const {RtcTokenBuilder, RtcRole} = require("agora-access-token");

const appId = "7fbb7f222c2840cc8da6d3823be8b249";
const appCertificate = "80aaf17b0a6b43e696a5e145a8cd09da";

exports.generateAgoraToken = functions.https.onCall((data, context) => {
  const channelName = data.channelName;
  const uid = data.uid;
  const role = RtcRole.PUBLISHER;

  const expirationTimeInSeconds = 3600;
  const currentTimeInSeconds = Math.floor(Date.now() / 1000);
  const privilegeExpiredTs = currentTimeInSeconds + expirationTimeInSeconds;

  const token = RtcTokenBuilder.buildTokenWithUid(
      appId,
      appCertificate,
      channelName,
      uid,
      role,
      privilegeExpiredTs,
  );

  return {token};
});
