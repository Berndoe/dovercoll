import 'package:capstone/services/waste_practices_service.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WastePractices extends StatefulWidget {
  const WastePractices({super.key});

  @override
  State<WastePractices> createState() => _WastePracticesState();
}

class _WastePracticesState extends State<WastePractices> {
  late Future<List<String>> _videoUrls;

  @override
  void initState() {
    super.initState();
    _videoUrls = WastePracticesService.fetchVideoUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        title: const Text(
          'Sustainable Waste Practices',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: _videoUrls,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No videos found'),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  String videoUrl = snapshot.data![index];
                  String? videoId = YoutubePlayer.convertUrlToId(videoUrl);
                  if (videoId == null) {
                    return ListTile(
                      title: const Text('Invalid Video URL'),
                      subtitle: Text(videoUrl),
                    );
                  }
                  return YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: videoId,
                      flags: const YoutubePlayerFlags(
                        autoPlay: false,
                        mute: false,
                      ),
                    ),
                    showVideoProgressIndicator: true,
                  );
                });
          }
        },
      ),
    );
  }
}
