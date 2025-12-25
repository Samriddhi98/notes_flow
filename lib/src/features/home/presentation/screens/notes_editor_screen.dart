import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes_flow/src/core/widgets/custom_text_field.dart';
import 'package:notes_flow/src/features/home/presentation/widgets/tags_section.dart';

@RoutePage()
class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title TextField
            EbTextFormField(
              controller: titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 8),

            // Tags Row
            TagsSection(),

            const SizedBox(height: 8),

            // Body TextField
            Expanded(
              child: TextField(
                controller: bodyController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Start typing...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Toolbar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _bottomButton(icon: Icons.image, label: "Image"),
            _bottomButton(icon: Icons.mic, label: "Voice"),
            _bottomButton(icon: Icons.check_box, label: "Checklist"),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
