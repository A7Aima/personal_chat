import 'package:PersonalChat/const/routes/routes.dart';
import 'package:PersonalChat/store/user_store/user_store.dart';
import 'package:PersonalChat/utility/loading_widget/loading_widget.dart';
import 'package:PersonalChat/utility/mixin/base_mixin/base_mixin.dart';
import 'package:flutter/material.dart';

class SignupScreen extends BasePageWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends BaseState<SignupScreen> {
  UserStore _userStore = UserStore();
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerConfirmPassword = TextEditingController();

  @override
  void initializeWithContext(BuildContext context) {
    super.initializeWithContext(context);
    _controllerName.addListener(() {
      _userStore.name = _controllerName.text;
    });
    _controllerEmail.addListener(() {
      _userStore.email = _controllerEmail.text;
    });
    _controllerPassword.addListener(() {
      _userStore.password = _controllerPassword.text;
    });
    _controllerConfirmPassword.addListener(() {
      _userStore.comfirmPassword = _controllerConfirmPassword.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"),
      ),
      body: LoadingWidget(
        loading: _userStore.isLoading,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
          top: screenHeight * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTextField(
              label: "Name",
              controller: _controllerName,
            ),
            _buildTextField(
              label: "Email",
              controller: _controllerEmail,
            ),
            _buildTextField(
              label: "Password",
              controller: _controllerPassword,
            ),
            _buildTextField(
              label: "Confirm Password",
              controller: _controllerConfirmPassword,
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return TextButton(
      onPressed: () {
        if (_userStore.validateSignup() != null) {
          toastMessage(_userStore.validateSignup());
        } else {
          setState(() {
            _userStore.isLoading = true;
          });
          _userStore.createUser().then((value) {
            setState(() {
              _userStore.isLoading = false;
            });
            if (_userStore.errorMessage != null) {
              toastMessage(_userStore.errorMessage);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.home_screen,
                (route) => false,
              );
            }
          });
        }
      },
      child: Text(
        "Signup",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        fixedSize: Size(screenWidth * 0.5, screenHeight * 0.075),
      ),
    );
  }

  Widget _buildTextField({
    String label = "",
    String hint = "",
    TextEditingController? controller,
  }) {
    return Container(
      width: screenWidth * 0.9,
      margin: EdgeInsets.only(
        bottom: screenHeight * 0.05,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          label: Text("$label"),
          hintText: "$hint",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void toastMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? "")),
    );
  }
}
