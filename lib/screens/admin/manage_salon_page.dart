import 'package:flutter/material.dart';
import 'package:salon_kecantikan/models/salon_model.dart';
import 'package:salon_kecantikan/services/salon_service.dart';

class ManageSalonPage extends StatefulWidget {
  const ManageSalonPage({super.key});

  @override
  State<ManageSalonPage> createState() => _ManageSalonPageState();
}

class _ManageSalonPageState extends State<ManageSalonPage> {
  /// THEME COLORS
  final Color colorDeepRose = const Color(0xFFB55163);
  final Color colorRosePink = const Color(0xFFDF8B92);

  /// STATE VARIABLES
  List<SalonModel> salonList = [];
  bool _isLoading = false;

  /// CONTROLLERS
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _servicesController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshData(); // Ambil data dari server saat pertama kali buka
  }

  /// REFRESH DATA DARI API
  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    try {
      final data = await SalonService.getSalons();
      setState(() {
        salonList = data;
      });
    } catch (e) {
      _showSnackBar("Gagal memuat data: $e", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// FORM TAMBAH / EDIT
  void _showForm(SalonModel? salon) {
    if (salon != null) {
      _nameController.text = salon.name;
      _addressController.text = salon.address;
      _phoneController.text = salon.phone;
      _servicesController.text = salon.services;
      _priceController.text = salon.price.toString();
    } else {
      _nameController.clear();
      _addressController.clear();
      _phoneController.clear();
      _servicesController.clear();
      _priceController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                salon == null ? "Tambah Salon Baru" : "Edit Data Salon",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorDeepRose,
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField(_nameController, "Nama Salon", Icons.store),
              _buildTextField(_addressController, "Alamat", Icons.location_on),
              _buildTextField(
                _phoneController,
                "Telepon",
                Icons.phone,
                inputType: TextInputType.phone,
              ),
              _buildTextField(_servicesController, "Layanan", Icons.list),
              _buildTextField(
                _priceController,
                "Harga Standar",
                Icons.attach_money,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorDeepRose,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (salon == null) {
                      _addSalon();
                    } else {
                      _editSalon(salon.id!);
                    }
                  },
                  child: Text(
                    salon == null ? "SIMPAN" : "UPDATE",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CREATE (REAL API)
  Future<void> _addSalon() async {
    final newSalon = SalonModel(
      id: 0, // ID akan digenerate otomatis oleh database
      name: _nameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      services: _servicesController.text,
      price: double.tryParse(_priceController.text) ?? 0,
    );

    try {
      Navigator.pop(context); // Tutup bottom sheet dulu
      setState(() => _isLoading = true);
      await SalonService.createSalon(newSalon);
      _showSnackBar("Data berhasil ditambahkan");
      _refreshData(); // Reload list
    } catch (e) {
      _showSnackBar("Gagal menambah data: $e", isError: true);
      setState(() => _isLoading = false);
    }
  }

  /// UPDATE (REAL API)
  Future<void> _editSalon(int id) async {
    final updatedSalon = SalonModel(
      id: id,
      name: _nameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      services: _servicesController.text,
      price: double.tryParse(_priceController.text) ?? 0,
    );

    try {
      Navigator.pop(context);
      setState(() => _isLoading = true);
      await SalonService.updateSalon(id, updatedSalon);
      _showSnackBar("Data berhasil diperbarui");
      _refreshData();
    } catch (e) {
      _showSnackBar("Gagal memperbarui: $e", isError: true);
      setState(() => _isLoading = false);
    }
  }

  /// DELETE (REAL API)
  Future<void> _deleteSalon(int id) async {
    try {
      setState(() => _isLoading = true);
      await SalonService.deleteSalon(id);
      _showSnackBar("Data salon berhasil dihapus");
      _refreshData();
    } catch (e) {
      _showSnackBar("Gagal menghapus: $e", isError: true);
      setState(() => _isLoading = false);
    }
  }

  /// KONFIRMASI HAPUS
  void _confirmDelete(SalonModel salon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus salon \"${salon.name}\"?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteSalon(salon.id!);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text(
          "Kelola Salon",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorDeepRose,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : salonList.isEmpty
              ? const Center(child: Text("Data salon masih kosong"))
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: salonList.length,
                    itemBuilder: (context, index) {
                      return _buildSalonCard(salonList[index]);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorDeepRose,
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// CARD SALON (UI tetap sama)
  Widget _buildSalonCard(SalonModel salon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(
          backgroundColor: colorRosePink.withOpacity(0.2),
          child: Icon(Icons.store, color: colorDeepRose),
        ),
        title: Text(
          salon.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(salon.address, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              "Layanan: ${salon.services}",
              style: TextStyle(fontSize: 12, color: colorDeepRose),
            ),
            Text(
              "Rp ${salon.price.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
              onPressed: () => _showForm(salon),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () => _confirmDelete(salon),
            ),
          ],
        ),
      ),
    );
  }

  /// REUSABLE TEXTFIELD (UI tetap sama)
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: colorDeepRose, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}