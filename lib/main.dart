import 'package:flutter/material.dart';
import 'details_page.dart';
import 'invioces_page.dart';
import 'invoice.dart';
import 'product.dart';
void main() {
  runApp(
      MaterialApp(
        routes: {
          '/' : (context) => MainPage(),
          '/invoicesPage' : (context) => InvoicesPage(),
          '/detailsPage' : (context) => DetailsPage(),
        },
      )
  );
}
TextEditingController cnameController = TextEditingController();
TextEditingController pnameController = TextEditingController();
TextEditingController priceController = TextEditingController();
TextEditingController quantityController = TextEditingController();

class MainPage extends StatefulWidget {
 List<Product> products = [];
static List<Invoice> invoices = [];
int invoiceNo = 1;


  @override
  _MainPageState createState() => _MainPageState();

 MainPage({Key? key}) : super(key: key);
}

class _MainPageState extends State<MainPage> {
  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          title: Text('Product Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(

                autofocus: false,
                controller: pnameController,
                decoration: InputDecoration(
                  labelText: 'product name',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                autofocus: false,
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'price',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                autofocus: false,
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'quantity',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {

                  int q = 0;
                  double p = 0;
                  if(pnameController.text.isEmpty) {
                    const snackBar = SnackBar(content: Text('please Enter product name'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  try {
                    q = int.parse(quantityController.text);
                    p = double.parse(priceController.text);
                  }
                  catch(e) {
                    var snackBar = SnackBar(content: Text('error ${e.toString()}'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  widget.products.add(Product(name: pnameController.text,
                      price: p,
                      quantity: q));
                  pnameController.clear();
                  priceController.clear();
                  quantityController.clear();
                  Navigator.of(context).pop();
                  setState(() {

                  });
                },
                child: Text('add')
            ),
            ElevatedButton(

                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('cancel')
            ),
          ],
        ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice# ${widget.invoiceNo}'),
      ),
      body: Column(
        children: [
          TextField(
            autofocus: false,
            controller: cnameController,
            decoration: InputDecoration(
              labelText: 'customer name',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Products:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
              ElevatedButton(
                  onPressed: () {
                    _showDialog(context);
                  },
                  child: Text('add product')
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: Colors.blue,
                      leading: Text(widget.products[index].name,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                      title: Text('price: ${widget.products[index].price}'),
                      subtitle: Text('Quantity: ${widget.products[index].quantity}'),
                      trailing: IconButton(
                        onPressed: () {
                          widget.products.removeAt(index);
                          setState(() {

                          });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  );
                },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(

                  onPressed: () {
                    if(cnameController.text.isEmpty)
                      {
                        const snackBar = SnackBar(content: Text('please Enter customer name'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                    MainPage.invoices.add(
                      Invoice(invoiceNo: widget.invoiceNo++,
                          customerName: cnameController.text,products: widget.products)
                    );
                    cnameController.clear();
                    widget.products = [];
                    setState(() {

                    });
                  },
                  child: Text('add invoice')
              ),
              ElevatedButton(

                  onPressed: () {
                    Navigator.pushNamed(context, '/invoicesPage');
                  },
                  child: Text('show all invoices')
              ),
            ],
          ),
        ],
      ),
    );
  }
}