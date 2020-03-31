import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:tokopedia/ui/widgets/input_field.dart';
import 'package:tokopedia/ui/widgets/primary_button.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: LoginBody(),
        ),
      ),
    );
  }
}

class LoginBody extends StatefulWidget {
  LoginBody({Key key}) : super(key: key);
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {

  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  static Dio dio = new Dio();

  @override
  void initState() { 
    super.initState();
    this.cekSesion();
  }

  Future<void> cekSesion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var isLogin = pref.getString("islogin");
    if(isLogin=="1"){
       Navigator.pushNamedAndRemoveUntil(context, "/home", (Route<dynamic> routes) => false);
    }
  }

  Future<void> cekLogin() async {

    if(usernameController.text.isNotEmpty && passwordController.text.isNotEmpty){
      Toast.show("Mencoba Login", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      Map<String, dynamic> loginData = {
        "username": usernameController.text,
        "password": passwordController.text,
        "key": 'b3rc4'
      };

      var response = await dio.post(
        'http://flutter.id/api/berca/login',
        data: FormData.fromMap(loginData),
        options: Options(headers: {"Accept": "application/json"})
      );

      print(response.toString());

      if(response.data['status'].toString()=='200'){

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("islogin", "1");

        Toast.show("Berhasil Login", context, duration: Toast.LENGTH_LONG, gravity:Toast.BOTTOM);
        Navigator.pushNamedAndRemoveUntil(context, "/home", (Route<dynamic> routes) => false);

      }else{
        Toast.show(response.data['message'].toString(), context, duration: Toast.LENGTH_LONG, gravity:Toast.BOTTOM); 
      }

    }else{
      Toast.show("Tolong isi semua field", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
     return Column(
       children: <Widget>[

        //Bagian headers
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          color: Colors.white,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/logo.jpg',height: 200,width: 200,),
              ],
            ),
          )
        ),

        //Bagian field login
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: <Widget>[

              InputField(
                action: TextInputAction.next,
                type: TextInputType.text,
                controller: usernameController,
                hintText: "Username",
              ),

              SizedBox(height: 10),

              InputField(
                action: TextInputAction.next,
                type: TextInputType.text,
                controller: passwordController,
                hintText: "Password",
                secureText: true,
              ),

              SizedBox(height: 15),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: PrimaryButton(
                  color: Colors.green,
                  text: "Login",
                  onClick: (){
                    cekLogin();
                  },
                ),
              ),

              SizedBox(height: 15),

              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, "/register");
                },
                child: Text("need account, register"),
              )


            ],
          ),
        )





       ],
     );
  }
}





