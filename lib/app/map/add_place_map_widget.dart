import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/domain/entities/place_type.dart';

class AddPlaceMapWidget extends StatefulWidget {
  const AddPlaceMapWidget({
    super.key,
    required this.onAdd,
  });

  final void Function(String, String, String) onAdd;

  @override
  State<AddPlaceMapWidget> createState() => _AddPlaceMapWidgetState();
}

class _AddPlaceMapWidgetState extends State<AddPlaceMapWidget> {
  late void Function(String, String, String) onAdd;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initialize() {
    onAdd = widget.onAdd;
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void didUpdateWidget(covariant AddPlaceMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 15,
        left: 30,
        right: 30,
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final v = value ?? '';
                if (v.isEmpty) {
                  return 'Preencha o título';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 2,
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final v = value ?? '';
                if (v.isEmpty) {
                  return 'Preencha a descrição';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
              value: PlaceType.fromParam(typeController.text).param,
              items: PlaceType.values
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e.param,
                      child: Text(e.param),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  typeController.text = value ?? '';
                });
              },
              validator: (value) {
                final v = value ?? '';
                if (v.isEmpty) {
                  return 'Preencha a tipo';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Get.back();
                  Get.showSnackbar(
                    const GetSnackBar(
                      message: 'Adicionando local...',
                      duration: Duration(
                        seconds: 1,
                      ),
                      showProgressIndicator: true,
                    ),
                  );
                  onAdd(titleController.text, descriptionController.text, typeController.text);
                }
              },
              child: const Text('Adicionar local'),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
