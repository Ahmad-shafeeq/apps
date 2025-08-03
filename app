import 'package:flutter/material.dart';

void main() => runApp(FreelancerToolboxApp());

class FreelancerToolboxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freelancer Toolbox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    InvoicesPage(),
    ProposalsPage(),
    ClientsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Freelancer Toolbox')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Invoices'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Proposals'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ------------------- INVOICE GENERATOR -------------------

class InvoicesPage extends StatefulWidget {
  @override
  _InvoicesPageState createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  final _clientNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemAmountController = TextEditingController();

  List<Map<String, String>> _items = [];

  void _addItem() {
    if (_itemDescriptionController.text.isNotEmpty &&
        _itemAmountController.text.isNotEmpty) {
      setState(() {
        _items.add({
          'description': _itemDescriptionController.text,
          'amount': _itemAmountController.text,
        });
        _itemDescriptionController.clear();
        _itemAmountController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Invoice',
                style: Theme.of(context).textTheme.headline6),
            TextField(
              controller: _clientNameController,
              decoration: InputDecoration(labelText: 'Client Name'),
            ),
            SizedBox(height: 10),
            Text('Invoice Items', style: Theme.of(context).textTheme.subtitle1),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemDescriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _itemAmountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addItem,
                )
              ],
            ),
            SizedBox(height: 10),
            ..._items.map((item) => ListTile(
                  title: Text(item['description']!),
                  trailing: Text('\$${item['amount']}'),
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invoice export coming soon!')),
                );
              },
              child: Text('Export Invoice (PDF)'),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- PROPOSAL CREATOR -------------------

class ProposalsPage extends StatefulWidget {
  @override
  _ProposalsPageState createState() => _ProposalsPageState();
}

class _ProposalsPageState extends State<ProposalsPage> {
  final TextEditingController _proposalTitleController =
      TextEditingController();
  final TextEditingController _proposalBodyController = TextEditingController();

  void _exportProposal() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Proposal export coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _proposalTitleController,
            decoration: InputDecoration(labelText: 'Proposal Title'),
          ),
          SizedBox(height: 10),
          Expanded(
            child: TextField(
              controller: _proposalBodyController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                labelText: 'Proposal Content',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _exportProposal,
            child: Text('Export Proposal'),
          ),
        ],
      ),
    );
  }
}

// ------------------- CLIENT MANAGER -------------------

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();
  List<Map<String, String>> _clients = [];

  void _addClient() {
    if (_clientNameController.text.isNotEmpty &&
        _clientEmailController.text.isNotEmpty) {
      setState(() {
        _clients.add({
          'name': _clientNameController.text,
          'email': _clientEmailController.text,
        });
        _clientNameController.clear();
        _clientEmailController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _clientNameController,
            decoration: InputDecoration(labelText: 'Client Name'),
          ),
          TextField(
            controller: _clientEmailController,
            decoration: InputDecoration(labelText: 'Client Email'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addClient,
            child: Text('Add Client'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _clients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_clients[index]['name'] ?? ''),
                  subtitle: Text(_clients[index]['email'] ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- SETTINGS / UPGRADE -------------------

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Upgrade to Premium to unlock all features!'),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Upgrade logic coming soon.')),
              );
            },
            child: Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }
}
