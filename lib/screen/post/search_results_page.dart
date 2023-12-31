import 'package:basketball_app/widgets/post_widgets/post_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/account.dart';
import '../../providers/area_provider.dart';
import '../../repository/posts_firebase.dart';
import '../../repository/users_firebase.dart';
import '../../widgets/common_widgets/snackbar_utils.dart';

class SearchResultsPage extends StatefulWidget {
  // final String? selectedLocation;
  final String? keywordLocation;
  final bool isEditing;

  const SearchResultsPage({
    super.key,
    // this.selectedLocation,
    this.keywordLocation,
    required this.isEditing,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Stream<QuerySnapshot> customStream;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing == true) {
      _setupGameCustomStream();
    } else {
      _setupTeamCustomStream();
    }
  }

  void _setupGameCustomStream() {
    final areaModel = Provider.of<AreaProvider>(context, listen: false);
    final String selectedValue = areaModel.selectedValue;
    final postRef = PostFirestore.gamePosts;

    try {
      if (selectedValue.isNotEmpty && widget.keywordLocation!.isNotEmpty) {
        List<String> resultList = [
          widget.keywordLocation as String,
          selectedValue
        ];
        customStream = postRef
            .where("prefecture", isEqualTo: selectedValue)
            .where("locationTagList", arrayContainsAny: resultList)
            .orderBy("created_time", descending: true)
            .snapshots();
      } else if (selectedValue.isNotEmpty) {
        customStream = postRef
            .where("prefecture", isEqualTo: selectedValue)
            .orderBy("created_time", descending: true)
            .snapshots();
      } else if (widget.keywordLocation!.isNotEmpty) {
        customStream = postRef
            .where("locationTagList", arrayContains: widget.keywordLocation)
            .orderBy("created_time", descending: true)
            .snapshots();
      }
    } catch (e) {
      showErrorSnackBar(context: context, text: 'エラーが発生しました $e');
    }
  }

  void _setupTeamCustomStream() {
    final areaModel = Provider.of<AreaProvider>(context, listen: false);
    final String selectedValue = areaModel.selectedValue;

    final postRef = PostFirestore.teamPosts;

    try {
      if (selectedValue.isNotEmpty && widget.keywordLocation!.isNotEmpty) {
        List<String> resultList = [
          widget.keywordLocation as String,
          selectedValue
        ];
        customStream = postRef
            .where("prefecture", isEqualTo: selectedValue)
            .where("location", arrayContainsAny: resultList)
            .orderBy("created_time", descending: true)
            .snapshots();
      } else if (selectedValue.isNotEmpty) {
        customStream = postRef
            .where("prefecture", isEqualTo: selectedValue)
            .orderBy("created_time", descending: true)
            .snapshots();
      } else if (widget.keywordLocation!.isNotEmpty) {
        customStream = postRef
            .where("location", arrayContains: widget.keywordLocation)
            .orderBy("created_time", descending: true)
            .snapshots();
      }
    } catch (e) {
      showErrorSnackBar(context: context, text: 'エラーが発生しました $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: customStream,
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            // データが読み込まれていない状態
            return const Center(
              child: CircularProgressIndicator(), // ローディング中の表示
            );
          } else if (postSnapshot.hasError) {
            // エラーが発生した場合
            return Center(
              child: Text(
                "データの読み込み中にエラーが発生しました ${postSnapshot.error}",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!postSnapshot.hasData || postSnapshot.data!.docs.isEmpty) {
            // データが存在しない場合
            return const Center(
              child: Text(
                "該当する投稿がありません",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            List<String> postAccountIds = [];
            postSnapshot.data!.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              if (!postAccountIds.contains(data["post_account_id"])) {
                postAccountIds.add(data["post_account_id"]);
              }
            });
            if (widget.isEditing == false) {
              return FutureBuilder<Map<String, Account>?>(
                future: UserFirestore.getPostUserMap(postAccountIds),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData || userSnapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (userSnapshot.connectionState == ConnectionState.done) {
                    Map<String, Account>? userData = userSnapshot.data;

                    return ListView.builder(
                      itemCount: postSnapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> data =
                            postSnapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        return TeamPostWidget(
                          data: data,
                          id: postSnapshot.data!.docs[index].id,
                          userData: userData as Map<String, Account>,
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else if (widget.isEditing == true) {
              return FutureBuilder<Map<String, Account>?>(
                future: UserFirestore.getPostUserMap(postAccountIds),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData || userSnapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (userSnapshot.connectionState == ConnectionState.done) {
                    Map<String, Account>? userData = userSnapshot.data;
                    return ListView.builder(
                      itemCount: postSnapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> data =
                            postSnapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        return GamePostWidget(
                          data: data,
                          id: postSnapshot.data!.docs[index].id,
                          userData: userData as Map<String, Account>,
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            }
          }
          return const SizedBox(); // または適切なウィジェットを返す
        },
      ),
    );
  }
}
