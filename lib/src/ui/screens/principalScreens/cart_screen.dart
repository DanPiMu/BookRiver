import 'package:book_river/src/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/book.dart';

import '../../../provider/navigation_notifier.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Book> cartItems = [];

  @override
  void initState() {
    cartItems = Provider.of<NavigationNotifier>(context, listen: false).books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _customAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: cartItems.isNotEmpty
                    ? ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = cartItems[index];
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 100,
                                  child: item.caratula?[0].img == null
                                      ? Image.asset(
                                          'assets/images/portada.jpeg')
                                      : Image.network(
                                          item.caratula![0].img!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Image.asset(
                                                'assets/images/portada.jpeg');
                                          },
                                        ),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8.0),
                                    Text(item.author!),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      '${item.price.toString()}€',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: AppColors.tertiary)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove,
                                                color: AppColors.tertiary),
                                            onPressed: () {
                                              Provider.of<NavigationNotifier>(
                                                      context,
                                                      listen: false)
                                                  .removeUnitsToProduct(
                                                      item, 1);
                                              setState(() {});
                                            },
                                          ),
                                          Text(item.units.toString()),
                                          IconButton(
                                            icon: Icon(Icons.add,
                                                color: AppColors.tertiary),
                                            onPressed: () {
                                              Provider.of<NavigationNotifier>(
                                                      context,
                                                      listen: false)
                                                  .addUnitsToProduct(item, 1);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                        'No tienes ningun producto en el carrito',
                        style: TextStyle(color: Colors.black),
                      )),
              ),
              const Divider(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 13.0, right: 13),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryCake,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Preu total',
                            style: TextStyle(
                                color: AppColors.secondary, fontSize: 20),
                          ),
                          Text(
                              ' ${context.select((NavigationNotifier c) => c.total)}€',
                              style: TextStyle(
                                  color: AppColors.secondary, fontSize: 20))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<NavigationNotifier>(
                            context,
                            listen: false)
                            .removeAllUnitsFromCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: cartItems.isEmpty ? Text('El carrito esta vacio'): Text('Comprado!')),
                        );
                        setState(() {});

                      }, child: const Text('Comprar')),
                ),
              )
            ],
          ),
        ));
  }

  _customAppBar(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset(
            "assets/images/BookRiver_logo_horizontal.png",
            height: 30,
            width: 150,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
