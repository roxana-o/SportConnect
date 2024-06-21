import 'package:flutter/material.dart';
import 'P_authentication.dart';

class FirstPage extends StatelessWidget {

  FirstPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    ' Fii la curent cu recentele evenimente sportive și cunoaște oameni cu aceleași interese ca tine',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  'assets/sport_connect.png',
                  width: 200,
                ),
                const SizedBox(height: 80),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15)),
                      //color: Color.fromARGB(255, 244, 153, 18),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Alătură-te acum comunității noastre!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical:10, horizontal: 30),
                          child: Text(
                            'SportConnect este o aplicație în care utilizatorii pot crea și căuta evenimente sportive, primi recomandări și interacționa cu alte persoane.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              
                              color: Colors.black,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),

                        //Butonul de START
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Authentication(), 
                              ),
                            );
                          },
                          
                          child: const Text(
                            'START',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(253, 176, 91, 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
