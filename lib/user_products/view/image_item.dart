import 'package:flutter/material.dart';

import 'package:shop_app/products/products.dart';

class ImageItem extends StatelessWidget {
  final Product editedProduct;
  final TextEditingController imageUrlController;
  final VoidCallback updateState;
  final VoidCallback saveForm;

  const ImageItem({
    Key? key,
    required this.editedProduct,
    required this.imageUrlController,
    required this.updateState,
    required this.saveForm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = imageUrlController.text;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: imageUrl.isEmpty
              ? const Text('Enter a URL')
              : FittedBox(
                  child: Uri.parse(imageUrl).isAbsolute
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/404.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
        ),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Image URL'),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            controller: imageUrlController,
            onChanged: (value) {
              updateState();
            },
            onFieldSubmitted: (_) => saveForm(),
            onSaved: (newValue) => editedProduct.imageUrl = newValue!,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Provide an image URL';
              }
              if (!Uri.parse(value).isAbsolute) {
                return 'Provide correct image URL';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
