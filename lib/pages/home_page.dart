import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> playlists = List.generate(6, (index) => "Playlist ${index + 1}");
  bool isAllCategorySelected = true;
  bool isMusicCategorySelected = false;
  bool isMusicFollowingSelected = false;
  bool isPodcastsCategorySelected = false;
  bool isPodcastsFollowingSelected = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 45),
                child: Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all<Size>(const Size(50, 30)),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected) || isAllCategorySelected) {
                              return Color(0xFF1ED760);
                            }
                            return Color(0xFF282828);
                          },
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.black;
                            }
                            return Colors.white;
                          },
                        ),
                      ),
                        onPressed: (){
                          // ToDo: xem cả nhạc và podcasts
                          setState(() {
                            isAllCategorySelected = true;
                            isMusicCategorySelected = false;
                            isMusicFollowingSelected = false;
                            isPodcastsCategorySelected = false;
                            isPodcastsFollowingSelected = false;
                          });
                        },
                        child: Text('Tất cả', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all<Size>(const Size(40, 30)),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            ),
                            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected) || isMusicCategorySelected) {
                                  return const Color(0xFF1ED760);
                                }
                                return const Color(0xFF282828);
                              },
                            ),
                            foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected) || isMusicCategorySelected) {
                                  return Colors.black;
                                }
                                return Colors.white;
                              },
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isAllCategorySelected = false;
                              isMusicCategorySelected = true;
                              isMusicFollowingSelected = false;
                              isPodcastsCategorySelected = false;
                              isPodcastsFollowingSelected = false;
                            });
                          },
                          child: const Text('Nhạc', style: TextStyle(fontSize: 12)),
                        ),

                        const SizedBox(width: 5,),

                        // Text “Đang theo dõi” chỉ hiện khi nhạc được chọn
                        if (isMusicCategorySelected)
                          TextButton(
                            style: ButtonStyle(
                              fixedSize: WidgetStateProperty.all<Size>(const Size(100, 30)),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                isMusicFollowingSelected ? const Color(0xFF19B350) : const Color(0xFF282828),
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                isMusicFollowingSelected ? Colors.black : Colors.white,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isMusicFollowingSelected = !isMusicFollowingSelected;
                              });
                            },
                            child: const Text('Đang theo dõi', style: TextStyle(fontSize: 12)),
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all<Size>(const Size(75, 30)),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            ),
                            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected) || isPodcastsCategorySelected) {
                                  return const Color(0xFF1ED760);
                                }
                                return const Color(0xFF282828);
                              },
                            ),
                            foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected) || isPodcastsCategorySelected) {
                                  return Colors.black;
                                }
                                return Colors.white;
                              },
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isAllCategorySelected = false;
                              isMusicCategorySelected = false;
                              isMusicFollowingSelected = false;
                              isPodcastsCategorySelected = true;
                              isPodcastsFollowingSelected = false;
                            });
                          },
                          child: const Text('Podcasts', style: TextStyle(fontSize: 12)),
                        ),

                        const SizedBox(width: 5,),

                        // Text “Đang theo dõi” chỉ hiện khi podcasts được chọn
                        if (isPodcastsCategorySelected)
                          TextButton(
                            style: ButtonStyle(
                              fixedSize: WidgetStateProperty.all<Size>(const Size(100, 30)),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                isMusicFollowingSelected ? const Color(0xFF19B350) : const Color(0xFF282828),
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                isMusicFollowingSelected ? Colors.black : Colors.white,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isMusicFollowingSelected = !isMusicFollowingSelected;
                              });
                            },
                            child: const Text('Đang theo dõi', style: TextStyle(fontSize: 12)),
                          ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Trang chủ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF282828),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[800],
                          child: const Icon(Icons.music_note, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            playlists[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
