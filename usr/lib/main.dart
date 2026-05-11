import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BillOfLadingApp());
}

class BillOfLadingApp extends StatelessWidget {
  const BillOfLadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B/L Request Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Navy blue
          background: const Color(0xFFF3F4F6),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DraftGeneratorScreen(),
      },
    );
  }
}

class DraftGeneratorScreen extends StatefulWidget {
  const DraftGeneratorScreen({super.key});

  @override
  State<DraftGeneratorScreen> createState() => _DraftGeneratorScreenState();
}

class _DraftGeneratorScreenState extends State<DraftGeneratorScreen> {
  final TextEditingController _recipientController = TextEditingController(text: 'Mr. Klay');
  final TextEditingController _shipperController = TextEditingController(text: 'TGB SUPPLYCHAIN CO., LIMITED');
  final TextEditingController _cargoController = TextEditingController(text: 'Used Cooking Oil');
  final TextEditingController _quantityController = TextEditingController(text: '12,000 MT');
  final TextEditingController _purposeController = TextEditingController(text: 'LC issuance');

  String get _generatedEmail {
    return '''Dear ${_recipientController.text},

Good day.

May we kindly request a draft of Bill of Lading prior to loading for our reference in ${_purposeController.text}.

Below shipment information for your reference:

Shipper: ${_shipperController.text}
Cargo: ${_cargoController.text}
Quantity: ${_quantityController.text}

We understand that the details may still be subject to final loaded quantity and shipment confirmation.

Your assistance would be highly appreciated.

Thank you and looking forward to your support.''';
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedEmail));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _shipperController.dispose();
    _cargoController.dispose();
    _quantityController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('B/L Request Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy Draft',
            onPressed: _copyToClipboard,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 800;
            
            if (isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildForm(),
                    ),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: _buildPreview(),
                      ),
                    ),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildForm(),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildPreview(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipment Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _recipientController,
              label: 'Recipient Name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _shipperController,
              label: 'Shipper',
              icon: Icons.business_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _cargoController,
              label: 'Cargo Description',
              icon: Icons.inventory_2_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _quantityController,
              label: 'Quantity',
              icon: Icons.scale_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _purposeController,
              label: 'Reference Purpose',
              icon: Icons.description_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Email Preview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            FilledButton.icon(
              onPressed: _copyToClipboard,
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copy'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SelectableText(
            _generatedEmail,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
