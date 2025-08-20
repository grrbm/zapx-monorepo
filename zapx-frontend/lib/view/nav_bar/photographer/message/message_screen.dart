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
  List<Chat> filteredChats = [];

  void fetchChat() async {
    HomeHttpApiRepository repository = HomeHttpApiRepository();
    final token = SessionController().authModel.response.token;
    ChatModel chatModel = await repository.fetchChatList({
      'Authorization': token,
    });
    setState(() {
      chatsList.addAll(chatModel.chats);
      filteredChats = List.from(chatsList);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchChat(); // Call the fetchChat method when the widget is initialized
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredChats = List.from(chatsList);
      } else {
        filteredChats =
            chatsList.where((chat) {
              final userList =
                  chat.users
                      .where(
                        (user) =>
                            user.id !=
                            Provider.of<UserViewModel>(
                              context,
                              listen: false,
                            ).authModel!.response.user.id,
                      )
                      .toList();
              if (userList.isEmpty) return false;
              final otherUser = userList.first;
              final name = (otherUser.fullName ?? '').toLowerCase();
              final username = (otherUser.username).toLowerCase();
              return name.contains(query) || username.contains(query);
            }).toList();
      }

      // Sort filtered chats in descending order based on last message timestamp
      filteredChats.sort((a, b) {
        final aTime =
            a.messages.isNotEmpty ? a.messages.last.createdAt : DateTime(1900);
        final bTime =
            b.messages.isNotEmpty ? b.messages.last.createdAt : DateTime(1900);
        return bTime.compareTo(aTime); // Descending order (most recent first)
      });
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context, listen: false);
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
                child: ListView.builder(
                  itemCount: filteredChats.length,
                  itemBuilder: (context, index) {
                    final chat = filteredChats[index];
                    final userList =
                        chat.users
                            .where(
                              (user) =>
                                  user.id !=
                                  userProvider.authModel!.response.user.id,
                            )
                            .toList();
                    if (userList.isEmpty) {
                      // Skip rendering this chat if no other user is found
                      return const SizedBox.shrink();
                    }
                    final otherUser = userList.first;
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
                                      chat.messages.isNotEmpty
                                          ? chat.messages.last.chatId.toString()
                                          : '',
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
                                    '/' +
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
