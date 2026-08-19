import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_kit/gen/assets.gen.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_conversation_model.dart';

class AiChatSideDrawer extends StatelessWidget {
  const AiChatSideDrawer({
    super.key,
    required this.progress,
    required this.canStartNewConversation,
    required this.conversations,
    required this.selectedConversationId,
    required this.isLoadingConversations,
    required this.isLoadingMoreConversations,
    required this.conversationsLoadFailed,
    required this.onNewConversation,
    required this.onSelectConversation,
    required this.onRetryConversations,
    required this.onLoadMoreConversations,
    required this.onCloseChat,
  });

  final double progress;
  final bool canStartNewConversation;
  final List<AiChatConversationModel> conversations;
  final String? selectedConversationId;
  final bool isLoadingConversations;
  final bool isLoadingMoreConversations;
  final bool conversationsLoadFailed;
  final VoidCallback onNewConversation;
  final ValueChanged<String> onSelectConversation;
  final VoidCallback onRetryConversations;
  final VoidCallback onLoadMoreConversations;
  final VoidCallback onCloseChat;

  @override
  Widget build(BuildContext context) {
    final opacity = Curves.easeOut.transform(progress.clamp(0, 1));
    return ExcludeSemantics(
      excluding: progress < 0.5,
      child: IgnorePointer(
        ignoring: progress < 0.8,
        child: Transform.translate(
          offset: Offset(-22 * (1 - opacity), 0),
          child: Opacity(
            opacity: opacity,
            child: SafeArea(
              key: const ValueKey('ai-chat-side-drawer'),
              right: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DrawerBrand(title: context.l10n.aiChatTitle),
                    const SizedBox(height: 22),
                    Text(
                      context.l10n.aiChatGreetingSubtitle,
                      style: context.textTheme.bodyMediumRegular.copyWith(
                        color: AppColors.white.withValues(alpha: 0.72),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _DrawerAction(
                      key: const ValueKey('ai-chat-drawer-new-conversation'),
                      icon: LucideIcons.squarePen,
                      label: context.l10n.aiChatNewConversation,
                      enabled: canStartNewConversation,
                      onTap: onNewConversation,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      context.l10n.aiChatHistory,
                      style: context.textTheme.bodyLargeMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.86),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _ConversationsSection(
                        conversations: conversations,
                        selectedConversationId: selectedConversationId,
                        isLoading: isLoadingConversations,
                        isLoadingMore: isLoadingMoreConversations,
                        loadFailed: conversationsLoadFailed,
                        onSelect: onSelectConversation,
                        onRetry: onRetryConversations,
                        onLoadMore: onLoadMoreConversations,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DrawerAction(
                      key: const ValueKey('ai-chat-drawer-close-chat'),
                      icon: LucideIcons.logOut,
                      label: context.l10n.aiChatClose,
                      onTap: onCloseChat,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConversationsSection extends StatelessWidget {
  const _ConversationsSection({
    required this.conversations,
    required this.selectedConversationId,
    required this.isLoading,
    required this.isLoadingMore,
    required this.loadFailed,
    required this.onSelect,
    required this.onRetry,
    required this.onLoadMore,
  });

  final List<AiChatConversationModel> conversations;
  final String? selectedConversationId;
  final bool isLoading;
  final bool isLoadingMore;
  final bool loadFailed;
  final ValueChanged<String> onSelect;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (isLoading && conversations.isEmpty) {
      return const _ConversationsSkeleton();
    }
    if (loadFailed && conversations.isEmpty) {
      return _ConversationsError(onRetry: onRetry);
    }
    if (conversations.isEmpty) {
      return Align(
        alignment: Alignment.topLeft,
        child: Text(
          context.l10n.aiChatConversationsEmpty,
          style: context.textTheme.bodyMediumRegular.copyWith(
            color: AppColors.white.withValues(alpha: 0.62),
            height: 1.4,
          ),
        ),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 80) onLoadMore();
        return false;
      },
      child: ListView.separated(
        key: const ValueKey('ai-chat-conversations-list'),
        padding: EdgeInsets.zero,
        itemCount: conversations.length + (isLoadingMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index >= conversations.length) {
            return const _ConversationsSkeleton(itemCount: 1);
          }
          final conversation = conversations[index];
          return _ConversationTile(
            conversation: conversation,
            selected: conversation.id == selectedConversationId,
            onTap: () => onSelect(conversation.id),
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.selected,
    required this.onTap,
  });

  final AiChatConversationModel conversation;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = (conversation.title ?? '').trim();
    final label = title.isEmpty
        ? context.l10n.aiChatUntitledConversation
        : title;
    final foreground = AppColors.white.withValues(alpha: selected ? 1 : 0.88);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        key: ValueKey('ai-chat-conversation-tile-${conversation.id}'),
        color: AppColors.white.withValues(alpha: selected ? 0.22 : 0.1),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(LucideIcons.messageCircle, size: 18, color: foreground),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMediumMedium.copyWith(
                      color: foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConversationsSkeleton extends StatelessWidget {
  const _ConversationsSkeleton({this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: Column(
        children: [
          for (var i = 0; i < itemCount; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            const Bone(
              width: double.infinity,
              height: 46,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ],
        ],
      ),
    );
  }
}

class _ConversationsError extends StatelessWidget {
  const _ConversationsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.aiChatConversationsLoadError,
          style: context.textTheme.bodyMediumRegular.copyWith(
            color: AppColors.white.withValues(alpha: 0.78),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        _DrawerAction(
          icon: LucideIcons.refreshCw,
          label: context.l10n.retry,
          onTap: onRetry,
        ),
      ],
    );
  }
}

class _DrawerBrand extends StatelessWidget {
  const _DrawerBrand({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
              child: UiKitAssets.images.logoRemoved.image(
                width: 34,
                height: 34,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.heading5.copyWith(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}

class _DrawerAction extends StatelessWidget {
  const _DrawerAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final foreground = AppColors.white.withValues(alpha: enabled ? 1 : 0.42);
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Material(
        color: AppColors.white.withValues(alpha: enabled ? 0.14 : 0.07),
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                Icon(icon, size: 22, color: foreground),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: context.textTheme.bodyLargeMedium.copyWith(
                      color: foreground,
                    ),
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 19,
                  color: foreground.withValues(alpha: 0.68),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
