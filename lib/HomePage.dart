import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int sayac = 0;
  double ortalama = 0;
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4.0;
  List<Ders> tumDersler;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Puan Hesaplama'),
      ),
      body: uygulamaGovdesi(),
    );
  }

  Widget uygulamaGovdesi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            //   color: Colors.indigo,
            //ders eklemek için form
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Ders adı',
                        hintText: 'Ders adını giriniz',
                        border: OutlineInputBorder(),
                      ),
                      validator: (girdi) {
                        if (girdi.length > 0) {
                          return null;
                        } else {
                          return 'ders adı boş olamaz';
                        }
                      },
                      onSaved: (girdi) {
                        setState(() {
                          dersAdi = girdi;
                          tumDersler
                              .add(Ders(dersAdi, dersHarfDegeri, dersKredi));

                          _ortalamayiHesapla();
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            items: dersKredileriItems(),
                            onChanged: (secilenKredi) {
                              setState(() {
                                dersKredi = secilenKredi;
                              });
                            },
                            value: dersKredi,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                              items: harfDegerleriItems(),
                              value: dersHarfDegeri,
                              onChanged: (secilenharf) {
                                setState(() {
                                  dersHarfDegeri = secilenharf;
                                });
                              }),
                        )
                      ],
                    ),
                    RaisedButton(
                      color: Colors.white54,
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                        }
                      },
                      child: Icon(Icons.add_box_outlined),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      ortalama.toString(),
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
              //eklenmiş dersleri gösteren liste
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (var i = 1; i < 11; i++) {
      var item = DropdownMenuItem<int>(
        value: i,
        child: Text('$i kredi'),
      );
      krediler.add(item);
    }
    return krediler;
  }

  List<DropdownMenuItem<double>> harfDegerleriItems() {
    List<DropdownMenuItem<double>> harfler = [];
    List<String> harf = [
      "AA",
      "BA",
      "BB",
      "CB",
      "CC",
      "DD",
      "FD",
      "FF",
    ];
    List<double> degerleri = [4.0, 3.5, 3.0, 2.5, 2.25, 2.0, 1.0, 0.0];
    for (var i = 0; i < harf.length; i++) {
      var item = DropdownMenuItem<double>(
        child: Text(harf[i]),
        value: degerleri[i],
      );
      harfler.add(item);
    }

    return harfler;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          _ortalamayiHesapla();
        });
      },
      child: Card(
        child: ListTile(
          title: Text(tumDersler[index].ad),
          trailing: Text(tumDersler[index].harfDegeri.toString()),
          leading: Text(tumDersler[index].kredi.toString()),
        ),
      ),
    );
  }

  void _ortalamayiHesapla() {
    // int ortalama = 0;
    int toplamKredi = 0;
    double aSayaci = 0;
    for (var i = 0; i < tumDersler.length; i++) {
      double a = tumDersler[i].kredi * tumDersler[i].harfDegeri;
      aSayaci = aSayaci + a;
      toplamKredi = toplamKredi + tumDersler[i].kredi;
      ortalama = aSayaci / toplamKredi;
    }
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;
  Ders(this.ad, this.harfDegeri, this.kredi);
}
