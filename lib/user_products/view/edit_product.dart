import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/user_products/user_products.dart';
import 'package:shop_app/products/products.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProduct({super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product();
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productIdData = ModalRoute.of(context)!.settings.arguments;
      if (productIdData != null) {
        final productId = productIdData as String;
        _editedProduct = context.read<ProductsBloc>().state.findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != '') {
      context.read<ProductsBloc>().add(ProductUpdated(_editedProduct));
    } else {
      try {
        _editedProduct.id = DateTime.now().toString();
        context.read<ProductsBloc>().add(ProductAdded(_editedProduct));
      } catch (e) {
        await showDialog<void>(
          context: context,
          builder: ((cxt) => AlertDialog(
                title: const Text('Error occured!'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(cxt).pop();
                    },
                    child: const Text('Ok'),
                  )
                ],
              )),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Future(() => Navigator.of(context).pop());
  }

  void _updateState() {
    setState(() {});
  }

  Widget _buildTextFormField(String type) {
    return TextFormField(
      initialValue: _initValues[type],
      decoration: InputDecoration(
          labelText: '${type[0].toUpperCase()}${type.substring(1)}'),
      maxLines: type == 'description' ? 3 : 1,
      textInputAction: type == 'description' ? null : TextInputAction.next,
      keyboardType: type == 'price' ? TextInputType.number : null,
      onSaved: (newValue) {
        switch (type) {
          case 'title':
            _editedProduct.title = newValue!;
            break;
          case 'description':
            _editedProduct.description = newValue!;
            break;
          case 'price':
            _editedProduct.price = double.parse(newValue!);
            break;
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Provide a $type';
        }
        if (type == 'price' && double.tryParse(value) == null) {
          return 'Provide a double value';
        }
        if (type == 'price' && double.parse(value) < 0.0) {
          return 'Provide a positive value';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextFormField('title'),
                      _buildTextFormField('price'),
                      _buildTextFormField('description'),
                      ImageItem(
                          editedProduct: _editedProduct,
                          imageUrlController: _imageUrlController,
                          updateState: _updateState,
                          saveForm: _saveForm),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
