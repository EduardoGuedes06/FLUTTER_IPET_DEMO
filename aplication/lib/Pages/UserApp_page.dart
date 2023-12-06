import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplication/Models/Cart.dart';
import 'package:aplication/Pages/CartApp_page.dart';
import 'package:aplication/Pages/ProdutosApp_page.dart';
import 'package:aplication/Service/CartCache.dart';
import 'package:aplication/Service/RestService/CartServiceRest.dart';
import 'package:aplication/Service/RestService/PaymentServiceRest.dart';
import 'package:aplication/Service/UserCache.dart';
import 'package:geolocator_web/geolocator_web.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UserApp_page extends StatefulWidget {
  @override
  _UserApp_pageState createState() => _UserApp_pageState();
}

class _UserApp_pageState extends State<UserApp_page> {
  late Future<List<Cart>> cartItemsFuture;
  double total = 0.0;

  // Variáveis para armazenar informações do usuário
  String userEmail = '';
  String userLocation = '';

  @override
  void initState() {
    super.initState();
    cartItemsFuture = _loadCart();
    _loadUserInfo();
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

  Future<void> _loadUserInfo() async {
    final userCache = Provider.of<UserCache>(context, listen: false);
    final loggedInUser = userCache.getLoggedInUser();

    setState(() {
      userEmail = loggedInUser?.email ?? '';
    });

    await _obterLocalizacao();
  }

  double _calculateTotal(List<Cart> cartItems) {
    double sum = 0.0;
    for (var item in cartItems) {
      sum += (item.valor * item.qtd);
    }
    return sum;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _obterLocalizacao() async {
    try {
      Position position = await _determinePosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        // Exibir o endereço ou CEP
        setState(() {
          placemark.postalCode ?? 'Endereço desconhecido';
        });
      }
      setState(() {
        userLocation =
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      });
    } catch (e) {
      print('Erro ao obter a localização: $e');
      setState(() {
        userLocation = 'Erro ao obter a localização';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userCache = Provider.of<UserCache>(context, listen: false);
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
          'Perfil',
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Informações do usuário
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Nome do usuário
                Text(
                  '$userEmail',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Círculo com ícone de usuário
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
                // Localização do usuário
                SizedBox(height: 16),
                Text(
                  'Localização: $userLocation',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                // Botão para obter localização
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await _obterLocalizacao();
                  },
                  child: Text('Obter Localização'),
                ),
              ],
            ),
          ),

          // Lista de itens do carrinho
          // ...

          // Campo Total
          // ...
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
