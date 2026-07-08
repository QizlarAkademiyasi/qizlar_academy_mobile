part of 'portfolio_create_bloc.dart';

sealed class PortfolioCreateEvent extends Equatable {
  const PortfolioCreateEvent();

  @override
  List<Object?> get props => [];
}

final class PortfolioCreateCaptionChanged extends PortfolioCreateEvent {
  const PortfolioCreateCaptionChanged(this.caption);

  final String caption;

  @override
  List<Object?> get props => [caption];
}

final class PortfolioCreateMediaAdded extends PortfolioCreateEvent {
  const PortfolioCreateMediaAdded({
    required this.localFilePath,
    required this.type,
  });

  final String localFilePath;
  final PortfolioMediaType type;

  @override
  List<Object?> get props => [localFilePath, type];
}

final class PortfolioCreateMediaRemoved extends PortfolioCreateEvent {
  const PortfolioCreateMediaRemoved(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

final class PortfolioCreateSubmitted extends PortfolioCreateEvent {
  const PortfolioCreateSubmitted();
}
