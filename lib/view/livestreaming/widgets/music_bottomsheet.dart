import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MusicBottomSheet {
  static const String deezerBaseUrl = "https://api.deezer.com";

  // Fetch music tracks from Deezer
  static Future<List<Map<String, dynamic>>> getMusicList(String query) async {
    final url = Uri.parse("$deezerBaseUrl/search?q=$query");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tracks = data['data'] as List;
        return tracks.map<Map<String, dynamic>>((track) {
          return {
            'id': track['id'].toString(),
            'title': track['title'],
            'artist': track['artist']['name'],
            'albumCover': track['album']['cover_big'],
            'preview': track['preview'], // 30-sec preview URL
          };
        }).toList();
      } else {
        print("Failed to fetch music: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching music: $e");
      return [];
    }
  }

  static void show(BuildContext context, String channelId) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.grey[200],
      isScrollControlled: true,
      builder: (context) {
        return MusicBottomSheetContent(channelId: channelId);
      },
    );
  }
}

class MusicBottomSheetContent extends StatefulWidget {
  final String channelId;

  const MusicBottomSheetContent({required this.channelId});

  @override
  _MusicBottomSheetContentState createState() =>
      _MusicBottomSheetContentState();
}

class _MusicBottomSheetContentState extends State<MusicBottomSheetContent> {
  List<Map<String, dynamic>> musicList = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMusic("trending");
  }

  Future<void> fetchMusic(String query) async {
    setState(() {
      isLoading = true;
    });

    final result = await MusicBottomSheet.getMusicList(query);
    setState(() {
      musicList = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              "select_music".tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "search_music".tr,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  fetchMusic(query);
                }
              },
            ),
            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) =>
                  Divider(color: Colors.grey[400]),
              itemCount: musicList.length,
              itemBuilder: (context, index) {
                final music = musicList[index];
                return ListTile(
                  leading: Image.network(
                    music['albumCover'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    music['title'],
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(music['artist'],
                      style: TextStyle(color: Colors.grey[700])),
                  trailing: Icon(Icons.play_arrow, size: 24,
                      color: Colors.blue),
                  onTap: () {
                    updateCurrentMusic(music['id'], music['preview'], widget.channelId);
                    print('ppp ${music['preview']}');
                    Navigator.pop(context); // Close the bottom sheet
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> updateCurrentMusic(String trackId, String previewUrl, String channelId) async {
    try {
      DocumentReference docRef =
      FirebaseFirestore.instance.collection('livestreams').doc(channelId);

      // Store trackId and previewUrl as separate fields in Firestore
      await docRef.set({
        'currentmusic_id': trackId,
        'currentmusic': previewUrl,
      }, SetOptions(merge: true));

      print("Music updated successfully in Firebase:");
      print("Track ID: $trackId");
      print("Preview URL: $previewUrl");

    } catch (e) {
      print("Error updating music: $e");
    }
  }




}

void showMusicSelectionSheet(BuildContext context, String channelId) {
  MusicBottomSheet.show(context, channelId);
}
