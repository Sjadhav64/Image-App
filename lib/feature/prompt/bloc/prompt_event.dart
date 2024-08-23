part of 'prompt_bloc.dart';

@immutable
sealed class PromptEvent {}

class PromptInitialEvent extends PromptEvent{}

class PromptEnterEvent extends PromptEvent {
  final String prompt;
  PromptEnterEvent({
  required this.prompt});
}