import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/chat_screen.dart';
import 'package:zapxx/view/nav_bar/user/message/chat_model.dart';
import 'package:zapxx/view/nav_bar/user/message/widgets/message_search_text_field_widget.dart';
import 'package:zapxx/view/nav_bar/user/message/widgets/message_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/view_model/user_view_model.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  TextEditingController searchController = TextEditingController();
  final List<Chat> chatsList = [];
  void fetchChat() async {
    HomeHttpApiRepository repository = HomeHttpApiRepository();
    final token = SessionController().authModel.response.token;
    ChatModel chatModel = await repository.fetchChatList({
      'Authorization': token,
    });
    setState(() {
      chatsList.addAll(chatModel.chats);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchChat(); // Call the fetchChat method when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context, listen: false);
    final currentUserId = userProvider.authModel!.response.user.id;

    final validChats =
        chatsList.where((chat) {
          return chat.users.any((user) => user.id != currentUserId);
        }).toList();
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const CustomAppBar(title: 'Messages', leadingIcon: SizedBox()),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17.w),
          child: Column(
            children: [
              MessageSearchTextField(searchController: searchController),
              const SizedBox(height: 16),
              Expanded(
                child:
                    validChats.isEmpty
                        ? const Center(child: Text('No conversations found'))
                        : ListView.builder(
                          itemCount: validChats.length,
                          itemBuilder: (context, index) {
                            final chat = validChats[index];
                            final otherUser = chat.users.firstWhere(
                              (user) =>
                                  user.id !=
                                  userProvider.authModel!.response.user.id,
                            );
                            final lastMessage =
                                chat.messages.isNotEmpty
                                    ? chat.messages.last.content
                                    : "No messages yet";
                            final time =
                                chat.messages.isNotEmpty
                                    ? DateFormat.yMd()
                                    // displaying formatted date
                                    .format(chat.messages.last.createdAt)
                                    : "00:00:00";
                            final newtime =
                                chat.messages.isNotEmpty
                                    ? DateFormat.jmz()
                                    // displaying formatted date
                                    .format(chat.messages.last.createdAt)
                                    : "00:00:00";
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ChatScreen(
                                          userId: otherUser.id.toString(),
                                          id:
                                              chat.messages.single.chatId
                                                  .toString(),
                                          name: otherUser.fullName ?? 'No name',
                                          image:
                                              otherUser.profileImage == null
                                                  ? "https://static.vecteezy.com/system/resources/previews/001/840/618/non_2x/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector.jpg"
                                                  : otherUser.profileImage!.url,
                                        ),
                                  ),
                                );
                              },
                              child: MessageTile(
                                newtime: newtime,
                                image:
                                    otherUser.profileImage == null
                                        ? "https://static.vecteezy.com/system/resources/previews/001/840/618/non_2x/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector.jpg"
                                        : AppUrl.baseUrl +
                                            "/" +
                                            otherUser.profileImage!.url,
                                name: otherUser.fullName ?? 'No name',
                                message: lastMessage,
                                time: time.toString(),
                                unreadCount: 0,
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
