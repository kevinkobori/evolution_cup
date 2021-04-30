import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mewnu/models/checkout/credit_card.dart';
import 'package:mewnu/screens/carts_checkout/components/card_text_field.dart';

class CardFront extends StatelessWidget {
  CardFront(
      {this.numberFocus,
      this.dateFocus,
      this.nameFocus,
      this.finishedFront,
      this.creditCard});

  final MaskTextInputFormatter dateFormatter = MaskTextInputFormatter(
      mask: '!#/####', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')});

  final VoidCallback finishedFront;

  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;

  final CreditCard creditCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: Stack(
        children: [
          Container(
            height: 200,
            color: Colors.purple,//(0xFF1B4B52),
            padding: const EdgeInsets.all(24),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CardTextField(
                        initialValue: creditCard.number,
                        title: 'Número',
                        hint: '0000 0000 0000 0000',
                        textInputType: TextInputType.number,
                        bold: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CartaoBancarioInputFormatter()
                        ],
                        validator: (number) {
                          if (number.length != 19)
                            return 'Inválido';
                          else if (detectCCType(number) ==
                              CreditCardType.unknown) return 'Inválido';
                          return null;
                        },
                        onSubmitted: (_) {
                          dateFocus.requestFocus();
                        },
                        focusNode: numberFocus,
                        onSaved: creditCard.setNumber,
                      ),
                      CardTextField(
                        initialValue: creditCard.expirationDate,
                        title: 'Validade',
                        hint: '11/2020',
                        textInputType: TextInputType.number,
                        inputFormatters: [dateFormatter],
                        validator: (date) {
                          if (date.length != 7) return 'Inválido';
                          return null;
                        },
                        onSubmitted: (_) {
                          nameFocus.requestFocus();
                        },
                        focusNode: dateFocus,
                        onSaved: creditCard.setExpirationDate,
                      ),
                      CardTextField(
                        initialValue: creditCard.holder,
                        title: 'Títular',
                        hint: 'João da Silva',
                        textInputType: TextInputType.text,
                        bold: true,
                        validator: (name) {
                          if (name.isEmpty) return 'Inválido';
                          return null;
                        },
                        onSubmitted: (_) {
                          finishedFront();
                        },
                        focusNode: nameFocus,
                        onSaved: creditCard.setHolder,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 24,
            right: 24,
            child: Icon(Icons.credit_card)),
        ],
      ),
    );
  }
}
