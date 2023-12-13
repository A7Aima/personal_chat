import 'package:PersonalChat/utility/mixin/size_mixin/size_mixin.dart';
import 'package:flutter/material.dart';

abstract class BasePageWidget extends StatefulWidget {
  const BasePageWidget({Key? key}) : super(key: key);
}

abstract class BaseState<Page extends BasePageWidget> extends State<Page>
    with SizeMixin {
  late bool _isFirstRun;
  Map<String, dynamic> routesArguments = {};
  @override
  void initState() {
    super.initState();
    _isFirstRun = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstRun) {
      _isFirstRun = false;
      setSize(context);
      initializeWithContext(context);
    }
  }

  void initializeWithContext(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments is Map<String, dynamic>) {
      routesArguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    }
  }
}
