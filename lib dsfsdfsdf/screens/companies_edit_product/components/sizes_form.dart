import 'package:flutter/material.dart';
import 'package:mewnu/common/custom_icon_button.dart';
import 'package:mewnu/models/products/item_size.dart';
import 'package:mewnu/models/products/product.dart';
import 'package:mewnu/screens/companies_edit_product/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  const SizesForm(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      validator: (sizes) {
        if (sizes.isEmpty) return 'Insira um tamanho';
        return null;
      },
      builder: (state) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Medidas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  CustomIconButton(
                    iconData: Icons.add_box,
                    color: Theme.of(context).accentColor,
                    onTap: () {
                      state.value.add(ItemSize());
                      state.didChange(state.value);
                    },
                  )
                ],
              ),
              Column(
                children: state.value.map((size) {
                  return EditItemSize(
                    key: ObjectKey(size),
                    size: size,
                    onRemove: () {
                      state.value.remove(size);
                      state.didChange(state.value);
                    },
                    onMoveUp: size != state.value.first
                        ? () {
                            final index = state.value.indexOf(size);
                            state.value.remove(size);
                            state.value.insert(index - 1, size);
                            state.didChange(state.value);
                          }
                        : null,
                    onMoveDown: size != state.value.last
                        ? () {
                            final index = state.value.indexOf(size);
                            state.value.remove(size);
                            state.value.insert(index + 1, size);
                            state.didChange(state.value);
                          }
                        : null,
                  );
                }).toList(),
              ),
              if (state.hasError)
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.errorText,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}