import 'package:aplication/Models/Cart.dart';
import 'package:aplication/Pages/ProdutosApp_page.dart';
import 'package:aplication/Service/CartCache.dart';
import 'package:aplication/Service/UserCache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartApp_page extends StatefulWidget {
  @override
  _CartApp_pageState createState() => _CartApp_pageState();
}

class _CartApp_pageState extends State<CartApp_page> {
  late List<Cart> cartItems;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final userCache = Provider.of<UserCache>(context, listen: false);
    final loggedInUser = userCache.getLoggedInUser();
    final userId = loggedInUser?.userId;

    final updatedCart = await Provider.of<CartCache>(context, listen: false)
        .getCart(userId ?? '');

    setState(() {
      cartItems = updatedCart;
    });
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
      body: cartItems == null
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(child: Text('Nenhum item no carrinho.'))
              : SingleChildScrollView(
                  child: Center(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final Cart cartItem = cartItems[index];
                        return CartItemTile(cartItem: cartItem);
                      },
                    ),
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
            if (index == 0) {
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            cartItem.nome,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'R\$ ${cartItem.valor.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
