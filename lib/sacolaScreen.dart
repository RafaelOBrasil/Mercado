import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mercado_na_nao/SharedPreferencesHelper.dart';
import 'package:mercado_na_nao/modelProduto.dart';

class SacolaScreen extends StatefulWidget {
  @override
  _SacolaScreenState createState() => _SacolaScreenState();
}

class _SacolaScreenState extends State<SacolaScreen> {
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();
  List<Produto> _sacola = [];

  @override
  void initState() {
    super.initState();
    _refreshSacola();
  }

  Future<void> _refreshSacola() async {
    final sacola = await _prefsHelper.getSacola();
    setState(() {
      _sacola = sacola;
    });
  }

  Future<void> _removeFromSacola(int produtoId) async {
    await _prefsHelper.removeFromSacola(produtoId);
    _refreshSacola();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(milliseconds: 300),
      content: Text('Produto removido da sacola'),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 227, 227, 227),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 227, 227, 227),
          centerTitle: true,
          title: const Text('Sacola'),
                  shape: Border(bottom: BorderSide(color: Colors.black12)),

        ),
        body: _sacola.isNotEmpty
            ? ListView.builder(
                itemCount: _sacola.length,
                itemBuilder: (context, index) {
                  final produto = _sacola[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                    child: SizedBox(
                      height: 150,
                      width: 250,
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.green,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: produto.imagem.isNotEmpty
                                  ? Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 15 , 0, 15),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                            left: Radius.circular(15),
                                            right: Radius.circular(15)
                                          ),
                                          image: DecorationImage(
                                            image:
                                                FileImage(File(produto.imagem)),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                  )
                                  : Container(), // Adicione um Container vazio se não houver imagem
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    produto.nome,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  (produto.descricao != "")
                                      ? Text(
                                          produto.descricao,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w300),
                                        )
                                      : Text("N/A"),
                                  Text(
                                    "R\$ ${produto.preco.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 230,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_shopping_cart),
                                  onPressed: () =>
                                      _removeFromSacola(produto.id),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text("Sacola Vazia"),
              ));
  }
}
