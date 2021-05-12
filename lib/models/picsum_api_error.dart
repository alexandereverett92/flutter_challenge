import 'package:equatable/equatable.dart';

/// Formatting class for api errors to consolidate errors throughout the app.
/// Gives a [message] to be shown to the users.
/// Could be extended with more data to give more information for presenting,
/// (type of error, severity etc..).
class PicsumApiError extends Equatable {
  const PicsumApiError(this.message);
  final String message;

  @override
  List<Object> get props => <Object>[message];

  @override
  bool get stringify => true;
}
