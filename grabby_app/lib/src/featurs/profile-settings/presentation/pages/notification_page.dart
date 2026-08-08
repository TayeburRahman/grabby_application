import 'package:grabby_app/src/featurs/profile-settings/data/models/notification_model.dart';
import 'package:grabby_app/src/featurs/profile-settings/presentation/bloc/notification/notification_bloc.dart';

import '../../../../src_export.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationBloc>()..add(FetchNotificationsEvent()),
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        appBar: AppBar(
          title: const Text(AppStaticStrings.notifications),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.kTextColor),
          ),
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading && state.notifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationError && state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(state.errorMessage ?? "Error loading notifications"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<NotificationBloc>()
                          .add(FetchNotificationsEvent()),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            if (state.notifications.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<NotificationBloc>()
                      .add(FetchNotificationsEvent());
                },
                child: Stack(
                  children: [
                    ListView(),
                    const Center(child: CustomText("No notifications yet")),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationBloc>().add(FetchNotificationsEvent());
              },
              child: ListView.separated(
                padding: AppPadding.getPadding12(context),
                itemCount: state.notifications.length,
                separatorBuilder: (context, index) => space12H,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return _buildNotificationItem(context, notification);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
      BuildContext context, NotificationModel notification) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_outlined,
              color: AppColors.kPrimaryColor,
              size: 20,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        notification.title,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomText(
                      _formatDate(notification.createdAt),
                      fontSize: 10,
                      color: AppColors.kSecondaryTextColor,
                    ),
                  ],
                ),
                CustomText(
                  notification.message,
                  fontSize: 12,
                  color: AppColors.kSecondaryTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) return "Just now";
      if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
      if (difference.inHours < 24) return "${difference.inHours}h ago";
      if (difference.inDays < 7) return "${difference.inDays}d ago";

      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return "";
    }
  }
}
