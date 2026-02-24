import 'package:flutter/material.dart';

void main() {
  runApp(const KasirApp());
}

class KasirApp extends StatelessWidget {
  const KasirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kasir',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const KasirHomePage(),
    );
  }
}

class KasirHomePage extends StatefulWidget {
  const KasirHomePage({super.key});

  @override
  State<KasirHomePage> createState() => _KasirHomePageState();
}

class _KasirHomePageState extends State<KasirHomePage> {
  final List<Map<String, dynamic>> _items = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  double get totalHarga =>
      _items.fold(0, (sum, item) => sum + (item['harga'] * item['jumlah']));

  void _tambahItem() {
    final String nama = _nameController.text;
    final double? harga = double.tryParse(_priceController.text);
    final int? jumlah = int.tryParse(_qtyController.text);

    if (nama.isNotEmpty && harga != null && jumlah != null && jumlah > 0) {
      setState(() {
        _items.add({'nama': nama, 'harga': harga, 'jumlah': jumlah});
        _nameController.clear();
        _priceController.clear();
        _qtyController.clear();
      });
    }
  }

  void _hapusItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _resetSemua() {
    setState(() {
      _items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aplikasi Kasir Sederhana"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetSemua,
            tooltip: "Reset semua",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nama Barang"),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Harga Barang"),
            ),
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jumlah"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _tambahItem,
              child: const Text("Tambah Barang"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text("Belum ada barang ditambahkan"))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        final subtotal = item['harga'] * item['jumlah'];
                        return Card(
                          child: ListTile(
                            title: Text(item['nama']),
                            subtitle: Text(
                              "Harga: Rp ${item['harga']} x ${item['jumlah']} = Rp $subtotal",
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _hapusItem(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Text(
              "Total Belanja: Rp $totalHarga",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
