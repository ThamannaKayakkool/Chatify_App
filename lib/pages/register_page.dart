import 'package:chatify_app/provider/authentication_provider.dart';
import 'package:chatify_app/services/cloud_storage_service.dart';
import 'package:chatify_app/services/database_service.dart';
import 'package:chatify_app/services/media_service.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:chatify_app/widgets/custom_input_field.dart';
import 'package:chatify_app/widgets/rounded_button.dart';
import 'package:chatify_app/widgets/rounded_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  PlatformFile? _profileImage;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;

   late NavigationService _navigation;

  final _registerFormKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();
     _navigation = GetIt.instance.get<NavigationService>();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _profileImageField(),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              _registerForm(),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              _registerButton(),
              SizedBox(
                height: _deviceHeight * 0.02,
              ),
            ]),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((_file) {
          setState(() {
            _profileImage = _file;
          });
        });
      },
      child: () {
        if (_profileImage != null) {
          return RoundedImageFile(
            image: _profileImage!,
            size: _deviceHeight * 0.15,
            key: UniqueKey(),
          );
        } else {
          return RoundedImageNetwork(
            imagePath:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeqKSf7pEKebHDLt1mfYgo1_9LT7c06CMkBg&s",
            size: _deviceHeight * 0.15,
            key: UniqueKey(),
          );
        }
      }(),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
                onSaved: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                regEx: r".{8,}",
                hintText: "Name",
                obscureText: false),
            CustomTextFormField(
                onSaved: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                hintText: "Email",
                obscureText: false),
            CustomTextFormField(
                onSaved: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                regEx: r".{8,}",
                hintText: "Password",
                obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
        name: 'Register',
        height: _deviceHeight * 0.065,
        width: _deviceWidth * 0.65,
        onPressed: () async {
          if (_registerFormKey.currentState!.validate() &&
              _profileImage != null) {
            _registerFormKey.currentState!.save();
            String? _uid = await _auth.registerUserUsingEmailAndPassword(
                _email!, _password!);
            String? _imageUrl=await _cloudStorage.saveUserImageToStorage(_uid!, _profileImage!);
            await _db.createUser(_uid, _email!, _name!, _imageUrl!);
            await _auth.logout();
            await _auth.loginUsingEmailAndPassword(_email!, _password!);
          }
        });
  }
}
