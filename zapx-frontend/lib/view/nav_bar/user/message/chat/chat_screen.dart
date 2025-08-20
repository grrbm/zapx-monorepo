import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/components/network_image_widget.dart';
import 'package:zapxx/configs/components/timeformat.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/booking/all_booking/all_booking_screen.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/messages_model.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/widgets/booking_request_widget.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/widgets/chat_header_widget.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/widgets/message_input_widget.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/widgets/message_item_widget.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/widgets/offer_widget.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/model/offer_model.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String image;
  final String id;
  final String userId;
  const ChatScreen({
    super.key,
    required this.name,
    required this.image,
    required this.id,
    required this.userId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<MessageModel> chatMessage = [];
  List<UserModel> chatUsers = []; // Add variable to store chat users
  String currentUserId = '';
  late ScrollController _scrollController;
  bool _isLoading = true;
  bool _hasError = false;
  Map<String, dynamic>? _lastOfferData; // Store the last offer data

  // Offer related state
  List<Offer> offers = [];
  bool _isLoadingOffers = false;
  bool _isProcessingOffer = false;

  void fetchMessages() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;
      final userId = SessionController().authModel.response.user.id.toString();
      currentUserId = userId;

      // If no chat ID is provided, we need to create a new chat
      if (widget.id.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasError = false;
        });
        return;
      }

      ChatMessages chatMessages = await repository.fetchChatMessages({
        'Authorization': token,
      }, widget.id);

      setState(() {
        chatMessage.clear();
        chatMessage.addAll(chatMessages.messages.reversed);
        chatUsers = chatMessages.users; // Store the chat users
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void fetchOffers() async {
    try {
      setState(() {
        _isLoadingOffers = true;
      });

      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;

      print('🔍 Fetching offers...');
      OfferModel offerModel = await repository.getOffers({
        'Authorization': token,
      });

      print(
        '✅ Offers fetched successfully: ${offerModel.offers.length} offers',
      );
      for (var offer in offerModel.offers) {
        print(
          '  - Offer ID: ${offer.id}, Price: \$${offer.price}, Date: ${offer.date}',
        );
      }

      setState(() {
        offers = offerModel.offers;
        _isLoadingOffers = false;
      });

      // Debug: Print total offers loaded
      print('📊 Total offers loaded: ${offers.length}');
      print('📊 Offer IDs: ${offers.map((o) => o.id).toList()}');
      print('📊 Offers will be displayed at top of chat');
    } catch (e) {
      print('❌ Error fetching offers: $e');
      setState(() {
        _isLoadingOffers = false;
        offers = []; // Set empty offers list on error
      });

      // Don't show error message to user as offers are optional
      print(
        '⚠️ Offers feature is currently unavailable, continuing without offers',
      );
    }
  }

  void _handleAcceptOffer(int offerId) async {
    try {
      setState(() {
        _isProcessingOffer = true;
      });

      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;

      await repository.acceptOffer(offerId, {'Authorization': token});

      // Remove the accepted offer from the list
      setState(() {
        offers.removeWhere((offer) => offer.id == offerId);
        _isProcessingOffer = false;
      });

      Utils.flushBarSuccessMessage('Offer accepted successfully!', context);
    } catch (e) {
      setState(() {
        _isProcessingOffer = false;
      });
      Utils.flushBarErrorMessage('Failed to accept offer: $e', context);
    }
  }

  void _handleDeclineOffer(int offerId) async {
    try {
      setState(() {
        _isProcessingOffer = true;
      });

      HomeHttpApiRepository repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;

      await repository.declineOffer(offerId, {'Authorization': token});

      // Remove the declined offer from the list
      setState(() {
        offers.removeWhere((offer) => offer.id == offerId);
        _isProcessingOffer = false;
      });

      Utils.flushBarSuccessMessage('Offer declined successfully!', context);
    } catch (e) {
      setState(() {
        _isProcessingOffer = false;
      });

      // Check if it's a backend error
      if (e.toString().contains('Invalid `prisma.booking.findFirst()`')) {
        Utils.flushBarErrorMessage(
          'Backend error: Please contact support. Error: Database query issue.',
          context,
        );
      } else {
        Utils.flushBarErrorMessage('Failed to decline offer: $e', context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    fetchMessages();

    // Fetch offers after a short delay to avoid conflicts
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        fetchOffers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildDateHeader(DateTime date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            DateTimeFormatter.formatDateHeader(date),
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            NetworkImageWidget(
              borderRadius: 20,
              imageUrl:
                  widget.image.isNotEmpty
                      ? AppUrl.baseUrl + "/" + widget.image
                      : 'assets/images/profile_picture.png',
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.name,
                    textOverflow: TextOverflow.ellipsis,
                    fontSized: 21.0,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllBookingScreen(),
                ),
              );
            },
            child: Image(
              width: 22.w,
              height: 22.w,
              image: const AssetImage('assets/images/book.png'),
            ),
          ),
          SizedBox(width: 14.w),
        ],
      ),
      body: Column(
        children: [
          const Divider(thickness: 1),
          if (_isLoading)
            Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_hasError)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Failed to load messages',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: fetchMessages,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child:
                  chatMessage.isEmpty && offers.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No messages yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Start a conversation with ${widget.name}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: () async {
                          await Future.wait([
                            Future(() => fetchMessages()),
                            Future(() => fetchOffers()).catchError((e) {
                              print('⚠️ Offers refresh failed: $e');
                              return null;
                            }),
                          ]);
                        },
                        child: Builder(
                          builder: (context) {
                            // Combine offers and messages into a single timeline, sorted by createdAt
                            final List<_TimelineItem> timeline = [
                              ...offers.map(
                                (offer) => _TimelineItem.offer(offer),
                              ),
                              ...chatMessage.map(
                                (msg) => _TimelineItem.message(msg),
                              ),
                            ]..sort(
                              (a, b) => a.createdAt.compareTo(b.createdAt),
                            );

                            // Debug: Print createdAt for all timeline items
                            for (var i = 0; i < timeline.length; i++) {
                              final item = timeline[i];
                              if (item.isOffer) {
                                print(
                                  'TIMELINE [$i] OFFER createdAt: ${item.createdAt} (id: ${item.offer!.id})',
                                );
                              } else {
                                print(
                                  'TIMELINE [$i] MESSAGE createdAt: ${item.createdAt} (id: ${item.message!.id})',
                                );
                              }
                            }

                            final currentUser =
                                SessionController().authModel.response.user;
                            final isSeller = currentUser.role == 'SELLER';

                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: timeline.length,
                              itemBuilder: (context, index) {
                                final item = timeline[index];
                                if (item.isOffer) {
                                  final offer = item.offer!;
                                  // Show accept/decline only for consumer
                                  return OfferWidget(
                                    offer: offer,
                                    onAccept: _handleAcceptOffer,
                                    onDecline: _handleDeclineOffer,
                                    isLoading: _isProcessingOffer,
                                    chatUsers: chatUsers,
                                    showActions:
                                        !isSeller, // true for consumer, false for seller
                                  );
                                } else {
                                  final message = item.message!;
                                  final isSentByCurrentUser =
                                      message.seenBy.isNotEmpty &&
                                      message.seenBy.last.id.toString() ==
                                          currentUserId.toString();
                                  final showHeader =
                                      index == 0 ||
                                      (index > 0 &&
                                          DateTimeFormatter.isDifferentDay(
                                            timeline[index - 1].createdAt,
                                            message.createdAt,
                                          ));
                                  final isOfferMessage =
                                      message.content != null &&
                                      message.content!.startsWith('[OFFER]');
                                  return Column(
                                    children: [
                                      if (showHeader)
                                        _buildDateHeader(message.createdAt),
                                      if (isOfferMessage)
                                        BookingRequestWidget(
                                          location: _lastOfferData?['location'],
                                          price: _lastOfferData?['price'],
                                          description:
                                              _lastOfferData?['description'],
                                          date: _lastOfferData?['date'],
                                          startTime:
                                              _lastOfferData?['startTime'],
                                          endTime: _lastOfferData?['endTime'],
                                          sellerName:
                                              _lastOfferData?['sellerName'],
                                          consumerName:
                                              _lastOfferData?['consumerName'],
                                          serviceType:
                                              _lastOfferData?['serviceType'],
                                        )
                                      else
                                        MessageItem(
                                          message: message,
                                          isSent: isSentByCurrentUser,
                                        ),
                                    ],
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: MessageInputWidget(
              receiverId: widget.userId,
              consumerId:
                  chatMessage.isNotEmpty && chatMessage.first.seenBy.isNotEmpty
                      ? chatMessage.first.seenBy.first.consumer?.id.toString()
                      : null,
              messages: chatMessage, // Pass the messages list
              chatUsers: chatUsers, // Pass the chat users list
              onOfferCreated: (offerData) {
                // Store the offer data and add an offer message
                setState(() {
                  _lastOfferData = offerData;
                  chatMessage.add(
                    MessageModel(
                      id: DateTime.now().millisecondsSinceEpoch,
                      content: '[OFFER] Offer created successfully',
                      createdAt: DateTime.now(),
                      files: [],
                      seenBy: [
                        UserModel(
                          id: SessionController().authModel.response.user.id,
                          fullName: '',
                          role: '',
                        ),
                      ],
                    ),
                  );
                });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                // Refresh offers after creating a new offer
                fetchOffers();
              },
              onSendMessage: (message) async {
                // Add the message locally
                final id = SessionController().authModel.response.user.id;
                setState(() {
                  chatMessage.add(
                    MessageModel(
                      files: message.files,
                      seenBy: [UserModel(id: id, fullName: '', role: '')],
                      id: 1,
                      content: message.content,
                      createdAt: DateTime.now(),
                    ),
                  );
                  print('New message createdAt: ${chatMessage.last.createdAt}');
                });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                // Refresh offers after sending a message
                fetchOffers();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class for timeline items
class _TimelineItem {
  final Offer? offer;
  final MessageModel? message;
  final DateTime createdAt;
  final bool isOffer;
  _TimelineItem.offer(Offer o)
    : offer = o,
      message = null,
      createdAt = o.createdAt,
      isOffer = true;
  _TimelineItem.message(MessageModel m)
    : offer = null,
      message = m,
      createdAt = m.createdAt,
      isOffer = false;
}
