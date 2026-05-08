import 'package:flutter/material.dart';
import 'package:mentecart_mobile/core/constants/app_colors.dart';
import 'package:mentecart_mobile/core/constants/app_dimensions.dart';

class ServiceSearchWidget extends StatefulWidget {
  final Function(String) onChanged;

  const ServiceSearchWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ServiceSearchWidget> createState() => _ServiceSearchWidgetState();
}

class _ServiceSearchWidgetState extends State<ServiceSearchWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Search services...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusDefault),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusDefault),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingDefault,
        ),
      ),
    );
  }
}