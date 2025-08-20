import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view/nav_bar/user/home/services/services_scheduler.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/chat_screen.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/reviews/review_tab_new.dart';
import 'package:zapxx/view/nav_bar/user/profile/other_user/widgets/time_slot_tab_widget.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/view/nav_bar/user/profile/other_user/portfolio_details/portfolio_details_screen.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final ServiceScheduler scheduler;
  const OtherUserProfileScreen({super.key, required this.scheduler});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ServiceSchedulerType? _currentScheduler;
  bool _tabLoading = false;
  String _currentViewType = 'PORTFOLIO';
  bool liked = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _fetchSchedulerDetails(); // initial load
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          _currentViewType = 'PORTFOLIO';
          break;
        case 1:
          _currentViewType = 'TIMESLOTS';
          break;
        case 2:
          _currentViewType = 'REVIEWS';
          break;
      }
      _fetchSchedulerDetails();
    }
  }

  Future<void> _fetchSchedulerDetails() async {
    setState(() => _tabLoading = true);
    try {
      final repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;
      final response = await repository.getSchedulerDetails(
        headers: {'Authorization': token},
        schedulerId: widget.scheduler.id,
        viewType: _currentViewType,
      );
      setState(() {
        _currentScheduler = response;
        _tabLoading = false;
        liked = _currentScheduler!.seller.favorite!;
      });
    } catch (e) {
      setState(() => _tabLoading = false);
      print('Error fetching scheduler details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 3,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 280.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/profile_background.png',
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 230.w),
                          _buildProfileImage(),
                          SizedBox(height: 12.w),
                          _buildNameAndLikeButton(),
                          SizedBox(height: 5.w),
                          Text(
                            '@${_currentScheduler?.seller.user.username ?? 'erico_mov99'}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          _buildRatingSection(),
                          SizedBox(height: 12.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            child: Text(
                              _currentScheduler?.seller.aboutMe ??
                                  'No description available',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          _buildMessageButton(),
                          SizedBox(height: 20.h),
                          _buildTabSection(),
                          SizedBox(height: 10.h),
                          _buildTabContent(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50.w,
              left: 20.w,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 95.w,
      height: 95.w,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
        image:
            _currentScheduler?.seller.user.profileImage != null
                ? DecorationImage(
                  image: NetworkImage(
                    AppUrl.baseUrl +
                        '/' +
                        _currentScheduler!.seller.user.profileImage!.url,
                  ),
                  fit: BoxFit.cover,
                )
                : DecorationImage(
                  image: AssetImage('assets/images/profile_picture.png'),
                  fit: BoxFit.cover,
                ),
      ),
    );
  }

  Widget _buildNameAndLikeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 100.w, height: 40.w),
        Text(
          _currentScheduler?.seller.user.fullName ?? 'Name',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 4.w),
        Icon(Icons.verified, size: 20.w, color: Colors.blue),
        SizedBox(width: 30.w),
        GestureDetector(
          onTap: _toggleLike,
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(.6)),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Center(
              child: Icon(
                liked ? Icons.favorite : Icons.favorite_border,
                color: liked ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleLike() async {
    if (_currentScheduler == null) return;
    final previousState = liked;
    setState(() => liked = !liked);

    try {
      final repository = HomeHttpApiRepository();
      final token = SessionController().authModel.response.token;
      await repository.toggleSellerLike(
        sellerId: _currentScheduler!.seller.id,
        isSaved: !previousState,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );
    } catch (e) {
      setState(() => liked = previousState);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to ${previousState ? 'unlike' : 'like'} seller',
          ),
        ),
      );
    }
  }

  Widget _buildRatingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.star, color: Colors.amber, size: 16.w),
        SizedBox(width: 5.w),
        Text(
          _currentScheduler?.avgRating?.toString() ?? '0.0',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          '(${widget.scheduler.seller.reviewCount})',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMessageButton() {
    return GestureDetector(
      onTap: () {
        final user = _currentScheduler!.seller.user;
        // Check if there's an existing chat, otherwise create a new one
        String chatId = '';
        if (user.chats != null && user.chats!.isNotEmpty) {
          chatId = user.chats!.first.id.toString();
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ChatScreen(
                  userId: user.id.toString(),
                  id: chatId,
                  name: user.fullName,
                  image:
                      user.profileImage != null ? user.profileImage!.url : '',
                ),
          ),
        );
      },
      child: Container(
        width: 280.w,
        height: 48.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Center(
          child: Text(
            'Message',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSection() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.teal,
      tabs: const [
        Tab(text: 'Portfolio'),
        Tab(text: 'Time Slots'),
        Tab(text: 'Reviews'),
      ],
    );
  }

  Widget _buildTabContent() {
    if (_tabLoading) {
      return SizedBox(
        height: 300.w,
        child: Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    }

    return SizedBox(
      height: 300.w,
      child: TabBarView(
        controller: _tabController,
        children: [
          PortfolioTabWidget(portfolio: _currentScheduler?.seller.portfolio),
          TimeSlotTabWidget(
            timeSlots: _currentScheduler?.schedulerDates,
            sellerId: _currentScheduler?.seller.id ?? 0,
          ),
          ReviewsTabNew(
            reviews: _currentScheduler?.seller.reviews,
            paddingLeft: 24,
          ),
        ],
      ),
    );
  }
}

class PortfolioTabWidget extends StatelessWidget {
  final List<Portfolio>? portfolio;
  const PortfolioTabWidget({super.key, this.portfolio});

  @override
  Widget build(BuildContext context) {
    if (portfolio == null || portfolio?.isEmpty == true) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 50.w, color: Colors.grey),
            SizedBox(height: 16.w),
            Text(
              'No portfolio available',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        padding: EdgeInsets.only(top: 10.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.w,
          childAspectRatio: 155 / 180,
        ),
        itemBuilder: (context, index) {
          final portfolioItem = portfolio?[index];
          if (portfolioItem == null) return SizedBox.shrink();
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          PortfolioDetailsScreen(portfolio: portfolioItem),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8.r),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            AppUrl.baseUrl +
                                '/' +
                                portfolioItem.images.first.url,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(8.r),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            portfolioItem.title ?? 'Portfolio',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.w),
                          Text(
                            '${portfolioItem.images.length} photos',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: portfolio!.length,
      ),
    );
  }
}
