import 'package:aplication/Models/User.dart';
import 'package:aplication/Service/LocalCache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aplication/Models/Cart.dart';
import 'package:aplication/Models/Payment.dart';
import 'package:aplication/Pages/CartApp_page.dart';
import 'package:aplication/Pages/ProdutosApp_page.dart';
import 'package:aplication/Service/CartCache.dart';
import 'package:aplication/Service/RestService/CartServiceRest.dart';
import 'package:aplication/Service/RestService/PaymentServiceRest.dart';
import 'package:aplication/Service/UserCache.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UserApp_page extends StatefulWidget {
  @override
  _UserApp_pageState createState() => _UserApp_pageState();
}

class _UserApp_pageState extends State<UserApp_page> {
  late Future<List<Payment>> paymentsFuture;
  double total = 0.0;
  @override
  void initState() {
    super.initState();
    paymentsFuture = _loadPayments();
    _loadUserInfo();
  }

  void _limparCarrinho() {
    setState(() {
      total = 0.0;
      paymentsFuture = _loadPayments();
    });
  }

  Future<void> _confirmarPagamento() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Pagamento'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deseja confirmar o pagamento?'),
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
                _finalizarPagamento();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _finalizarPagamento() async {
    final userCache = Provider.of<UserCache>(context, listen: false);
    final loggedInUser = userCache.getLoggedInUser();
    final userId = loggedInUser?.userId;
    bool success = await PaymentServiceRest().finalizePayment(userId ?? '');

    _limparCarrinho();
  }

  Future<List<Payment>> _loadPayments() async {
    final userCache = Provider.of<UserCache>(context, listen: false);
    final loggedInUser = userCache.getLoggedInUser();
    final userId = loggedInUser?.userId;

    List<Payment> payments =
        await PaymentServiceRest().getPayment(userId ?? '');
    setState(() {
      total = _calculateTotalPayments(payments);
    });

    return payments;
  }

  Future<void> _loadUserInfo() async {
    final userCache = Provider.of<UserCache>(context, listen: false);
    final loggedInUser = userCache.getLoggedInUser();

    setState(() {});
  }

  double _calculateTotalPayments(List<Payment> payments) {
    double sum = 0.0;
    for (var payment in payments) {
      sum += (payment.valor);
    }
    return sum;
  }

  String _formatDateTime(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDateTime =
        "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";

    return formattedDateTime;
  }

  Future<void> _updateLocation() async {
    try {
      await Provider.of<LocalCache>(context, listen: false).updateLocation();
    } catch (e) {
      print("Erro ao obter localização: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userCache = Provider.of<UserCache>(context, listen: false);
    final localCache = Provider.of<LocalCache>(context);

    String _localizacao = localCache.location;
    User? _user = userCache.getLoggedInUser();
    final String email = _user?.email ?? "Email desconhecido";

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
          'Perfil',
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _localizacao,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await _updateLocation();
                    },
                    child: Text('Obter Localização'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Histórico de Compras',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Payment>>(
                future: paymentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhum item comprado.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    );
                  } else {
                    List<Payment> payments = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: payments.map((payment) {
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
                                    'Data ${_formatDateTime(payment.data)}',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'R\$ ${payment.valor.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 16.0),
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
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100.0,
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
