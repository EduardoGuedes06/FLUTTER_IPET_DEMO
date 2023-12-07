import 'package:aplication/Pages/UserApp_page.dart';
import 'package:aplication/Service/Notificador.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplication/Models/Cart.dart';
import 'package:aplication/Pages/ProdutosApp_page.dart';
import 'package:aplication/Service/CartCache.dart';
import 'package:aplication/Service/RestService/CartServiceRest.dart';
import 'package:aplication/Service/RestService/PaymentServiceRest.dart';
import 'package:aplication/Service/UserCache.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CartApp_page extends StatefulWidget {
  @override
  _CartApp_pageState createState() => _CartApp_pageState();
}

class _CartApp_pageState extends State<CartApp_page> {
  late Future<List<Cart>> cartItemsFuture;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    cartItemsFuture = _loadCart();
  }

  void _limparCarrinho() {
    setState(() {
      total = 0.0;
      cartItemsFuture = _loadCart();
    });
  }

  Future<void> _confirmarCompra() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Compra'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deseja confirmar a compra?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop();
                _finalizarCompra();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _finalizarCompra() async {
    final userCache = Provider.of<UserCache>(context, listen: false);
    final loggedInUser = userCache.getLoggedInUser();
    final userId = loggedInUser?.userId;
    bool success = await PaymentServiceRest().finalizePayment(userId ?? '');

    NotificationService().showNotification(
        title: 'Carrinho Finalizado', body: 'Compra Realizada!');
    _limparCarrinho();
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
    final userCache = Provider.of<UserCache>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.red,
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
          Expanded(
            child: FutureBuilder<List<Cart>>(
              future: cartItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum item no carrinho.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  );
                } else {
                  List<Cart> cartItems = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: cartItems.map((cartItem) {
                        return Center(
                          child: Container(
                            width: 300.0,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total: R\$ ${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    await _confirmarCompra();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.payment,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Pagamento',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
          )
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
                color: Colors.red,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Color.fromRGBO(255, 200, 200, 1.0),
              ),
              label: '',
            ),
          ],
          onTap: (int index) {
            if (index == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartApp_page(),
                ),
              );
            }
            if (index == 0) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProdutosApp_page(),
                ),
              );
            }
            if (index == 2) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserApp_page(),
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
