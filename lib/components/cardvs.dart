import 'package:flutter/material.dart';
import 'package:healthy/model/vsmodel.dart';

class CardVs extends StatelessWidget {
  final void Function() ontap;
  final VsModel vsmodel;
  final int index;
  final  void Function()? onDelet ;
  const CardVs({
    Key? key,
    required this.ontap,
    required this.vsmodel,
    required this.index,
    required this.onDelet,
  }) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Image.asset(
                  "images/check.png",
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                )),
            Expanded(
                flex: 2,
                child: ListTile(
                  title: Text("Your Signs"),
                  subtitle: Text(
                    "Tempurature:${vsmodel.data?[index].temp}"
                    "Glucose:${vsmodel.data?[index].gluc}"
                    "Heart rate:${vsmodel.data?[index].bmp}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: onDelet,
                      ),
                ))
          ],
        ),
      ),
    );
  }
}
