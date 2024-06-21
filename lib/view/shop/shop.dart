import 'package:flutter/material.dart';
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(

        child: Column(children: [
          Container(
            width: double.infinity,
            height:200
            ,color: const Color(0xff00703B),
            child: const Column(
              mainAxisAlignment:  MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: 10,),

              Text("Shop", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),

              SizedBox(height: 10,),
            ],),
          ),
        ],),
      ),

    );

  }
}
