import 'package:flutter/material.dart';

class TagsSection extends StatefulWidget {
  const TagsSection({super.key});

  @override
  State<TagsSection> createState() => _TagsSectionState();
}

class _TagsSectionState extends State<TagsSection> {
  List<String> tags = ['Work'];

  Future<String?> _editTagDialog(int? index) async {
    final controller = TextEditingController(
      text: index != null ? tags[index] : "",
    );

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? "New Tag" : "Edit Tag"),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: "Tag name"),
          ),
          actions: [
            if (index != null)
              TextButton(
                onPressed: () {
                  setState(() => tags.removeAt(index));
                  Navigator.pop(context);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (int i = 0; i < tags.length; i++)
                InkWell(
                  onTap: () => _editTagDialog(i),
                  child: Chip(
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                    // tighter width
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    // reduces height
                    visualDensity: const VisualDensity(
                      horizontal: 0,
                      vertical: -2,
                    ),
                    backgroundColor: Colors.blue[50],
                    // light blue background
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent),
                      // remove border
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // more curved edges
                    ),
                    label: Text(
                      tags[i],
                      style: TextStyle(
                        color: Colors.blue[800], // darker blue text
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    deleteIcon: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.blue[700], // darker blue icon
                    ),
                    onDeleted: () {
                      setState(() => tags.removeAt(i));
                    },
                  ),
                ),
            ],
          ),
        ),

        TextButton(
          onPressed: () async {
            final newTag = await _editTagDialog(null);
            if (newTag != null && newTag.trim().isNotEmpty) {
              setState(() => tags.add(newTag.trim()));
            }
          },
          child: const Text("+ Add tag"),
        ),
      ],
    );
  }
}
