import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "hvatai",
        "private_key_id": "95715e2d25cbab620c74b9b163339e0b2fdddf91",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCLKHaNEdTV7MQP\nKGRIIZEX6t+PWBglqF8YPVNQWo1CwduumMS9+yGodGJ6etFpxiiRf2LjVCNrE5vm\no9kkZw4cxb2jrhIjEHXD1omFOqVQDHnNlFHN2VcSaErBh80NGI2HXAXL+Wi9FCD0\n2vMim9m7Pway65UEn9yL81JBT0c42WPt9aeEDSLCXPBFE1J4KJIo4TYBP7UZ34y5\nbIBSR69nJJW7avwYKrBbInZVN2fTvMQ72E8I+8t7HhSEAGjt1QcCf+cZUDC+yhSv\nV7iKELgIMtcffG5bQO5vpOcbmrVKXzPhATG+2X8hreXRCKJuT+Hpyd0tpos0bbc6\nfUCs4sLnAgMBAAECggEAEORvC63b88IDhMGG9tiYR9p7m+d6OuwG6ybam7j6R93H\ngJjL3TIEgnHqWGrbS+dBmnPnuafHiuJ8/NDr9YbLCEQawqlJS1derFC5LeKSGbcB\n/CoiigX1k2b0mCyXgBz4ZTOPApU6mSU94OtJM2zOz/OVKRf+5WpQd+6oEASDJUvU\nhi2soUb8v8k+rlXqJPMxl2B8BN9B9d6Yemx2JsuKKDILjutuK/zNo/Xv0sJ/VlkO\ncrnHmHIn6wuB9OBwbIQHygixT3zs9IzNRgDYmz/NIMnxSsNNHuR1odsDSkGKrO7w\nwOQDieOhb5YEwRwFBCKYrlX0p5R2iUSmPFH5UDWl9QKBgQDBvn4CPQhOI0q7eVxc\n2TIjGHLQp+/IiUzUgzxslXpMVklB2gFux+ejztlrMd6qHWuVqYZanZXW2wP4piZ+\nEuR6OGvnrSyqyCIeJz3JtSgHP8tgv40FwAMhEk5UWKJnLhW6y07yF+Rdf8kfDUZJ\nhYV9co1NJqJmW5ydqegZJpYarQKBgQC337BynPcW2mCQKlmb3KvLGAXl4FvJlQMT\n0xxRGDd3cZSO0UZgnpo73/K/E6IKrFhVDG6drH0ABsFgDsAmAG39bgv5XfCyyiTv\nkje+RT+wv2yHKmLnHKWL5wLnOQpDYS2yTe/C1T3Yby5XvjcvaNfhoM60Leqz5Cdn\nX+OaPKB6YwKBgAPj81vQJe6LvuBs23Hx2pPh1cxi0unP9/78c6Yqij4mLWppGkZD\nNV+Qs8T3R2VbGeHzeYMwTuX1l+rSS0uUzYm2wFPyokb7pdO9Lfxy6s7adRcIQaiv\n5mAvoesHrJstzbnmgztRR4CpJDy/Y33udHPEbRnzgKdVh5uS4do/cBwxAoGBAIV8\ntYJfhdpna1b+B9PpXiaxKAb83GX58iQATTxqUko6gNk2ANvACMSTDo29WRRajj4g\nKmX5hT3xqY1s5/4urasgqzy8ADQsIKh0BFfzugs8zTNLiEW0PFLWwPrQJC1KbXxW\nrEtLt/xaqtA0Xafje2Zn8ehItW0no5uet4OPpAl1AoGABR1IbgwymN6B+Km0wNfX\nj9gUSw3XhvRxUGucCy9gdSyH7ZChcPLB27JKCMazCT0rsm575gzf8TvPdP+r6v9H\n6Da3LXgKd4dS12NdMdYw+WpxDZ5gm5FOzPclLiWgMdaZLedNU8uKysW+o8YmgDPM\nsEuuDMhDUasVgl8/B+TghEQ=\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@hvatai.iam.gserviceaccount.com",
        "client_id": "115631893577742507656",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40hvatai.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
