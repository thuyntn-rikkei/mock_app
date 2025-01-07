part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.onAuthStarted() = OnAuthStarted;
  const factory AuthEvent.onLoginEvent({required LoginRequest request}) =
      OnLoginEvent;
  const factory AuthEvent.onRegisterEvent({required RegisterRequest request}) =
      OnRegisterEvent;
  const factory AuthEvent.onLogoutEvent() = OnLogoutEvent;
}
