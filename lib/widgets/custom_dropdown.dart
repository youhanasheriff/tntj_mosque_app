import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tntj_mosque/config/config.dart';

class CustomDropDown<T> extends StatelessWidget {
  final List<T> lists;
  final String searchText;
  final String title;
  final void Function(T?)? onChange;
  final T selectedArea;
  final bool isTitle;

  const CustomDropDown({
    Key? key,
    required this.lists,
    required this.searchText,
    this.title = "",
    required this.onChange,
    required this.selectedArea,
    this.isTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: DropdownSearch<T>(
        mode: Mode.MENU,
        showSelectedItems: true,
        items: lists,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          autocorrect: false,
          decoration: InputDecoration(
            labelText: searchText,
          ),
        ),
        dropdownSearchDecoration: const InputDecoration(
          disabledBorder: InputBorder.none,
          border: InputBorder.none,
        ),
        popupShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        dropdownBuilder: (context, str) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isTitle) ...[
                Text(
                  title,
                  style: const TextStyle(
                    color: themeBlue,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12.0),
              ],
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Text(
                  str as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        },
        onChanged: onChange,
        selectedItem: selectedArea,
      ),
    );
  }
}
