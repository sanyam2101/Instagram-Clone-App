import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _passwordController= TextEditingController();
  final TextEditingController _bioController= TextEditingController();
  final TextEditingController _usernameController= TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods()
        .signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });

    if(res != 'success'){
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context)=> const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout()
            ),
        ),
      );
    }
  }

  void navigateToLogin(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container(),flex: 2,),
                // svg image
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(height: 40,),
                //circular image to accept profile photo
                Stack(
                  children: [
                    _image != null? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                        : const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage("https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small/default-avatar-profile-icon-of-social-media-user-vector.jpg"),
                    ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo)),
                    ),

                  ],
                ),
                const SizedBox(height: 30,),
                //text field input for username
                TextFieldInput(
                    textEditingController: _usernameController,
                    hintText: "Enter your username",
                    textInputType: TextInputType.text),
                //text field input for password
                const SizedBox(height: 30,),
                //text field input for email
                TextFieldInput(
                    textEditingController: _emailController,
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress),
                //text field input for password
                const SizedBox(height: 30,),
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Enter your password",
                  textInputType: TextInputType.visiblePassword,
                  isPass: true,
                ),
                const SizedBox(height: 30,),
                //bio input
                TextFieldInput(
                    textEditingController: _bioController,
                    hintText: "Enter your bio",
                    textInputType: TextInputType.text),
                //text field input for password
                const SizedBox(height: 30,),
                //login button
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))
                      ),
                      color: blueColor,
                    ),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator(color: primaryColor,),)
                        : const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 15,),
                Flexible(child: Container(),flex: 2,),
                //transitioning to signup screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8
                      ),
                      child: const Text('Have an account?'),
                    ),
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8
                        ),
                        child: const Text('Log In',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
