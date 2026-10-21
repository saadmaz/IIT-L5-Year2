import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../widgets/app_bar.dart';
// import '../../../widgets/navigation_drawer.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  bool _isLoading = false;
  String _searchQuery = '';
  
  // Mock documents data
  final List<Map<String, dynamic>> _documents = [
    {
      'id': '1',
      'name': 'Insurance Card.pdf',
      'type': 'Insurance',
      'date': DateTime.now().subtract(const Duration(days: 90)),
      'fileSize': '2.4 MB',
      'isStarred': true,
    },
    {
      'id': '2',
      'name': 'Medical Release Form.pdf',
      'type': 'Form',
      'date': DateTime.now().subtract(const Duration(days: 45)),
      'fileSize': '1.8 MB',
      'isStarred': false,
    },
    {
      'id': '3',
      'name': 'Physical Therapy Referral.pdf',
      'type': 'Referral',
      'date': DateTime.now().subtract(const Duration(days: 30)),
      'fileSize': '1.2 MB',
      'isStarred': true,
    },
    {
      'id': '4',
      'name': 'Physical Therapy Prescription.pdf',
      'type': 'Prescription',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'fileSize': '0.9 MB',
      'isStarred': false,
    },
  ];
  
  // Document categories based on type
  final Map<String, List<Map<String, dynamic>>> _documentsByType = {};
  
  @override
  void initState() {
    super.initState();
    // Group documents by type
    for (final doc in _documents) {
      final type = doc['type'] as String;
      if (!_documentsByType.containsKey(type)) {
        _documentsByType[type] = [];
      }
      _documentsByType[type]!.add(doc);
    }
  }
  
  List<Map<String, dynamic>> _getFilteredDocuments() {
    if (_searchQuery.isEmpty) return _documents;
    
    return _documents.where((doc) {
      final name = doc['name'].toString().toLowerCase();
      final type = doc['type'].toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase()) || 
             type.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDocs = _getFilteredDocuments();
    
    return Scaffold(
      appBar: const EPHRAppBar(title: 'Documents & Insurance'),
      drawer: NavigationDrawer(
        children: [
          NavigationDrawerDestination(
            icon: Icon(Icons.document_scanner),
            label: Text('Documents'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.uploadDocument);
        },
        backgroundColor: AppTheme.midnightTeal,
        child: const Icon(Icons.upload_file),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search documents...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppTheme.aliceBlue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                
                // Documents list
                Expanded(
                  child: filteredDocs.isEmpty
                      ? _buildNoDocumentsMessage()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredDocs.length,
                          itemBuilder: (context, index) {
                            return _buildDocumentCard(filteredDocs[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildNoDocumentsMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty 
                ? 'No documents found' 
                : 'No documents match your search',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          if (_searchQuery.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Text('Clear Search'),
            )
          else
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Document'),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.uploadDocument);
              },
            ),
        ],
      ),
    );
  }
  
  Widget _buildDocumentCard(Map<String, dynamic> document) {
    // Determine icon based on document type
    IconData typeIcon;
    switch (document['type']) {
      case 'Insurance': typeIcon = Icons.health_and_safety; break;
      case 'Form': typeIcon = Icons.description; break;
      case 'Referral': typeIcon = Icons.contact_page; break;
      case 'Prescription': typeIcon = Icons.receipt; break;
      default: typeIcon = Icons.insert_drive_file;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.aliceBlue,
          child: Icon(typeIcon, color: AppTheme.midnightTeal),
        ),
        title: Text(document['name']),
        subtitle: Text('${document['type']} • ${_formatDate(document['date'])}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (document['isStarred'])
              const Icon(Icons.star, color: Colors.amber, size: 20),
            IconButton(
              icon: const Icon(Icons.download, color: AppTheme.midnightTeal),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Download not implemented')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showDocumentOptions(document);
              },
            ),
          ],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document viewer not implemented')),
          );
        },
      ),
    );
  }
  
  void _showDocumentOptions(Map<String, dynamic> document) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.remove_red_eye),
                title: const Text('View Document'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Document viewer not implemented')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Download'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Download not implemented')),
                  );
                },
              ),
              ListTile(
                leading: Icon(document['isStarred'] ? Icons.star_border : Icons.star),
                title: Text(document['isStarred'] ? 'Remove Star' : 'Star Document'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    document['isStarred'] = !document['isStarred'];
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share not implemented')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(document);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _confirmDelete(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: Text('Are you sure you want to delete "${document['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // In a real app, we would call API to delete document
                setState(() {
                  _documents.remove(document);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document deleted')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}