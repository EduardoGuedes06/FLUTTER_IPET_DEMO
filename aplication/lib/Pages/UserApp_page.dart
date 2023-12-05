import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplication/Models/Cart.dart';
import 'package:aplication/Pages/ProdutosApp_page.dart';
import 'package:aplication/Service/CartCache.dart';
import 'package:aplication/Service/RestService/CartServiceRest.dart';
import 'package:aplication/Service/UserCache.dart';

class UserApp_page extends StatefulWidget {
  @override
  _UserApp_pageState createState() => _UserApp_pageState();
}

class _UserApp_pageState extends State<UserApp_page> {
  late Future<List<Cart>> cartItemsFuture;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    cartItemsFuture = _loadCart();
  }

  Future<List<Cart>> _loadCart() async {
    final userCache = Provider.of<UserCache>(context, listen: false);
    final loggedInUser = userCache.getLoggedInUser();
    final userId = loggedInUser?.userId;

    List<Cart> cartItems = await CartServiceRest().getCart(userId ?? '');
    setState(() {
      total = _calculateTotal(cartItems);
    });

    return cartItems;
  }

  double _calculateTotal(List<Cart> cartItems) {
    double sum = 0.0;
    for (var item in cartItems) {
      sum += (item.valor * item.qtd);
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Fundo vermelho
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        title: Text(
          'Carrinho',
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Lista de itens do carrinho
          Expanded(
            child: FutureBuilder<List<Cart>>(
              future: cartItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum item no carrinho.'));
                } else {
                  List<Cart> cartItems = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: cartItems.map((cartItem) {
                        return Center(
                          child: Container(
                            width:
                                300.0, // Largura ajustável conforme necessário
                            margin: EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  cartItem.nome,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'R\$ ${cartItem.valor.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Quantidade: ${cartItem.qtd}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool success = await CartServiceRest()
                                            .UpdateItemCart(cartItem.id,
                                                (cartItem.qtd + 1));
                                        if (success) {
                                          setState(() {
                                            cartItem.qtd += 1;
                                            total = _calculateTotal(cartItems);
                                          });
                                        }
                                      },
                                      child: Icon(Icons.add),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (cartItem.qtd == 1) {
                                          return;
                                        }

                                        bool success = await CartServiceRest()
                                            .UpdateItemCart(cartItem.id,
                                                (cartItem.qtd - 1));
                                        if (success) {
                                          setState(() {
                                            cartItem.qtd -= 1;
                                            total = _calculateTotal(cartItems);
                                          });
                                        }
                                      },
                                      child: Icon(Icons.remove),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool success = await CartServiceRest()
                                            .DeleteItemCart(cartItem.id);
                                        if (success) {
                                          setState(() {
                                            cartItems.remove(cartItem);
                                            total = _calculateTotal(cartItems);
                                          });
                                        }
                                      },
                                      child: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),

          // Campo Total
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: R\$ ${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Botão Pagamento
          ElevatedButton(
            onPressed: () {
              // Lógica para processar o pagamento
              // Implemente a lógica desejada aqui
              // Pode abrir uma nova tela para o pagamento, chamar um serviço, etc.
            },
            child: Text('Pagamento'),
          ),
        ],
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
                Icons.store,
                color: Color.fromRGBO(255, 200, 200, 1.0),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: Color.fromRGBO(255, 200, 200, 1.0),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.red,
              ),
              label: '',
            ),
          ],
          onTap: (int index) {
            if (index == 3) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProdutosApp_page(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final Cart cartItem;

  const CartItemTile({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cartItem.nome,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Quantidade: ${cartItem.qtd}',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Valor: R\$ ${cartItem.valor.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Data: ${cartItem.data}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
