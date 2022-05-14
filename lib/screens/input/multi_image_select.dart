import 'package:flutter/material.dart';

class MultiImageSelect extends StatelessWidget {
  const MultiImageSelect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        return SizedBox(
          height: size.width / 3,
          width: size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: (size.width / 3) - 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.grey,
                      ),
                      Text(
                        '0/10',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
              ...List.generate(
                  20,
                  (index) => Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10,bottom: 10, right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: (size.width / 3) - 20,
                            height: (size.width / 3) - 20,
                            child: Image.network('https://picsum.photos/100',
                            fit: BoxFit.cover,),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0, top: 0,width: 35,height: 35,
                        child: IconButton(
                          iconSize: 35,
                          padding: EdgeInsets.zero,
                            onPressed: (){}, icon: Icon(Icons.remove_circle,
                        color: Colors.black54,)),
                      )
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }
}
