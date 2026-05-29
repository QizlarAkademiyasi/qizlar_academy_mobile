import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

mixin StoreOrderDetailScreenMixin<T extends StatefulWidget> on State<T> {
  void onBackTap(BuildContext context) {
    context.pop();
  }
}
