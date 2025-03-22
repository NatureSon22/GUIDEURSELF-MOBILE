import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:guideurself/providers/account.dart';

class ListMessages extends StatefulWidget {
  final List messages;
  const ListMessages({super.key, required this.messages});

  @override
  State<ListMessages> createState() => _ListMessagesState();
}

class _ListMessagesState extends State<ListMessages> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant ListMessages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0, // Since `reverse: true`, 0.0 is the bottom
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _openFile(String url) async {
    try {
      final Uri fileUrl = Uri.parse(url);
      // Use mode: LaunchMode.externalApplication to open in browser/external app
      if (await canLaunchUrl(fileUrl)) {
        await launchUrl(
          fileUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint("Could not open file: $url");
      }
    } catch (e) {
      debugPrint("Error opening file: $e");
    }
  }

  String _getFileNameFromUrl(String url) {
    // Extract filename from URL or return a default name
    try {
      final Uri uri = Uri.parse(url);
      final String path = uri.path;
      return path.substring(path.lastIndexOf('/') + 1);
    } catch (e) {
      return "file";
    }
  }

  String _getFileExtension(String fileName) {
    return fileName.contains('.')
        ? fileName.substring(fileName.lastIndexOf('.') + 1).toUpperCase()
        : "";
  }

  Widget _buildFileIcon(String fileExtension) {
    IconData iconData;

    switch (fileExtension.toLowerCase()) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        break;
      case 'doc':
      case 'docx':
        iconData = Icons.description;
        break;
      case 'xls':
      case 'xlsx':
        iconData = Icons.table_chart;
        break;
      case 'zip':
      case 'rar':
        iconData = Icons.folder_zip;
        break;
      default:
        iconData = Icons.insert_drive_file;
    }

    return Icon(iconData, size: 24);
  }

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountProvider>().account;

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        final isSender = message["sender_id"] == account["_id"];
        final files = message["files"] as List? ?? [];

        return Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isSender
                  ? Colors.grey[100]?.withOpacity(0.5)
                  : const Color(0xFF12A5BC).withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isSender ? 20 : 0),
                bottomRight: Radius.circular(isSender ? 0 : 20),
              ),
              border: Border.all(
                color: isSender
                    ? const Color(0xFF323232).withOpacity(0.1)
                    : const Color(0xFF12A5BC),
                width: 1.3,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Display text message if available
                if (message["content"] != null &&
                    message["content"].toString().isNotEmpty)
                  Text(
                    message["content"],
                    style: const TextStyle(
                      color: Color(0xFF323232),
                      fontSize: 11.5,
                    ),
                  ),

                // Display files (images & other files)
                if (files.isNotEmpty) const SizedBox(height: 8),

                if (files.isNotEmpty)
                  ...files.map((file) {
                    if (file["type"] == "img") {
                      // Display image with tap to enlarge
                      return GestureDetector(
                        onTap: () {
                          // Show full image in dialog
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Image.network(
                                file["url"],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 100),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Hero(
                            tag: file["url"],
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                file["url"],
                                width: 200,
                                height: 250,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 50),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Display file with improved download button
                      final String fileName =
                          file["name"] ?? _getFileNameFromUrl(file["url"]);
                      final String fileExt = _getFileExtension(fileName);

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue[700] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _openFile(file["url"]),
                            borderRadius: BorderRadius.circular(12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildFileIcon(fileExt), // File Icon
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    fileExt.isNotEmpty
                                        ? fileExt.toUpperCase()
                                        : "File",
                                    style: TextStyle(
                                      color: isSender
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSender
                                        ? Colors.white.withOpacity(0.3)
                                        : Colors.blue[50],
                                  ),
                                  child: Icon(
                                    Icons.download_rounded,
                                    size: 20,
                                    color:
                                        isSender ? Colors.white : Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}
