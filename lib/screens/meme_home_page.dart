import 'package:flutter/material.dart';
import 'package:meme_app/models/meme_models.dart';
import 'package:meme_app/services/meme_services.dart';
import 'package:meme_app/widgets/meme_card.dart';

class MemeHomePage extends StatefulWidget {
  const MemeHomePage({super.key});

  @override
  State<MemeHomePage> createState() => _MemeHomePageState();
}

class _MemeHomePageState extends State<MemeHomePage> {
  List<Memes> memes = [];
  bool isLoading = true;
  Color backgroundColor = const Color(0xFF4A148C);
  Color textColor = const Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    fetchMemes();
  }

  Future<void> fetchMemes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await MemeServices.fetchMems(context);
      if (response.success != true) {
        throw Exception('API returned success: false');
      }
      if (response.data == null) {
        throw Exception('No data received from API');
      }
      setState(() {
        memes = response.data!.memes ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch memes: $e'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(label: 'Retry', onPressed: fetchMemes),
        ),
      );
    }
  }

  void updatecolor(Color color) {
    setState(() {
      backgroundColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meme App'), centerTitle: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A148C),
              Color(0xFF6A1B9A),
              Color(0xFF8E24AA),
              Color(0xFFAB47BC),
            ],
          ),
        ),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : memes.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No memes available',
                        style: TextStyle(color: textColor, fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchMemes,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  itemCount: memes.length,
                  itemBuilder: (context, index) {
                    final meme = memes[index];
                    return MemeCard(
                      id: meme.id ?? '',
                      name: meme.name ?? 'Unknown',
                      url: meme.url ?? '',
                      width: meme.width,
                      height: meme.height,
                      boxCount: meme.boxCount,
                      captions: meme.captions,
                      onColourExtract: updatecolor,
                    );
                  },
                ),
      ),
    );
  }
}
