import 'package:flutter/material.dart';

class NewButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const NewButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 88,
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget customButton({
  buttonText,
   Function? onPressed
}){

  return ElevatedButton(
    onPressed: (){
      if (onPressed !=null){
        onPressed();
      }
    }, 
    child: Text(
      buttonText,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
    ),
    );

}

 


