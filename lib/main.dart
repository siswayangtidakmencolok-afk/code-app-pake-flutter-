import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'menu.dart';

void main() {
  runApp(const KasirApp());
}

class KasirApp extends StatelessWidget {
  const KasirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir Makanan',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const KasirHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class KasirHomePage extends StatefulWidget {
  const KasirHomePage({super.key});

  @override
  State<KasirHomePage> createState() => _KasirHomePageState();
}

class _KasirHomePageState extends State<KasirHomePage> {
  final Map<int, int> keranjang = {};

  final formatter = NumberFormat("#,###", "id_ID"); // format ribuan

  int get total {
    int sum = 0;
    keranjang.forEach((index, qty) {
      final price = (menu[index]['harga'] as num).toInt();
      sum += price * qty;
    });
    return sum;
  }

  void _tambahBarang(int index) {
    setState(() {
      keranjang[index] = (keranjang[index] ?? 0) + 1;
    });
  }

  void _kurangBarang(int index) {
    setState(() {
      if (!keranjang.containsKey(index)) return;
      if (keranjang[index]! > 1) {
        keranjang[index] = keranjang[index]! - 1;
      } else {
        keranjang.remove(index);
      }
    });
  }

  void _reset() {
    setState(() {
      keranjang.clear();
    });
  }

  void _selesaiTransaksi() {
    if (keranjang.isEmpty) return;

    final lines = <String>[];
    keranjang.forEach((index, qty) {
      final name = menu[index]['nama'];
      final price = (menu[index]['harga'] as num).toInt();
      final subtotal = price * qty;
      lines.add("$name x$qty = Rp ${formatter.format(subtotal)}");
    });

    final struk = lines.join("\n");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🧾 Cash Bon"),
        content: Text("$struk\n\nTOTAL: Rp ${formatter.format(total)}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reset();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🍔 Kasir Makanan"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reset),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: _selesaiTransaksi,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final item = menu[index];
                final qty = keranjang[index] ?? 0;
                final price = (item['harga'] as num).toInt();
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: 60,
                      height: 60,
                      child: Image.network(item["gambar"], fit: BoxFit.contain),
                    ),
                    title: Text(
                      item["nama"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Rp ${formatter.format(price)}",
                      style: const TextStyle(color: Colors.green, fontSize: 16),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.red),
                          onPressed: () => _kurangBarang(index),
                        ),
                        Text(
                          qty.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () => _tambahBarang(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black87,
            child: Center(
              child: Text(
                "Total: Rp ${formatter.format(total)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
