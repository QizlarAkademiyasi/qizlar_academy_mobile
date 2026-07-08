part of 'portfolio_detail_bloc.dart';

enum PortfolioDetailStatus { initial, loading, failure, success }

class PortfolioDetailState extends Equatable {
  const PortfolioDetailState({
    this.status = PortfolioDetailStatus.initial,
    this.postId = '',
    this.post,
    this.authRequired = false,
    this.deleted = false,
    this.message,
  });

  final PortfolioDetailStatus status;
  final String postId;
  final PortfolioPostModel? post;
  final bool authRequired;
  final bool deleted;
  final String? message;

  PortfolioDetailState copyWith({
    PortfolioDetailStatus? status,
    String? postId,
    PortfolioPostModel? post,
    bool? authRequired,
    bool? deleted,
    String? message,
    bool clearMessage = false,
  }) {
    return PortfolioDetailState(
      status: status ?? this.status,
      postId: postId ?? this.postId,
      post: post ?? this.post,
      authRequired: authRequired ?? this.authRequired,
      deleted: deleted ?? this.deleted,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
    status,
    postId,
    post,
    authRequired,
    deleted,
    message,
  ];
}
