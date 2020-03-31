import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import 'package:tokopedia/ui/widgets/primary_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Future<void> prosesLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("islogin");
    Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> routes) => false);
  }

  Future<void> cekSesion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var isLogin = pref.getString("islogin");
    if(isLogin=="1"){
    }else{
       Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> routes) => false);
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
        Toast.show("Berhasil Login", context, duration: Toast.LENGTH_LONG, gravity:Toast.BOTTOM);
        
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



        Text("Home"),


        Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          child: PrimaryButton(
            color: Colors.green,
            text: "Logout",
            onClick: (){
              prosesLogout();
            },
          ),
        ),






       ],
     );
  }

  void prosesRegister() {}
}





