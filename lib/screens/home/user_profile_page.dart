import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_egg_market/data/user_model.dart';
import 'package:my_egg_market/states/user_notifier.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  final UserModel userModel;
  const UserProfilePage({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _userSection(userModel),
          _divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                circleButton(icon: Icons.receipt_long_outlined,title: '판매내역',heroTag: '판매내역'),
                circleButton(icon: Icons.shopping_cart_outlined,title: '구매내역',heroTag: '구매내역'),
                circleButton(icon: Icons.favorite,title: '관심목록',heroTag: '관심목록'),
              ],
            ),
          ),
          _divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(onPressed: ()async{
                  context.read<UserNotifier>().userModelReset = null;
                  await FirebaseAuth.instance.signOut();
                  context.beamToNamed('/');
                }, child: const Text('로그아웃')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _userSection(UserModel? userModel) {
    return SizedBox(
          height: 70,
          child: ListTile(
            leading: Icon(
                    Icons.account_circle,
                    color: Colors.grey[350],
                    size: 50,
                  ),
            title: Text(userModel!.userKey.substring(18),style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(userModel.address,style: const TextStyle(fontSize: 13),),
            trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios)),
          ),
        );
  }

  Divider _divider() => Divider(height: 13,thickness: 1,color: Colors.grey.withOpacity(0.3),indent: 20,endIndent: 20,);

  Column circleButton({required IconData icon,required String title,required String heroTag}) {
    return Column(
              children: [
                FloatingActionButton(
                  heroTag: heroTag,
                  elevation: 0.0,
                  onPressed: (){},
                  child: Icon(icon,color: Colors.deepOrangeAccent,),
                backgroundColor: Colors.orange[100],),
                const SizedBox(height: 10,),
                Text(title)
              ],
            );
  }
}
