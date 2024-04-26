import 'package:get_it/get_it.dart';
import 'package:yanta/view_model/chat_vm.dart';
import 'package:yanta/view_model/conversations_vm.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<ChatViewModel>(ChatViewModel());
  getIt.registerSingleton<ConversationsViewModel>(ConversationsViewModel());
}
