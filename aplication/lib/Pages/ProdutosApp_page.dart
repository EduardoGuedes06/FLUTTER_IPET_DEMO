import 'package:flutter/material.dart';

class ProdutosApp_page extends StatefulWidget {
  @override
  _ProdutosApp_pageState createState() => _ProdutosApp_pageState();
}

class _ProdutosApp_pageState extends State<ProdutosApp_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Fundo vermelho
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Barra de navegação transparente
        elevation: 0, // Sem sombra na barra de navegação
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // Cor branca
          ),
          onPressed: () {
            // Adicione a navegação para a página anterior aqui
          },
        ),
        title: Text(
          'Produtos',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Cor branca
          ),
        ),
        centerTitle: true, // Centralizar o título
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100.0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(222, 218, 245, 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -1),
              blurRadius: 30.0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0.0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 38.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.crop_square_outlined,
                color: Color.fromRGBO(222, 218, 245, 1.0),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Color.fromRGBO(222, 218, 245, 1.0),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble_outline_outlined,
                color: Color.fromRGBO(222, 218, 245, 1.0),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Color.fromRGBO(150, 131, 220, 1.0),
              ),
              label: '',
            ),
          ],
          onTap: (int index) {
            // Adicione a lógica para lidar com os ícones do BottomNavigationBar
          },
        ),
      ),
    );
  }
}
