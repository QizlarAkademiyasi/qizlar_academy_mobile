part of 'portfolio_create_bloc.dart';

enum PortfolioCreateStatus { editing, submitting, failure, success }

class PortfolioPickedMedia extends Equatable {
  const PortfolioPickedMedia({required this.localFilePath, required this.type});

  final String localFilePath;
  final PortfolioMediaType type;

  @override
  List<Object?> get props => [localFilePath, type];
}

class PortfolioCreateState extends Equatable {
  const PortfolioCreateState({
    this.status = PortfolioCreateStatus.editing,
    this.caption = '',
    this.media = const [],
    this.message,
  });

  final PortfolioCreateStatus status;
  final String caption;
  final List<PortfolioPickedMedia> media;
  final String? message;

  bool get canSubmit =>
      status != PortfolioCreateStatus.submitting && media.isNotEmpty;

  PortfolioCreateState copyWith({
    PortfolioCreateStatus? status,
    String? caption,
    List<PortfolioPickedMedia>? media,
    String? message,
    bool clearMessage = false,
  }) {
    return PortfolioCreateState(
      status: status ?? this.status,
      caption: caption ?? this.caption,
      media: media ?? this.media,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, caption, media, message];
}
